---
id: 01KYWAH5A7D9FHPWA8WVM2BMCK
created: 2026-07-31T14:51:23.847607Z
updated: 2026-07-31T14:51:23.847607Z
type: task
title: 'Docs: new section — Proposals'
assignee: steve
priority: medium
task_status: backlog
label: feature
project: 01KX671DATY39VW6GWK3M2T3DN
number: 437
---
Write `src/content/docs/using-ise/proposals.md`: the proposed-change workflow as an operator actually meets it — where proposals come from (AI diagnosis during an incident, the connector-generic propose-action panel on a System, a playbook run), what a proposal shows (target, operation, parameters, tier, reversibility, expected effect), the approve/reject path and who may approve, what happens on execution (including long-running operations reported truthfully on completion), failure handling, and where the result lands on the incident timeline and audit trail.

Cross-link to Concepts → Actions &amp; approvals for the tier model rather than restating it. Ground in ADRs 0017, 0021, 0024, 0060 §UI (ActionsPanel), 0056. Operator audience, released capability only.

Depends on ISE-433 (sidebar group).