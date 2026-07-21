---
id: 01KXWTMMAS23S9KQ1G39MDJ9F1
created: 2026-07-19T09:17:12.921651293Z
updated: 2026-07-21T17:37:26.672188Z
type: task
title: Context annotations register
project: 01KX671DATY39VW6GWK3M2T3DN
number: 130
sprint: sp5m61e
blocked_by:
- 01KXWTKZTHER145ZR0ARR81TMM
assignee: steve
label: null
priority: medium
task_status: done
---
**Sprint 12 (additive).** The contextual register — local human knowledge that changes how ISE *interprets* what it sees.

- `entity_annotation` — `entity_id`, **kind** (behavioural caveat / business meaning-criticality), free-form text, authored_by; **authored + sticky**.
- Loaded as **narrative context** whenever the AI investigator reaches that entity ("this cluster runs Karpenter, expect transient nodes"; "Kora is the CRM, business-critical, built from X/Y/Z").
- Migration + read/write API + tests.

Hangs additively off the entity spine. Depends on the entity model.