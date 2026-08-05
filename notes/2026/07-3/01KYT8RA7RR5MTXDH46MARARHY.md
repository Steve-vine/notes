---
id: 01KYT8RA7RR5MTXDH46MARARHY
created: 2026-07-30T19:41:52.248307Z
updated: 2026-08-05T13:39:05.697831Z
type: task
title: Cloudflare connector foundation (client, credentials, health, ADR)
project: 01KX671DATY39VW6GWK3M2T3DN
number: 381
sprint: s39ax46
comments:
- id: 01KYTFZMT6SRJ6YEB3VG5XW1J7
  author: Steve Vine
  at: 2026-07-30T21:48:12.486459Z
  text: |-
    Built and in review — PR #356 (feature/ise-381-cloudflare-foundation, targeting main), merged to staging (f6f3b8b).

    Delivered: CloudflareClient over httpx speaking the v4 REST envelope natively (transport decision recorded in ADR 0062 §5 — the official Cloudflare MCP servers are OAuth-user-flow shaped, wrong for a headless worker; zero new dependencies). Bearer auth, success/errors envelope handling (success:false raises even on a 200), result_info page pagination, and one bounded Retry-After retry on 429 for the 1200-req/5-min budget. Credential spec {api_token secret, account_id non-secret} with structural validation (32-hex account id, paste-mangle detection); health check = token verify (an inactive token reports error, not connected) + account identity. Capabilities {alerts, entities, evidence}; action catalogue empty per ADR 0062 §4. api_token confirmed already on the redaction list ('token' key part) — no logging change needed.

    ADR 0062 written (account boundary, scoped read-only token, v1 capability scope incl. the zone/tunnel entity-type decision and DNS-evidence-only, no actions, native REST, rate-limit stance).

    13 new tests (type surface via /api/v1/connectors/cloudflare, credential validation incl. PUT /credentials 422, stubbed health checks, client plumbing: pagination/429-retry/persistent-throttle/error envelope). ruff + mypy (424 files) + new tests green locally; PR CI running.
- id: 01KYVKD2BEDEP379ZQ5BTPWNZ4
  author: Steve Vine
  at: 2026-07-31T08:07:12.494245Z
  text: 'Follow-up (2026-07-31): Steve wants an ACCOUNT-owned API token (Manage Account → API Tokens), not a user-profile one — and that exposed a real gap: account-owned tokens don''t answer at /user/tokens/verify (they have no user; they verify at /accounts/{id}/tokens/verify), so the health check would have failed. Fixed on this branch (bdefc0f): _token_status tries the account verify endpoint first and falls back to the user one, so both token shapes work; ADR 0062 §2 now records account-owned as the recommended shape (service credential, survives the creating user leaving). New fallback test added (14 tests now). Fix cascaded up the stack (382→385, clean auto-merges) and re-merged to staging (02859eb); CI re-running on all five PRs + staging.'
assignee: steve
priority: medium
task_status: done
---
Foundation for the Cloudflare integration, read-only v1 (sprint s39ax46), mirroring the AWS/Azure foundations (ISE-358/ISE-364).

- `CloudflareClient` over httpx — native REST v4 (`https://api.cloudflare.com/client/v4`), Bearer token auth, zero new dependencies (ArmClient precedent, ADR 0059 §6). Transport decision: native REST over the official Cloudflare MCP servers (OAuth user-flow oriented, wrong shape for a headless worker) — allowed without ceremony by ADR 0014.
- Credential spec: `{api_token, account_id}` — one integration instance per Cloudflare account; v1 token is read-only scoped. Verify `api_token` is on the redaction list (GitHub precedent) — add if the Cloudflare shape differs.
- Health check: `GET /user/tokens/verify` + account reachability (`GET /accounts/{account_id}`).
- Respect the 1200 req/5 min per-token rate limit in the client (connector declares limits per the brief's failure semantics).
- Connector registration + capability declaration so the system card appears.
- ADR 0062: Cloudflare integration, citing the ADR 0058/0059 pattern.