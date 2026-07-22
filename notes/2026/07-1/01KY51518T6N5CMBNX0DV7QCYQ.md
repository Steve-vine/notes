---
id: 01KY51518T6N5CMBNX0DV7QCYQ
created: 2026-07-22T13:44:57.370271Z
updated: 2026-07-22T13:44:57.370271Z
type: task
title: Tag Dictionary editor — Settings → Tags
priority: medium
assignee: steve
label: feature
task_status: backlog
project: 01KX671DATY39VW6GWK3M2T3DN
number: 212
---
Admin CRUD over the dictionary (Canon: "The Tag Dictionary" — "the dictionary is theirs, not shipped dogma").

- New Settings → Tags tab (admin-gated, alongside thresholds/spend): manage keys (name, description, `defined|open` mode, aliases, expected entity types) and defined values (value, description, aliases). Add/edit/delete on all of it.
- Descriptions are first-class — they feed the AI investigator's understanding of the vocabulary, not just tooltips.
- Every change audited; a mapping change triggers deterministic re-evaluation of rules/groups (reuse the `tag_rules.apply_rule` path).
- Deleting a key/value that has mapped pool tags: warn with the affected count; mappings dissolve back to raw (never delete pool rows).
- OpenAPI regen (`dump_openapi` + `npm run generate:api`); Vitest coverage for the editor flows.