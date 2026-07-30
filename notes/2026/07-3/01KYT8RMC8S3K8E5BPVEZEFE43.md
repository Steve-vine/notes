---
id: 01KYT8RMC8S3K8E5BPVEZEFE43
created: 2026-07-30T19:42:02.632924Z
updated: 2026-07-30T21:36:03.511799Z
type: task
title: Cloudflare discovery — zones, tunnels, load balancers, Workers/Pages → estate entities
project: 01KX671DATY39VW6GWK3M2T3DN
number: 382
sprint: s39ax46
blocked_by:
- 01KYT8RA7RR5MTXDH46MARARHY
assignee: steve
label:
- feature
priority: medium
task_status: todo
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