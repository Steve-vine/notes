---
id: 01M2T27S57C5BWSBQQEGF3F27S
created: 2026-09-18T10:50:46.311983Z
updated: 2026-09-18T10:50:55.578104Z
type: task
title: Consolidate the two Date browse axes into one "Date Modified"
project: 01KY6W9951TW0904DT0GGJVGE7
number: 427
sprint: segj1dz
assignee: steve
label:
- improvement
priority: medium
task_status: active
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