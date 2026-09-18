---
id: 01M2SNBRGMRC180ST50TJAWVJ7
created: 2026-09-18T07:05:45.236825Z
updated: 2026-09-18T08:30:58.118957Z
type: task
title: Add browse by date
project: 01KY6W9951TW0904DT0GGJVGE7
number: 423
sprint: segj1dz
comments:
- id: 01M2ST7PCRR01X9C5WZKHG2306
  author: Steve Vine
  at: 2026-09-18T08:30:54.8723Z
  text: |-
    Built on brief-423-browse-by-date, PR #424.

    What was done:
    - index.rs — a new `local_day()` helper turns an RFC 3339 stamp into the local `YYYY-MM-DD`; the note indexer writes `created_date` and `updated_date` note_values rows beside the existing Type (DEV-514) and project (DEV-1003) inserts. An absent or unparseable stamp just leaves the note out of the Date tree rather than failing the index.
    - index.rs — SCHEMA_VERSION 10 -> 11 with its changelog line, so the MCP sidecar (which shares the live vault) keeps its own cache rather than browsing the Date axes empty.
    - index.rs — fill_values now skips `created_date`/`updated_date` alongside `type`, so the synthetic rows never show as a pill on every search hit or MCP result.
    - runtime.rs — `is_date_axis()` and `day_label()`; taxonomy_values labels the stored day relative to today (Today / Yesterday / 16 Sep 2026) and sorts date folders by value descending.
    - taxonomy.rs — new VIRTUAL_AXIS_IDS const, refused in validate_user_def.
    - taxonomy.ts / Main.svelte — CREATED_DATE_AXIS and UPDATED_DATE_AXIS beside PROJECT_AXIS, placed first in the axis list.

    Decisions made on the fly:
    1. Two axes instead of one. The task said "date last modified/created"; both are indexed columns, so shipping "Date created" and "Date updated" costs almost nothing and avoids guessing.
    2. Day buckets stored absolute, labelled relative. Storing a relative bucket ("This week") in the index would go stale the moment the clock moved past it without a reindex; storing the day and resolving the label at query time keeps the index honest and still reads well.
    3. Reserved ids. Rather than adding the date ids to RESERVED_IDS — which also strips matching entries out of taxonomies.yaml, so a user's existing taxonomy would silently vanish — I added a separate VIRTUAL_AXIS_IDS const that only blocks *creating* one. It includes `project`, which had the same gap and sits on the same line; flagging rather than hiding that small extra.
    4. `known_filter_keys` needed no change: it already absorbs any taxonomy id present in the index, so `updated_date:2026-09-18` works in search as a free side effect.

    Problems encountered: the first draft of the ordering test asserted on a locally-sorted vector rather than on the real query — it proved nothing and clippy rejected the Vec. Rewritten to write two note files with fixed created stamps, reconcile them, and assert the order taxonomy_values actually returns.

    Checks: cargo fmt --check and clippy -D warnings clean; cargo test --workspace 473 passing (6 new); npm run check 372 files 0 errors; npm test 340 passing.

    Note for testing: the schema bump means the index rebuilds on first open, and the debug MCP build wants rebuilding before it touches the live vault again.
assignee: steve
label:
- feature
priority: medium
task_status: review
tech: null
---
Add a Date entry to the combo box listing all the taxonomies on the browse tab, as the first option above Type.
Selecting this should group all notes by the date last modified/created.

## Agreed shape

**Two** virtual axes at the top of the axis list, above Type: **Date created**
and **Date updated** — which settles the "last modified/created" ambiguity
without making you pick one. Folders are **one per day, newest first**,
labelled `Today` / `Yesterday` / `16 Sep 2026`.

## Approach

Reuse the existing synthetic-axis idiom rather than special-casing the query
path. Browsing already runs through one generic `note_values` path: the note's
Type is indexed as a value (`index.rs`, the DEV-514 idiom) and so is the
project link (DEV-1003). A date axis is a third instance — index the note's
**local** day as a value and nesting, counts, the filter box, the leaf note
list and `key:value` search filters all work unchanged. The bucket is absolute
so an indexed value never goes stale; only the label is relative, resolved at
query time.

- [ ] `index.rs` — insert `created_date` / `updated_date` `note_values` rows
      holding the local `YYYY-MM-DD`, beside the existing Type/project inserts.
- [ ] `index.rs` — `SCHEMA_VERSION` 10 → 11, so a stale binary (the MCP
      sidecar) keeps its own cache instead of browsing the Date axes empty.
- [ ] `index.rs` — widen `fill_values`' skip list so the synthetic date rows
      never become a result pill on every search hit.
- [ ] `taxonomy.rs` — refuse a user taxonomy claiming a virtual browse axis id.
- [ ] `runtime.rs` — label the stored day (Today / Yesterday / `16 Sep 2026`)
      and sort date folders newest first.
- [ ] `taxonomy.ts` / `Main.svelte` — two `TaxonomyDef` consts beside
      `PROJECT_AXIS`, placed first in the axis list.
- [ ] Tests: bucketing, grouping, nesting, no pill leakage, label rendering,
      folder ordering.