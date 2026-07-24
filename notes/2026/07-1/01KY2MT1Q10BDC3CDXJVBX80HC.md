---
id: 01KY2MT1Q10BDC3CDXJVBX80HC
created: 2026-07-21T15:30:45.601121Z
updated: 2026-07-24T14:43:10.711148Z
type: task
title: Tag rules — create a group from Settings
project: 01KX671DATY39VW6GWK3M2T3DN
number: 183
order: 1.5625
sprint: sth83hw
blocked_by:
- 01KY2MSN1Q3W82KAAF3G52913D
assignee: steve
label: null
priority: medium
task_status: done
---
Migration 0038 (after 0037): `tag_rule` table (name UNIQUE = group name, optional system scope, predicates = AND-ed JSONB list of tag strings, group_entity_id, enabled, created_by); add `"group"` to ENTITY_TYPES and `"rule"` to ALIAS_RESOLUTIONS (CHECK-constraint swaps; do NOT reuse `asserted` — rule edges are machine-maintained). CRUD API (`/tag-rules`, severity_api pattern: admin writes, audited) with synchronous evaluation on save; group entity created eagerly. UI: admin-gated Settings "Tag rules" tab, `TagRulesCard` (IncidentPolicyCard pattern) — rules table with scope/predicate badges/member count/enabled switch, add-edit modal using Mantine `TagsInput` for predicates. [Migration 0038] [Regenerate API types]

**Accept:** an admin creates `service:kora → "Kora"` and immediately sees a member count; viewer role cannot mutate; creation is audited.