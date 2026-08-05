---
id: 01KZ6AH0Z7EDCFWW208DMRFS4Z
created: 2026-08-04T12:03:43.719793Z
updated: 2026-08-05T13:39:04.904003Z
type: task
title: Cloudflare routes-to harvest — connect tunnels and Workers to their zones on the graph
project: 01KX671DATY39VW6GWK3M2T3DN
number: 532
order: 1.0
sprint: skxht3g
comments:
- id: 01KZ6R55AK4Z9Q1Z4QXR7V7E9H
  author: Steve Vine
  at: 2026-08-04T16:01:55.027533Z
  text: |-
    PR #456 — https://github.com/Steve-vine/ise/pull/456

    Both joins built as scoped, exact-id only:
    - zone → tunnel from the zone's CNAMEs matching `{tunnel_id}.cfargotunnel.com` (DNS, not the tunnel config API — covers locally-managed tunnels too, as the ticket reasoned).
    - zone → Worker from BOTH surfaces: `/zones/{id}/workers/routes` and `/accounts/{id}/workers/domains`. The fixture includes a Worker bound ONLY by a custom domain, so dropping either surface fails a test.

    Deliberately kept: DNS records still are not entities (ADR 0062 §3) — read for the one id they carry, thrown away. The old `test_dns_records_are_never_fetched_by_discovery` was rewritten to assert what actually matters (nothing DNS-shaped becomes an entity, type set unchanged) rather than deleted.

    Unresolvable targets (dangling CNAME, route to a retired script) are dropped and COUNTED in one warning — the ISE-522 precedent, done since it was cheap. Two hostnames on one tunnel = one edge. Per-zone containment tested both ways (routes refusal keeps tunnel + custom-domain edges; DNS refusal keeps worker edges and still discovers the tunnel as unbound).

    No frontend work needed and none done: `routes-to` is already first-class in the graph (colour/filter in lib/graph.ts, phrasing in ImpactPanel), so edges render under the existing ADR 0041 §3 provenance rules. Worth eyeballing a zone with several Workers at default ring depth during smoke.

    OUTSTANDING — the token probe did NOT happen. `kubectl exec` into ise-api was blocked in this session, so whether the token needs `Workers Routes:Read` is still unknown. Per the ticket the code does not degrade silently: a refusal logs `cloudflare worker routes read failed` with the zone and Cloudflare's own error prose. If those show up after deploy, the grant is Steve's action.
- id: 01KZ6XK16C6HG30325FCJQDA9F
  author: Steve Vine
  at: 2026-08-04T17:36:52.428579Z
  text: |-
    LIVE VERIFICATION after the staging deploy (2026-08-04 ~17:35) — HALF WORKING, and the token question is now ANSWERED.

    WORKING — zone → tunnel: **12 `routes-to` edges from zone entities to tunnels** now exist in the live estate. The DNS CNAME join lands exactly as designed, so the tunnels have stopped being islands. `cloudflare routing targets did not resolve ×1` also appeared, which is the dangling-CNAME counter doing its job rather than silently dropping.

    NOT WORKING — zone → Worker: **zero** Worker edges, because `cloudflare worker routes read failed` fired **×33** (once per zone) in the first sync. That is the ticket's own prediction confirmed: **the API token lacks `Workers Routes:Read`**. The per-zone containment held — the refusal cost only the Worker edges, and the tunnel edges and zone entities came through untouched.

    STEVE'S ACTION: add `Workers Routes:Read` (zone-level) to the Cloudflare API token. The Worker edges will appear on the next sync with no code change. Until then the graph correctly shows Workers as unbound rather than guessing.

    Worth noting how this was found: not by grepping kubectl, but as a single grouped row on ISE-531's new Platform Log — 33 identical warnings collapsed into one line with a count. That is the surface working as intended on its first day.
- id: 01KZ6ZHHJ70NJ508S0N7R3HTV8
  author: Steve Vine
  at: 2026-08-04T18:11:00.807394Z
  text: |-
    ACCEPTANCE MET IN FULL — 2026-08-04 18:07, after Steve granted `Workers Routes:Read`.

    The first sync following the grant produced ZERO `worker routes read failed` warnings (last occurrence 17:51, before the change; 132 in total while the scope was missing). The Worker edges materialised with no code change, exactly as predicted.

    Live estate now:

    | | discovered | fronted by a zone | still islands |
    |---|---|---|---|
    | Tunnels | 11 | 8 | 3 |
    | Workers | 8 | 5 | 3 |

    Cloudflare has gone from contributing **zero** edges to the graph to 18 `routes-to` edges — 12 zone→tunnel, 6 zone→Worker across 5 distinct Workers (one Worker is fronted by more than one zone). That is the DoD verbatim: the tunnels and Workers stop being orphans except the genuinely unbound ones, which the graph now correctly SHOWS as unbound.

    The 6 remaining islands are plausible real states — a tunnel with no public CNAME, a Worker bound by neither a route nor a custom domain — and worth an eyeball during smoke rather than being assumed a bug.

    Residual, by design: `cloudflare routing targets did not resolve ×2` still fires — a CNAME or route naming something no longer discovered (deleted tunnel, retired script). The ticket scoped that to a COUNT only, so the log does not say WHICH two. If that turns out to matter when someone tries to clean them up, naming them is a small follow-up.
- id: 01KZ71RH19P2CDQSXPBZ7H86VK
  author: Steve Vine
  at: 2026-08-04T18:49:46.793572Z
  text: 'Live verification 2026-08-04 (Claude): landed cleanly, with the predicted token gap playing out exactly as the task warned. Deploy at ~17:15 → worker-routes read 403''d on all 33 zones × 4 syncs (132 Platform Log rows — ISE-531''s first real diagnostic win); Steve granted Workers Routes:Read ~17:50; the 18:06 sync came back clean and built the edges: 12 zone→tunnel + 6 zone→Worker routes-to, with 6 unresolvable routing targets counted honestly ("cloudflare routing targets did not resolve", evidence in extra). Tunnels and Workers are no longer islands on the graph. DoD met.'
assignee: steve
priority: medium
task_status: done
---
The open thread recorded when the Cloudflare sprint (s39ax46, ADR 0062) shipped, promoted to a task by functional testing 2026-08-04: after the re-enable, the 33 zones, 11 tunnels and 8 Workers all landed cleanly — but as islands. The only edge the connector emits is CF load-balancer → zone `part-of` (`cloudflare.py:1170`), and this estate has no CF load balancers, so Cloudflare contributes **zero edges** to the graph. The relationships exist in Cloudflare's API; the connector doesn't read them.

## Scope — two deterministic joins, both `routes-to` from the zone

### 1. Zone → tunnel, via DNS CNAMEs

A tunnel's public hostnames are CNAME records in the zone pointing at `{tunnel_id}.cfargotunnel.com`. Sweep each zone's DNS records, match the suffix, take the tunnel id from the CNAME **content** — an exact join, no name matching. Emit zone → tunnel `routes-to`, resolved in-batch (both sides discovered already).

Why DNS and not the tunnel config API: `cfd_tunnel/{id}/configurations` only answers for **remotely-managed** tunnels — a locally-managed tunnel's ingress lives in its `config.yml`, invisible to the API. The CNAME must exist either way, so the DNS route covers both management modes.

Credential: already covered — the connector reads `/zones/{zone_id}/dns_records` today for the `list_dns_records` evidence query (`cloudflare.py:876`), so the token has DNS read.

### 2. Zone → Worker, via routes AND custom domains

- `GET /zones/{zone_id}/workers/routes` — pattern → script; edge zone → Worker (`workload` entity) per referenced script.
- `GET /accounts/{account}/workers/domains` — Worker Custom Domains, the newer binding surface; each row carries `zone_id` + `service`. A Worker bound only via a custom domain has **no route entry**, so reading only one surface misses those.

**Verify the token first:** script listing works at account level today, but the zone-scoped route read may need the `Workers Routes:Read` zone permission added to the API token. Probe with the stored credential before building (the entra/azure probe-in-pod pattern from this session); if a grant is needed it is Steve's action — say so in the PR rather than degrading silently.

## Cost and failure shape

~2 calls per zone per sync (~66 for this estate). Same bounded fan-out as the ELB target-group precedent (ADR 0058 §3). Each zone's slice fails independently — a 403 on worker routes costs those edges, never the zones (the established per-slice warning pattern; ISE-531's Platform Log will make those visible).

## Deliberately out of scope

- **Tunnel → origin service** (the ingress rules' service targets): `localhost:8080`-shaped strings on locally-managed tunnels, mostly unjoinable to estate entities — no edges beat guessed edges (ADR 0028). Revisit only if remotely-managed tunnels with joinable targets appear.
- Dangling CNAMEs (pointing at a deleted tunnel's id) name no discovered entity, so the edge is dropped by resolution — fine, but worth a per-sync count if cheap (the ISE-522 unresolvable-target precedent).

## UI

No new surface — edges appear on the existing estate graph/Explorer. Check the edge renders with sensible provenance (dashed-unconfirmed rules per ADR 0041 §3 apply as-is), and that a zone with a dozen Workers reads acceptably at default ring depth.

## Definition of done

An operator selects a tunnel or Worker on the estate graph and sees which zones route to it; a zone shows what it fronts. Verified against the live estate: the 11 tunnels and 8 Workers stop being orphans (except any genuinely unbound ones — which the graph then correctly shows as unbound, itself useful).
