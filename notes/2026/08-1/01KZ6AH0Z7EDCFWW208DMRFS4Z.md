---
id: 01KZ6AH0Z7EDCFWW208DMRFS4Z
created: 2026-08-04T12:03:43.719793Z
updated: 2026-08-04T15:00:56.728462Z
type: task
title: Cloudflare routes-to harvest — connect tunnels and Workers to their zones on the graph
project: 01KX671DATY39VW6GWK3M2T3DN
number: 532
order: 1.0
sprint: skxht3g
assignee: steve
priority: medium
task_status: todo
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
