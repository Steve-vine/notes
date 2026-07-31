---
id: 01KYWAG5YAEZS6642BQCBH9VBV
created: 2026-07-31T14:50:51.722888Z
updated: 2026-07-31T15:08:16.355Z
type: task
title: 'Docs: Security — roles &amp; access'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 431
order: 0.00390625
sprint: sp3en5k
assignee: steve
label:
- feature
priority: medium
task_status: active
---
Replace the stub at `src/content/docs/security/roles.md` with real content: the role ladder (viewer < responder < operator < approver < admin) with a capability matrix — who can see, execute published playbooks, propose, approve, and administer; Entra ID (OIDC) sign-in and how roles derive from group membership; the sealed break-glass account, when to use it and the alerting on every use; per-user API/MCP tokens.

Ground in ADRs 0015, 0056 (the responder rung), 0017, and `../ise/docs/briefs/security-model.md`. Operator audience, released capability only.