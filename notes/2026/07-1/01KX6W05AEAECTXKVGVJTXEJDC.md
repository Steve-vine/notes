---
id: 01KX6W05AEAECTXKVGVJTXEJDC
created: 2026-07-10T20:37:41.838464667Z
updated: 2026-07-19T13:25:10.58681678Z
type: task
title: UI screens — auth flow, Overview empty states, Settings→Integrations, Audit log
project: 01KX671DATY39VW6GWK3M2T3DN
number: 18
sprint: sqtx330
blocked_by:
- 01KX6VZJM8TDKJQENVPREXEWWS
- 01KX6VZG7VJ4M9MGG27S6T8G00
- 01KX6VYAJEN6473MY7YV0N8NNR
- 01KX6VYSWX5YQ7GB57JH8AT6XK
comments:
- id: 01KX8DYYQMJ3030VE4XM4DJGDP
  author: Steve Vine
  at: 2026-07-11T11:10:51.123703421Z
  text: 'Development complete on feature/ise-018-ui-screens. PR #20: https://github.com/Steve-vine/ise/pull/20. LIVE on staging: https://ise.citops.net. The full Phase 1 logged-in shell, all data via the generated /api/v1 client: auth flow (RequireAuth gate → /login, LoginPage with Microsoft button + dev-only stub form, UserMenu with role pills + sign out, TanStack Query hooks), Settings→Integrations (systems table + Add-integration modal storing a write-only credential then the system, both audited; admin-gated, per-row delete), Audit log (filterable, polling, break-glass/delete highlighted red). Overview keeps empty state; deferred nav keeps phase placeholders; hasRole mirrors backend RBAC. 10/10 tests, lint/strict build/api-types all green. Verified live: staging serves the SPA with fallback, /auth/me and /systems both 401 anonymous (boundary holds → login redirect), /auth/login 503 (Entra pending). Full sign-in→add-integration→audit path verified in local compose against the real API. NOTE for smoke test: on staging you''ll see the login page but ''Sign in with Microsoft'' 503s until the Entra app registration is applied — to actually click through the UI now, either load Entra values (~/ise-entra-values.yaml, still pending) or run locally (npm run dev against compose) for the dev-stub form. Awaiting smoke test + merge clearance.'
- id: 01KX8EC022V7596HZMF1M6VRM6
  author: Steve Vine
  at: 2026-07-11T11:17:58.466875721Z
  text: 'Smoke tests passed. PR #20 merged to main (f0aaaf7), branch deleted. Belt-and-braces main run green. Done. Follow-on: applied the Entra app registration to the ise-env-overrides staging secret (tenant/client/secret + group-id→role map for ISE-Admin/Operator/Approver/Viewer), restarted api/worker/beat. /api/v1/auth/login now 307-redirects to login.microsoftonline.com/<tenant> with PKCE — Entra sign-in is LIVE on staging, unblocking ISE-19''s real login.'
assignee: steve
label: null
priority: medium
task_status: done
---
Sign-in/sign-out flow against the auth backend, Overview with empty states, Settings→Integrations skeleton (create an integration record with credentials), and the Audit log screen. Uses generated API types only (ADR 0009).