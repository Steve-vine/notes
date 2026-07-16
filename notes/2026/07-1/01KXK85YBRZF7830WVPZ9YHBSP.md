---
id: 01KXK85YBRZF7830WVPZ9YHBSP
created: 2026-07-15T16:01:27.416056471Z
updated: 2026-07-16T12:43:02.003700727Z
type: task
title: Configurable onboarding form questions + builder UI
label:
- brief
priority: medium
assignee: steve
task_status: active
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 179
blocked_by:
- 01KXK8323S7Y8BV1RN3HN4Q2X1
sprint: sxngp10
---
Phase 3 (ADR 0039 §5): the in-app-configurable question set for vendor onboarding requests.

- [ ] `models/vendor_form_question.py` (CompanyScoped): `prompt`, `help_text`, `kind` (text/long_text/boolean/select/multi_select/number/date), `options` JSONB, `required`, `position`, `active` + migration. Once answered, questions are retired (`active=false`), never deleted.
- [ ] CRUD + reorder API [require_vendor_write]; delete becomes retire once answers exist.
- [ ] Question-builder UI (per-type inputs, options editor, drag/position ordering) — the editable-reference-data precedent (rubric tables), surfaced in the Vendors section.
- [ ] Tests: retire-not-delete guard, kind/options validation.

Ref: ADR 0039 §5, ADR 0018.