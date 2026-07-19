---
id: 01KX6VYAJEN6473MY7YV0N8NNR
created: 2026-07-10T20:36:41.6780951Z
updated: 2026-07-19T13:23:23.738764417Z
type: task
title: Auth backend — EntraID OIDC, sessions, dev stub
assignee: steve
priority: high
task_status: done
project: 01KX671DATY39VW6GWK3M2T3DN
number: 12
blocked_by:
- 01KX6VXSDBE12B66M73JW8YX5Y
- 01KX6VXVPJGWSDV0M5XYA3EX00
comments:
- id: 01KX71ERZ99ZYC3K92ZK0P4QYB
  author: Steve Vine
  at: 2026-07-10T22:13:03.593730629Z
  text: 'Development complete on feature/ise-012-auth-backend. PR #15: https://github.com/Steve-vine/ise/pull/15. Entra OIDC (Auth Code + PKCE, JWKS-validated ID token, group→role mapping), opaque 8h sessions in Redis db 2 (HttpOnly cookie, Entra tokens never reach the browser), honest dev stub (same upsert/session/audit path; only registered when ISE_AUTH_MODE=dev; chart hard-codes entra), logins/logouts/rejections audited via ISE-11. User model + migration 0004. 45/45 tests on real PG+Redis; live compose flow verified incl. audit rows. Staging deployed and verified live: alembic 0004; /auth/me 401 anonymous, /auth/login 503 (Entra registration pending), dev-login 404 (correctly absent in hosted). NEEDED FROM STEVE: Entra app registration (tenant id, client id+secret, redirect https://ise.citops.net/api/v1/auth/callback, groups claim, group-id→role map) supplied via --set/gitignored values for ISE-19''s real sign-in test. Awaiting smoke test and merge clearance.'
- id: 01KX80TZY4CZB7R8HSQTDS4FQ4
  author: Steve Vine
  at: 2026-07-11T07:21:29.796318168Z
  text: 'Smoke tests passed. PR #15 merged to main (b4213f1), branch deleted. Belt-and-braces main run green. Done. Entra app registration walkthrough provided to Steve; credentials will be applied to staging via --set (never committed) once registered.'
label: null
sprint: sqtx330
tech: null
---
EntraID OIDC sign-in with server-side sessions and a local dev-stub auth mode (ADR 0015). Sign-ins/sign-outs produce audit events. Auth enforced uniformly at the /api/v1 boundary (ADR 0009).