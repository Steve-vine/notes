---
id: 01M1YNME010YPQCCD5V8GD2CF1
created: 2026-09-07T19:30:59.713812Z
updated: 2026-09-07T21:19:20.965478Z
type: task
title: 'Tier on the Core control: required field, seeded rule, backfill'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 606
sprint: sqc2gdq
blocked_by:
- 01M1YKNAHBM1SNSSVAVWQH6VF9
- 01M1YM1TC1CAHJPTBGRPJBQXGG
comments:
- id: 01M1YRDHCDV631D7GGVFST8Z8P
  author: Steve Vine
  at: 2026-09-07T20:19:39.532934Z
  text: |-
    Done — merged to main in PR #614.

    Every Core control now carries a tier (Essential / Expected / Specialised), stored on the control and required — the create form and the API both refuse a control without one, and the edit form can move it.

    The seeding rule was run over the real crosswalk with the CIS IG tags in place: 158 Essential / 101 Expected / 124 Specialised (the brief's hand-applied figures were 157 / 101 / 125 — one control moved up). Cyber Essentials reaches 59 controls, CIS IG1 reaches 81.

    The three traps in the task: the backfill is migration 0169 (explicit CREATE TYPE, then a key→tier map written as literals, anything unknown landing in Specialised, then NOT NULL), and controls.csv carries a Tier column for fresh installs. The migration was reproduced by hand against a populated database seeded at 0168: the split matched, re-seeding was a no-op, and the downgrade cycle was clean. The upgrade-path test now compares tiers too, so the migration's map and the CSV cannot drift apart unnoticed.

    The rule stays re-runnable: `python -m compass_api.cli tier-report` prints where a stored tier differs from what the crosswalk now implies and applies nothing. On a fresh library it reports zero drift, and that is asserted in the test suite.

    Still open from the sprint description: the human pass on the boundary (~30 misplacements like "RTO and RPO are defined" landing in Specialised). Those are now plain edits on the control page.
assignee: steve
label:
- feature
priority: high
task_status: done
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