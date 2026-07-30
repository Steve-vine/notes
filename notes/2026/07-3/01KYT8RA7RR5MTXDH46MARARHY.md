---
id: 01KYT8RA7RR5MTXDH46MARARHY
created: 2026-07-30T19:41:52.248307Z
updated: 2026-07-30T21:33:36.868178Z
type: task
title: Cloudflare connector foundation (client, credentials, health, ADR)
project: 01KX671DATY39VW6GWK3M2T3DN
number: 381
sprint: s39ax46
assignee: steve
label:
- feature
priority: medium
task_status: backlog
---
Foundation for the Cloudflare integration, read-only v1 (sprint s09ekyn), mirroring the AWS/Azure foundations (ISE-358/ISE-364).

- `CloudflareClient` over httpx — native REST v4 (`https://api.cloudflare.com/client/v4`), Bearer token auth, zero new dependencies (ArmClient precedent, ADR 0059 §6). Transport decision: native REST over the official Cloudflare MCP servers (OAuth user-flow oriented, wrong shape for a headless worker) — allowed without ceremony by ADR 0014.
- Credential spec: `{api_token, account_id}` — one integration instance per Cloudflare account; v1 token is read-only scoped. Verify `api_token` is on the redaction list (GitHub precedent) — add if the Cloudflare shape differs.
- Health check: `GET /user/tokens/verify` + account reachability (`GET /accounts/{account_id}`).
- Respect the 1200 req/5 min per-token rate limit in the client (connector declares limits per the brief's failure semantics).
- Connector registration + capability declaration so the system card appears.
- ADR 0062: Cloudflare integration, citing the ADR 0058/0059 pattern.