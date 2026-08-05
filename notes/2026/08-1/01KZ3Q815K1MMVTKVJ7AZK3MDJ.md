---
id: 01KZ3Q815K1MMVTKVJ7AZK3MDJ
created: 2026-08-03T11:48:17.203786Z
updated: 2026-08-05T19:29:54.214734Z
type: task
title: Tag writeback declared on ActionSpec, not a hardcoded map
project: 01KX671DATY39VW6GWK3M2T3DN
number: 497
sprint: shk7zaj
assignee: steve
priority: medium
task_status: active
---
Replace `tag_remediation.py`'s `_OPERATIONS = {connector_type: operation}` dict (and the per-connector native-key → action-param branches) with a declaration on the ActionSpec itself (e.g. a `tag_write` marker + param mapping). A connector whose catalogue declares a tag-write op gets fix-at-source for free; absence still means unsupported (ADR 0043 semantics unchanged).