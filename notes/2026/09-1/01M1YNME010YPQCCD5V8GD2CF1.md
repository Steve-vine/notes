---
id: 01M1YNME010YPQCCD5V8GD2CF1
created: 2026-09-07T19:30:59.713812Z
updated: 2026-09-07T19:31:20.87956Z
type: task
title: 'Tier on the Core control: required field, seeded rule, backfill'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 606
sprint: sqc2gdq
assignee: steve
label:
- feature
priority: high
task_status: backlog
---
A Core control carries a tier — Essential, Expected or Specialised — as part of its definition. Stored, not derived. Required on every control, including ones an analyst creates in-app (ADR 0027), which have no framework mappings for a rule to read.

**Backend**

- `tier` on `CoreControl`, a three-value enum, not null.
- Exposed on the control read and write schemas; settable on create and update. The API rejects a create without one.
- The seeding rule (Cyber Essentials, or CIS IG1, or 5+ frameworks → Essential; 3–4 → Expected; else Specialised) computes the initial values. Keep the rule as a re-runnable script that **reports** what it would change rather than applying silently — the tier is stored precisely so it doesn't move on its own, and the report is how drift from the mappings stays visible.

**Frontend**

- Tier picker in the create and edit control forms, required.
- Tier pill on the control detail page. The list-page pills come with COM-605.

**Three traps, all previously paid for**

1. **The seed importer will not backfill.** `import_controls` is deliberately insert-missing-only — existing controls are "owned by the app now", so user edits survive a redeploy. Adding a tier column to `controls.csv` therefore populates *new* controls only; the 383 already in every deployed database stay null. The backfill is a one-off migration, not an importer change.
2. **A new enum needs an explicit create.** `op.add_column` does not emit `CREATE TYPE`. Create the type first, then reference it with `postgresql.ENUM(..., create_type=False)`. The other shape passes fresh-DB CI and fails on an incremental deploy — which is exactly what a deploy to staging is.
3. **CI only ever migrates a fresh database.** The branch that transforms 383 populated rows never runs in the pipeline, so a green PR proves nothing about it. Reproduce against a populated copy locally before this goes near staging.

Also: the route docstrings are the OpenAPI contract, so any change under `api/v1` drifts `schema.d.ts`. Run the drift script — the PR suite doesn't.

**Blocked by** COM-603: the rule can't produce real values without the CIS IG tags.