---
id: 01KXGS26HM66ZV1E3ZNMMB391K
created: 2026-07-14T16:58:47.220365619Z
updated: 2026-07-14T18:32:39.876906429Z
type: task
title: Frameworks & crosswalk UI
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 32
sprint: s9wnr7r
blocked_by:
- 01KXGS0FW4BN20F9TNN2C9V2AS
- 01KXGS1G8K7SD6ASJJ5JJVBF1B
comments:
- id: 01KXGS2HKA8KZ2PGZS7VV8YY1J
  author: Steve Vine
  at: 2026-07-14T16:58:58.538376216Z
  text: |-
    [Migrated from Linear — Steve Vine, 2026-06-16 21:38 UTC]
    PR open: https://github.com/Steve-vine/compass/pull/29

    **Delivered** (all three checklist items)
    - **Frameworks browse** → framework detail with requirements in order, each showing its mapped Core controls as chips that link to the control detail page.
    - **Crosswalk editor**: admin/editor can map (modal control picker + optional note) and unmap; viewers are read-only. Unmapped requirements surfaced via a per-requirement badge, an "Only unmapped" filter, and a "N of M mapped" summary.
    - **Bidirectional link**: the control detail page now has a Frameworks card listing the requirements that control satisfies, linking back to the framework.

    Also: `src/frameworks/hooks.ts` (queries + mutations + requirement index), routing/nav wired, and `schema.d.ts` regenerated for the new `/frameworks` + `/mappings` endpoints.

    **Verification**: lint, typecheck, 29 vitest tests (8 new), format:check, and build all green. Frontend-only — no backend/contract changes; ships on the next image roll.
assignee: steve
label:
- brief
priority: medium
task_status: done
---
The Frameworks section (ADR 0017 — the `/frameworks` nav item, currently a placeholder).

- [ ] Browse frameworks → a framework's requirements, each showing its mapped Core controls.
- [ ] Crosswalk editor: map/unmap Core controls to a requirement (admin/editor); surface unmapped requirements.
- [ ] Link requirement ↔ control detail pages.

Depends on: Framework models + import, Crosswalk model + API. Refs: ADR 0010, 0017.

---
*Migrated from Linear [DEV-433](https://linear.app/stevevine/issue/DEV-433/frameworks-and-crosswalk-ui) · created 2026-06-16 · completed 2026-06-16*