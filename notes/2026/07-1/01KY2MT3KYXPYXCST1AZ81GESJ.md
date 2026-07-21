---
id: 01KY2MT3KYXPYXCST1AZ81GESJ
created: 2026-07-21T15:30:47.550728Z
updated: 2026-07-21T17:44:32.900883Z
type: task
title: Membership tracks tag drift — rule edit/delete lifecycle
project: 01KX671DATY39VW6GWK3M2T3DN
number: 185
sprint: sth83hw
blocked_by:
- 01KY2MT1Q10BDC3CDXJVBX80HC
assignee: steve
label: null
priority: medium
task_status: backlog
---
`apply_tag_rules` runs on every sync with full diff semantics: insert missing `rule` edges, delete rule edges whose member no longer matches (tag drift), bump `last_confirmed_at` on survivors. Only `resolution='rule'` edges are ever touched — human-asserted `part-of` edges survive rule edits, drift, and deletion. Edit re-evaluates synchronously; delete removes rule edges + group entity with explicit confirm copy; disabled toggle pauses maintenance without deleting the group; audit records for membership-affecting changes. Tests cover entity-merge convergence (edges re-point, next evaluation dedups).

**Accept:** removing `env:prod` from an entity at source drops it from the group after the next sync; a human-asserted `part-of` to the group survives everything; deleting the rule removes only rule artefacts.