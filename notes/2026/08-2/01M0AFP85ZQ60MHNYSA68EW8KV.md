---
id: 01M0AFP85ZQ60MHNYSA68EW8KV
created: 2026-08-18T13:06:37.375446Z
updated: 2026-09-01T13:55:50.451944Z
type: task
title: OIDC sign-in backend — auth-code + PKCE, deny unprovisioned, break-glass preserved
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 248
sprint: s5thbzy
blocked_by:
- 01M0AFNWDZQ928WGZEMPCNPNDK
comments:
- id: 01M0AHS58DQCP1RT5V6WTT3FAP
  author: Steve Vine
  at: 2026-08-18T13:43:09.837762Z
  text: |-
    Merged to main (PR #246, full suite green). What shipped:

    - `sso_settings` singleton (migration 0067) + `/integrations/sso` GET(masked)/PUT/DELETE/test on the house pattern; `SSO_*` env fallback; **`enabled` is a separate lever** so credentials can be staged and tested before the login page switches over. The read includes the per-environment `redirect_uri` for copy-paste.
    - `/api/v1/auth/sso/start` → 302 to Microsoft (PKCE verifier + `state` + `nonce` single-use in Redis, 10-min TTL) and `/auth/sso/callback` → ID-token validation against the tenant JWKS (issuer/audience/nonce/expiry, rotation-tolerant key cache; PyJWT added — the first and only JWT validation in the codebase). Failures bounce to `/login?sso_error=<code>` (opaque codes: `unprovisioned`/`failed`/`expired`/`cancelled`/`disabled`) — COM-251 owns the wording.
    - Resolution: `entra_object_id` (new uniquely-indexed users column) → one-time UPN/email link with back-fill → **deny** (no JIT). Disabled accounts get the same `unprovisioned` code (no information leak). Same Redis session as password login; `get_current_user`, tokens untouched (ADR 0007's promise held).
    - Break-glass: password login untouched for local accounts; forgot/reset-password now refuse Entra-provisioned accounts.
    - 12 integration tests sign real RS256 tokens against a stubbed tenant (JWKS + token endpoints via MockTransport) — happy path, second-sign-in-by-object-id, bad nonce, expired token, unprovisioned deny, state replay, disabled, env fallback, JWKS refetch on unknown kid.

    Note for smoke test: the defensive role-refresh at sign-in lands with COM-250 (mapping table doesn't exist yet).
assignee: steve
label:
- feature
priority: high
task_status: done
---
The Entra sign-in flow, replacing credential verification only — sessions, API tokens and `get_current_user` are untouched (ADR 0007).

* **Settings**: `sso_settings` singleton — tenant_id, client_id, `client_secret_encrypted` (`core/secretbox`), enabled flag; admin-only GET (masked) / PUT / test endpoints on the `integrations.py` pattern. Env fallback for 12-factor parity with the other integrations.
* **Flow endpoints**: `/api/v1/auth/sso/start` (authorization redirect: PKCE verifier + `state` + `nonce` held server-side, Redis like the session store) and `/auth/sso/callback` (code exchange via httpx with the house `http_transport` test hook; ID-token validation against the tenant JWKS — issuer, audience, nonce, expiry; JWKS fetched and cached with rotation tolerance).
* **User resolution**: match on `entra_object_id` (new nullable indexed column on `users`, migration from 0067); first sign-in links by UPN/email match and back-fills the object id; **no match → deny** with a screen explaining Enterprise-App assignment (sprint decision — SCIM is the source). On success: `auth_provider="entra"`, defensive role refresh from the mapping table (COM-250), standard session cookie minted.
* **Break-glass**: password login stays for `auth_provider="local"` accounts only; SCIM/Entra users get a null password hash and the reset flow refuses them. Local login is not removed from the API — it moves behind the secondary path the frontend task exposes.
* **Tests**: integration tests with a stubbed JWKS + token endpoint via `httpx.MockTransport` — happy path, bad nonce, expired token, unprovisioned deny, local fallback untouched.

Refs: ADR 0046, 0007; `core/graph.py` (delegated-flow prior art: `build_authorize_url`/`exchange_code`), `api/v1/integrations.py`, `core/secretbox.py`.