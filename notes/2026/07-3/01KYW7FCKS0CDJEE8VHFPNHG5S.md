---
id: 01KYW7FCKS0CDJEE8VHFPNHG5S
created: 2026-07-31T13:58:00.057644Z
updated: 2026-08-05T12:34:34.044672Z
type: task
title: 'Integration docs: Microsoft Entra ID'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 416
order: 1.03125
sprint: sp3en5k
comments:
- id: 01KYW8D84VZVY0BHVDR0D92ABN
  author: Steve Vine
  at: 2026-07-31T14:14:18.523241Z
  text: |-
    Done on feature/ise-416-docs-entraid — PR #14, left OPEN for the PR-preview test.

    Full Entra ID page, governance-forward: discovery (users incl. guests, security groups, service principals, CA policies as tenant-scoped entities), stateful risky-user signals with the detections-are-evidence distinction, seven evidence queries, the six T3 actions in a table, and a dedicated Guardrails section (role-group + protected-group deny set, transitive check failing closed, no password/credential/role writes, CA state-switch only). Setup lists the exact read Graph permissions from the credential spec, the never-*.ReadWrite.* invariant on both principals, Grant-write second SP, and the P2 licence requirement. Examples: risky-user→incident with impossible-travel evidence, T3 containment with separation of duties, and the guardrail refusing a self-escalating add_group_member. Facts from connectors/entraid.py + ADRs 0063/0064. Build/lint green.
assignee: steve
label: null
priority: medium
task_status: done
---
Replace the Entra ID stub (`src/content/docs/integrations/entraid.md`) with full operator documentation:

- **Capabilities** — discovery of users, security groups, service principals, CA policies; Identity Protection risky-user detections as stateful signals (risk detections are evidence, not alerts); evidence queries (sign-ins, directory audit, risk detections, user detail incl. MFA state, group members, CA policy detail, app credential expiry); the six identity actions — all highest-tier, human approval always — and the structural guardrails (ISE never modifies groups its own access derives from; protected-group deny set).
- **Setup** — read app registration + separate write SP via Grant-write; required Graph permissions and admin consent; forbidden-permission invariant.
- **Examples** — a risky-user signal opening an incident with sign-in evidence; a T3 group-membership change through approval.

Ground in ADRs 0063 (connector) + 0064 (actions); rewrite for operators, released capability only. This is the governance flagship — the docs should make the guardrails legible.