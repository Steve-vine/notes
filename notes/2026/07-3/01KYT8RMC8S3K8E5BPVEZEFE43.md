---
id: 01KYT8RMC8S3K8E5BPVEZEFE43
created: 2026-07-30T19:42:02.632924Z
updated: 2026-08-05T12:34:03.030056Z
type: task
title: Cloudflare discovery — zones, tunnels, load balancers, Workers/Pages → estate entities
project: 01KX671DATY39VW6GWK3M2T3DN
number: 382
sprint: s39ax46
blocked_by:
- 01KYT8RA7RR5MTXDH46MARARHY
comments:
- id: 01KYTGA7TVG2N3B5C0FTC2TEVE
  author: Steve Vine
  at: 2026-07-30T21:53:59.642896Z
  text: |-
    Built and in review — PR #357 (feature/ise-382-cloudflare-discovery, stacked on #356, targeting main), merged to staging (c417fad).

    Delivered: discovery of the full agreed product surface. Zones → new `zone` entity type and Tunnels → new `tunnel` type via migration 0074 (the 0070/0072 CHECK-swap pattern; downgrade deletes rows of the new types). Tunnel health (healthy/degraded/down/inactive) captured as a status attribute. Load balancers reuse the generic load-balancer type — pools resolved to readable names through one account-level sweep and stored as attributes, with a part-of edge to the owning zone that resolves in-batch (verified against real Postgres). Workers scripts and Pages projects → workload with product-qualified keys (worker/… vs pages/…) so same-named ones stay distinct. Native keys account-scoped cloudflare:{account_id}:{resource_id}, bounded per the ISE-368 varchar(300) lesson. No cross_keys and no tags — Cloudflare has neither (tag pool unaffected).

    Two deliberate absences pinned by tests: DNS records are never fetched by discovery (evidence-only decision), and each product sweep fails independently — a token missing one permission group degrades that slice to a warning; a zone without load balancing enabled refuses its LB list quietly (debug, not warning, to avoid noise).

    OpenAPI snapshot regenerated (the entity-type query pattern embeds ENTITY_TYPES); generated schema.d.ts unchanged so no frontend code impact — estate UI display for the new types lands with ISE-385.

    10 new tests; ruff + mypy (426 files) + migration chain + both Cloudflare test files green locally.
assignee: steve
label: null
priority: medium
task_status: done
---
Entity discovery for the Cloudflare account (scope decided with Steve 2026-07-30: full product surface in use).

- Zones (`GET /zones?account.id=…`) → new entity type `zone`.
- Cloudflare Tunnels (`GET /accounts/{account_id}/cfd_tunnel`) → new entity type `tunnel`; capture tunnel status (healthy/degraded/down/inactive) as state.
- Load balancers (per-zone `GET /zones/{zone_id}/load_balancers`) → existing `load-balancer` entity type; pools/origins (`/accounts/{account_id}/load_balancers/pools`) recorded as attributes, not entities.
- Workers scripts (`/accounts/{account_id}/workers/scripts`) + Pages projects (`/accounts/{account_id}/pages/projects`) → `workload` entities (App Service precedent, ISE-365).
- Native keys `cloudflare:{account_id}:{resource_id}` (ADR 0045 scoping); zone entities part-of the account System, tunnels/LBs/workers part-of their zone/account as appropriate.
- DNS records are NOT entities — evidence-only in v1 (decided 2026-07-30); the routes-to edge harvest from CNAME/A targets is deferred.
- No obvious cross_keys in v1 (Cloudflare sits in front of the estate; joins would come via DNS targets, deferred with the edge harvest).
- ENTITY_TYPES change (`zone`, `tunnel`) → migration if needed + api-types regen; check the ai-config test that enumerates types.