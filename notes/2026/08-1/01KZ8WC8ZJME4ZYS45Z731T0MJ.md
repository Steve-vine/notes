---
id: 01KZ8WC8ZJME4ZYS45Z731T0MJ
created: 2026-08-05T11:54:11.314643Z
updated: 2026-08-07T10:06:55.596247Z
type: task
title: DNS routes-to mapping — publish Azure App Service hostnames as `dns:` cross-keys and harvest zone edges
project: 01KX671DATY39VW6GWK3M2T3DN
number: 556
sprint: skxht3g
comments:
- id: 01KZ93F4TXDEYDFDCBJ47RES4F
  author: Steve Vine
  at: 2026-08-05T13:58:05.405673Z
  text: |-
    Built on feature/ise-556-dns-routes-to — PR #474 (full CI green), merged to staging. **ADR 0082** records the ruling.

    **The join, as approved.** The Azure connector emits `cross_keys=["dns:<default_hostname>"]` for App Services and Functions, plus AKS `fqdn` (free — the value was already in the payload). `_attach_routing_edges` emits `routes-to` → `dns:<cname target>` for every CNAME it does not already consume for a tunnel or Worker. Resolution, merge safety, ambiguity and retraction are the existing `reconcile_discovered` edge pass, untouched. Zero new API calls either side, no schema change, no migration. No screen work — the canvas already draws `routes-to`.

    **Normalisation.** One helper, `dns_key()` in `connectors/base.py`, used by both sides; the Cloudflare fixture states the hostname in mixed case WITH a trailing dot precisely because a divergence here fails silently and "no edges" is indistinguishable from "no matches".

    **No unresolved-target warning**, as instructed. And they are kept out of `edges_unresolved` too: that counter means "a link ISE should have been able to make went nowhere", and ~450 third-party targets would swamp it 30:1. They land in a new `dns_unmatched` counter instead, so neither number lies.

    One read per zone still — `_cname_targets` is shared by the tunnel harvest and this one. A second DNS list per zone would have spent the whole saving.

    Tests: end-to-end through the real reconciler (Azure entity publishing the key + Cloudflare zone CNAME → a resolved `routes-to` edge, with the SaaS target in `dns_unmatched` and `edges_unresolved` at 0); normalisation both sides; a third-party target emitted and never warned about; a tunnel hostname not double-claimed; one DNS read per zone; Azure publishing for App Service / Functions / AKS and NOT for a site with no hostname.

    Gotcha for the record: `test_azure_alerts` shares `test_azure_discovery`'s PAYLOADS, so the two extra fixture sites changed a subscription rollup count in another file — module-level tests were green, only the full suite caught it.

    **Acceptance is still to verify on staging**: the 16 measured pairs need a Cloudflare + Azure sync to land before the edges appear. `payments.moneypenny.com` → `app-mp-prd-uks-payments` on the estate graph is the check.
- id: 01KZ93REGWFB476N67D18JKNX8
  author: Steve Vine
  at: 2026-08-05T14:03:10.23586Z
  text: |-
    **Acceptance VERIFIED on staging, live data.** Deployed `staging-20260805-1359`, then ran an Azure sync followed by a Cloudflare sync.

    - Azure published **72 `dns:` aliases** (baseline was 0).
    - Cloudflare's reconcile then created **exactly 16 edges** — the 16 measured pairs, no more, no fewer:

    | zone | reaches |
    |---|---|
    | moneypenny.com | app-mp-prd-uks-payments, app-mp-prd-uks-account, wafc-mp-prd-uks-oneportal, app-mp-prd-uk-accountrouting-web, app-mp-prd-uk-callrecording-web, aps-mp-prd-uks-clientrouting-api, aps-mp-prd-uks-digitalswitchboard, aps-mp-prd-uks-notification-teamscall, aps-mp-prd-uks-onboarding-teamscall, aps-mp-prd-uks-storage-teamscall, aps-mp-prod-uks-apicallrouting, aps-mp-prod-uks-clienttasapi, aps-mp-prod-uks-pocketportal, aps-mp-prod-uks-tasmobileapi, mp-clevernumbersportal |
    | moneypenny.co.uk | app-mp-prd-uks-reception-desk |

    The counter separation earned its keep: **`dns_unmatched` = 530, `edges_unresolved` = 0**. Folded together, the third-party SaaS population would have turned a meaningful "a link went nowhere" number into noise. And the existing `cloudflare routing targets did not resolve` warning still reads **"4 route/CNAME targets"** — its pre-existing dead tunnel/Worker refs — so the ~530 hostnames did not leak into it, and no new warning row was raised.

    (That warning row is also now attributed to `Cloudflare` in the Platform Log, which incidentally confirms ISE-552 on live data too.)

    Remaining for the UI check: the estate graph draws these already; `payments.moneypenny.com` → `app-mp-prd-uks-payments` is visible from either node.
assignee: steve
priority: medium
task_status: done
---
Option A of the ISE-398 investigation, **approved by Steve 2026-08-05**. The design and the measurement live in `docs/briefs/dns-routes-to-mapping.md`; this is the build.

## What it delivers

The estate graph gains an edge from a Cloudflare zone to the workload a public hostname actually reaches. Measured against the live account: **16 exact matches, all Azure App Services, all production** — `payments.moneypenny.com` → `app-mp-prd-uks-payments`, `account.moneypenny.com` → `app-mp-prd-uks-account`, `oneportal`, `visitors.moneypenny.co.uk`, `telephoneanswering`, `pocket`, `ukta`, `callrecording`, `clientroutingapi`, `callroutingtwilio`, `digitalswitchboardazure`, `accountrouting`, `numbers-backup`, and the three `teamsbot-*`.

Sixteen production services whose public entry point the graph currently cannot name.

## The approach (approved)

**A public hostname becomes part of an entity's identity** — a `dns:` alias namespace — rather than merely an attribute. That is the ruling this ticket rests on, and it is what makes the join free:

1. The Azure connector emits `cross_keys=["dns:<default_hostname>"]` for App Services and Functions (and AKS `fqdn`, which comes free). The owner materialises them as alias rows exactly as it does for `datadog:service:*` today.
2. `CloudflareConnector._zone_routing_edges` emits `DiscoveredEdge(target_native_key=f"dns:{target}", edge_type="routes-to")` for CNAME targets it does not already consume for a tunnel or Worker.
3. Resolution, merge safety, ambiguity handling and retraction are the existing `reconcile_discovered` edge pass — no new machinery.

Exact string equality between two values the providers *stated*, so tier 1, not a guess (ADR 0028 holds).

## Scope

**In**: Azure App Service / Functions `default_hostname`, AKS `fqdn`.

**Out of v1**: AWS. Measured 29 ELB-shaped CNAME targets against 6 known ELBs with **zero overlap** — every ELB ISE knows is Kubernetes-ingress-created; the CNAMEs point at balancers it does not have. That is an estate-coverage question, not a join question. A records are out permanently (ISE stores only EC2 `private_ip`, which is not what a public A record points at).

**Not this ticket**: the App Gateway FQDN gap, and the AWS load-balancer coverage gap. Both noted in the brief as follow-ups.

## Watch out for

- **Normalisation is the implementation risk, not the matching.** Cloudflare already lower-cases and strips the trailing dot; Azure returns its own casing. If the two sides normalise differently the join silently yields nothing — and "no edges" is indistinguishable from "no matches". One shared helper, exercised with a trailing dot and mixed case.
- **Do NOT add an unresolved-target warning.** ~450 of the 465 distinct targets are third-party SaaS (googlehosted, outlook, sendgrid, hubspot, mailgun) and are correctly unresolvable. Under ADR 0077 every warning is a screen row an operator reads. Skip them silently.
- The existing `cloudflare routing targets did not resolve` warning does **not** count this population — `_tunnel_ids_fronted` filters CNAME contents to `.cfargotunnel.com` first, so an App Service target never reaches that counter.

## Needs an ADR

The identity ruling is an architecture decision and must be recorded (CLAUDE.md hard rule): a public hostname may be part of entity identity, extending ADR 0028's identity model and closing ADR 0062 §3's deferral. Take the next free number at the time — 0079/0080 are drafted for the voice sprint and 0081 is taken.

## Definition of done

An operator can see, on the estate graph, that `payments.moneypenny.com` reaches `app-mp-prd-uks-payments`. Acceptance is the 16 measured pairs above — a fixed checkable list, so no new instrumentation is needed to know whether it worked. Zero new API calls on either side; no schema change, no migration (`routes-to` is already in `EDGE_TYPES`, `dns:` is an alias key namespace).