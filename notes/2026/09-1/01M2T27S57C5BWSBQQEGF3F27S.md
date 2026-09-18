---
id: 01M2T27S57C5BWSBQQEGF3F27S
created: 2026-09-18T10:50:46.311983Z
updated: 2026-09-18T11:02:19.08963Z
type: task
title: Consolidate the two Date browse axes into one "Date Modified"
project: 01KY6W9951TW0904DT0GGJVGE7
number: 427
sprint: segj1dz
comments:
- id: 01M2T2RT78B96M516TA2Z347PW
  author: Steve Vine
  at: 2026-09-18T11:00:04.455682Z
  text: |-
    Built on brief-427-date-modified-axis, PR #427.

    What was done:
    - index.rs — one `modified_date` note_values row per note replaces the two; the value is the local day of `updated`, falling back to `created`. SCHEMA_VERSION 11 -> 12 with its changelog line. fill_values' skip list follows the rename.
    - taxonomy.rs — VIRTUAL_AXIS_IDS is now ["project", "modified_date"].
    - runtime.rs — is_date_axis matches the single id; labelling and newest-first ordering untouched.
    - taxonomy.ts / Main.svelte — one MODIFIED_DATE_AXIS ("Date Modified") at the top of the axis list.

    Decisions made on the fly:
    1. The fallback. `updated` alone would drop any note without an updated stamp out of the tree entirely; `updated.or(created)` keeps every note reachable and is what "last touched" means for a note that has never been edited.
    2. Name cased "Date Modified" as asked, which also matches the registry's Title Case ("Project Status", "Task Status") rather than the sentence case the two replaced axes used.
    3. No migration for saved browse state naming the old ids — loadAxes already filters chosen axes to ones that exist, so an affected tab falls back to the first axis rather than erroring.

    Problems encountered: none. The one thing worth noting is that this is the second SCHEMA_VERSION bump today (11 in 0.26.0, 12 here), so the index rebuilds again on first open and the debug MCP wants rebuilding once more before it touches the live vault.

    Checks: cargo fmt --check and clippy -D warnings clean; 410 core tests passing; npm run check 373 files 0 errors; npm test 341 passing. The date tests now assert the changed behaviour directly — an edited note files under its edit day only, a never-edited note under its creation day, a stampless note still appears, and both old axis ids return nothing.
assignee: steve
label:
- improvement
priority: medium
task_status: review
tech: null
---
Refines NOT-423, which shipped **Date created** and **Date updated** as two
separate browse axes in 0.26.0.

One axis is wanted, not two, and **one folder per note**: the day it was last
touched. A note created yesterday and a note created last week but edited
yesterday both belong in **Yesterday**, and nowhere else.

## Agreed work

- [ ] `index.rs` — replace the `created_date` / `updated_date` rows with a
      single `modified_date` row holding the local day of `updated`, falling
      back to `created` when a note has no `updated` stamp.
- [ ] `index.rs` — `SCHEMA_VERSION` 11 → 12; the old rows must not be browsed
      by a new binary, or a stale one browse the new axis empty.
- [ ] `index.rs` — the `fill_values` skip list follows the rename.
- [ ] `taxonomy.rs` — `VIRTUAL_AXIS_IDS` carries `modified_date` in place of
      the two.
- [ ] `runtime.rs` — `is_date_axis` matches the one id; labelling and
      newest-first ordering are unchanged.
- [ ] `taxonomy.ts` / `Main.svelte` — one `MODIFIED_DATE_AXIS` ("Date
      Modified") at the top of the axis list, above Type.
- [ ] Tests updated: a note appears under exactly one day, and an edited note
      appears under its edit day rather than its creation day.

A saved browse state naming the old axis ids needs no migration — `loadAxes`
already drops chosen axes that no longer exist.