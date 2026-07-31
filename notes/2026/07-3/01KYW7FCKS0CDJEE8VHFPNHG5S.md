---
id: 01KYW7FCKS0CDJEE8VHFPNHG5S
created: 2026-07-31T13:58:00.057644Z
updated: 2026-07-31T13:58:00.057644Z
type: task
title: 'Integration docs: Microsoft Entra ID'
task_status: backlog
assignee: steve
label: feature
priority: medium
project: 01KX671DATY39VW6GWK3M2T3DN
number: 416
---
Replace the Entra ID stub (`src/content/docs/integrations/entraid.md`) with full operator documentation:

- **Capabilities** — discovery of users, security groups, service principals, CA policies; Identity Protection risky-user detections as stateful signals (risk detections are evidence, not alerts); evidence queries (sign-ins, directory audit, risk detections, user detail incl. MFA state, group members, CA policy detail, app credential expiry); the six identity actions — all highest-tier, human approval always — and the structural guardrails (ISE never modifies groups its own access derives from; protected-group deny set).
- **Setup** — read app registration + separate write SP via Grant-write; required Graph permissions and admin consent; forbidden-permission invariant.
- **Examples** — a risky-user signal opening an incident with sign-in evidence; a T3 group-membership change through approval.

Ground in ADRs 0063 (connector) + 0064 (actions); rewrite for operators, released capability only. This is the governance flagship — the docs should make the guardrails legible.