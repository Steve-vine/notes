---
id: 01KZ6AH0Z7EDCFWW208DMRFS4Z
created: 2026-08-04T12:03:43.719793Z
updated: 2026-08-04T16:01:55.910675Z
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
assignee: steve
label: null
priority: medium
task_status: review
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
