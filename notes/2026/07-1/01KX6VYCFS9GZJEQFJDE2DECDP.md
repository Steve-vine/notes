---
id: 01KX6VYCFS9GZJEQFJDE2DECDP
created: 2026-07-10T20:36:43.64171091Z
updated: 2026-07-22T11:45:35.816682Z
type: task
title: RBAC + break-glass access
project: 01KX671DATY39VW6GWK3M2T3DN
number: 13
sprint: sqtx330
blocked_by:
- 01KX6VYAJEN6473MY7YV0N8NNR
comments:
- id: 01KX8370T5PK404TKSVGQ73GV9
  author: Steve Vine
  at: 2026-07-11T08:03:01.060990576Z
  text: 'Development complete on feature/ise-013-rbac-break-glass. PR #16: https://github.com/Steve-vine/ise/pull/16. RBAC: cumulative viewer<operator<approver<admin with require_role() dependency factory. Break-glass: bcrypt hash from secret, absent unless configured, Redis lockout 5/15min, ERROR log + red audit on every use, same session/audit path as other logins. Chart gained the optional ise-env-overrides Secret (survives CI deploys) — created on staging with a generated break-glass credential; hash in cluster, PLAINTEXT IN ~/ise-break-glass-staging.txt — move to password manager and delete the file. Entra values file not found yet (~/ise-entra-values.yaml) — will load into the same secret when it appears. 52/52 tests; verified LIVE on staging: wrong password 401, real login 200 (admin/local), logout; audit shows break_glass_failed + break_glass_login + logout. Awaiting smoke test and merge clearance.'
- id: 01KX8430SGEZ7GGPT1EXNXMBEM
  author: Steve Vine
  at: 2026-07-11T08:18:18.543915947Z
  text: 'Smoke tests passed. PR #16 merged to main (21f56d2), branch deleted. Belt-and-braces main run green. Done.'
assignee: steve
label: null
priority: high
task_status: done
---
Role model and enforcement plus the break-glass local-admin path for when EntraID itself is broken (ADR 0015 — ISE manages Entra, so auth must survive Entra outages). Break-glass use is loudly audited.