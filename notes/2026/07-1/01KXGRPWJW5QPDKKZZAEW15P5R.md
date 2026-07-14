---
id: 01KXGRPWJW5QPDKKZZAEW15P5R
created: 2026-07-14T16:52:36.572083553Z
updated: 2026-07-14T20:50:02.276469Z
type: task
title: Maturity rubric (editable reference data)
task_status: done
label:
- brief
priority: medium
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 19
comments:
- id: 01KXGRQ93DZZH87AXWC36X55Z2
  author: Steve Vine
  at: 2026-07-14T16:52:49.389353538Z
  text: |-
    [Migrated from Linear — Steve Vine, 2026-06-15 22:07 UTC]
    PR up for review: https://github.com/Steve-vine/compass/pull/21

    All four checklist items delivered:
    - **MaturityLevel reference table** (level 0-5, name, definition) + append-only `MaturityLevelRevision`, migration 0008. Org-wide (not company-scoped, per ADR 0018).
    - **Seeded from `brief/rubrics.md`** via `seed/maturity_levels.py` + `cli import-maturity-levels`, wired into the Helm import hook. Insert-if-absent / non-destructive, so re-running on deploy never clobbers admin edits.
    - **Admin → Settings UI** (new `/admin` page, replacing the placeholder): editable rubric table, admin-gated (read-only for non-admins), with per-level **history** — edits append a revision rather than overwriting (audit ethos).
    - **Assessments reference the rubric** — the maturity selectors now label levels "3 — Defined" with the definition as helper text. Assessments keep storing the integer value (no FK; ADR 0018 — versioned definitions keep old scores interpretable).

    Verification: backend ruff/mypy(src) clean, 27 unit + 44 integration pass (0008 up/down exercised); frontend eslint/tsc/prettier clean, 14 vitest pass. Branched off `main` (no stacking).

    Left at In Review for your eyes on the Admin UX. Say the word to merge — and note it adds the `import-maturity-levels` seed step, so a redeploy afterward will populate the rubric on the live cluster.
sprint: sz3kacg
---
The 0–5 maturity scale that makes assessments meaningful, editable in-app per ADR 0018.

- [ ] MaturityLevel reference table (`level` 0–5, `name`, `definition`)
- [ ] Seed the default rubric from `brief/rubrics.md`
- [ ] Admin → Settings UI to edit level wording (preserve history rather than overwrite, per the audit ethos)
- [ ] Assessments reference the rubric for the maturity dimension

Refs: ADR 0011, 0018. Source: `brief/rubrics.md`. (Risk scales/appetite are deferred to M4.)

---
*Migrated from Linear [DEV-405](https://linear.app/stevevine/issue/DEV-405/maturity-rubric-editable-reference-data) · created 2026-06-13 · completed 2026-06-16*  
*Related to (Linear): DEV-448, DEV-406, DEV-401*