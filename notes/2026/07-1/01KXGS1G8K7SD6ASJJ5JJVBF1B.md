---
id: 01KXGS1G8K7SD6ASJJ5JJVBF1B
created: 2026-07-14T16:58:24.403093612Z
updated: 2026-07-14T18:32:39.752464686Z
type: task
title: 'Crosswalk: control↔requirement mapping (model + API)'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 31
sprint: s9wnr7r
blocked_by:
- 01KXGS0FW4BN20F9TNN2C9V2AS
comments:
- id: 01KXGS1W7SJGG6PRRB8TGXETBZ
  author: Steve Vine
  at: 2026-07-14T16:58:36.665732159Z
  text: |-
    [Migrated from Linear — Steve Vine, 2026-06-16 21:18 UTC]
    PR open: https://github.com/Steve-vine/compass/pull/28

    **Delivered**
    - `ControlMapping` join model (`core_control` × `framework_requirement`, `note`) + unique-pair constraint; migration `0010_control_mappings`.
    - `/mappings` API — create/delete (admin/editor; dup → 409, missing FK → 404), list filtered by control or requirement, and the two curation queries: `unmapped-requirements?framework=` and `unmapped-controls` (Core is the superset, ADR 0010).
    - Vendored **conservative starter crosswalk**: 78 high-confidence Core↔ISO 27001:2022 mappings, seeded idempotently via `cli import-mappings` and wired into the import Job.

    **On the seed scope** (per the decision taken): this is deliberately *not* an authoritative 269→93 crosswalk — only unambiguous matches are vendored, since mapping quality is a governance concern in its own right (ADR 0010). The bulk of curation happens via the crosswalk UI (DEV-433).

    **Verification**: ruff/format/mypy clean; 6 integration tests pass; migration round-trips on real Postgres; `import-mappings` idempotent (78 applied on re-run); helm lint clean. No live deploy in this PR — the import hook seeds on the next roll.
assignee: steve
label:
- brief
priority: medium
task_status: done
---
The many-to-many control↔requirement crosswalk (ADR 0010): assess Core once, report against many.

- [ ] `ControlMapping` join model (`core_control_id` × `framework_requirement_id`, `note`) + migration (unique pair).
- [ ] API: create / list / delete mappings (admin/editor); list by requirement and by control.
- [ ] Seed default Core↔ISO 27001 mappings (vendored) idempotently.
- [ ] Curation queries: unmapped requirements (no Core control) and unmapped Core controls — Core is the superset (ADR 0010).

Depends on: Framework models + import. Refs: ADR 0010, 0015.

---
*Migrated from Linear [DEV-432](https://linear.app/stevevine/issue/DEV-432/crosswalk-controlrequirement-mapping-model-api) · created 2026-06-16 · completed 2026-06-16*