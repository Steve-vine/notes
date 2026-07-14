---
id: 01KXGS1G8K7SD6ASJJ5JJVBF1B
created: 2026-07-14T16:58:24.403093612Z
updated: 2026-07-14T16:58:32.235963781Z
type: task
title: 'Crosswalk: control↔requirement mapping (model + API)'
label:
- brief
task_status: done
priority: medium
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 31
sprint: s9wnr7r
---
The many-to-many control↔requirement crosswalk (ADR 0010): assess Core once, report against many.

- [ ] `ControlMapping` join model (`core_control_id` × `framework_requirement_id`, `note`) + migration (unique pair).
- [ ] API: create / list / delete mappings (admin/editor); list by requirement and by control.
- [ ] Seed default Core↔ISO 27001 mappings (vendored) idempotently.
- [ ] Curation queries: unmapped requirements (no Core control) and unmapped Core controls — Core is the superset (ADR 0010).

Depends on: Framework models + import. Refs: ADR 0010, 0015.

---
*Migrated from Linear [DEV-432](https://linear.app/stevevine/issue/DEV-432/crosswalk-controlrequirement-mapping-model-api) · created 2026-06-16 · completed 2026-06-16*