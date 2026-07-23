---
id: 01KY709DRSV7DEBSQ80K5KR316
created: 2026-07-23T08:08:21.52982Z
updated: 2026-07-23T11:03:33.801279Z
type: task
title: Multi-axis nested browse UI
imported_from: linear
task_status: done
assignee: steve
comments:
- id: 01KY709QQ993XN2VY304QF0H0Z
  author: Steve Vine
  at: 2026-07-23T08:08:31.721149Z
  text: |-
    Steve Vine · 2026-07-02:

    Done building — PR: https://github.com/Steve-vine/notuvia/pull/128

    **What was done**
    - `browseTree.ts` + 7 unit tests: the pure path model — a node is its ordered `(axisId, value)` steps, doubling as the filter set for its children; `pathKey`, `samePath`, strict-prefix `isAncestor`, idempotent `expandPath`, `collapsePath` (drops descendants), `pathToFilters`.
    - `BrowseSection.svelte`: stacked axis pickers (change in place, ↑/↓ reorder, × remove with a one-level floor, + adds the next unused taxonomy, duplicates disabled in dropdowns) and a recursive snippet rendering the lazy tree — depth *d* expands to the next axis's filtered values with exact counts, the last level to the notes on the whole path.
    - Main: per-path `folderCache`/`noteCache`; `toggleNode` prunes descendant cache entries on collapse; any axis change resets the tree; tab activation restores persisted expansion with a tab-id guard; registry bumps revalidate axes and collapse.
    - `workspaceStorage`: `BrowseState` → `{ axes[], expandedPaths[] }` with on-revive conversion of pre-DEV-766 documents (`axisId`/`expandedValues`); malformed paths dropped whole; tests updated + legacy case added.

    **Decisions made on the fly**
    - Kept the same-version (v1) defensive revive with legacy-field conversion instead of bumping to v2 — the revive layer is already field-defensive and the old shape is a week old; a version bump would have added machinery for no safety.
    - The value filter box narrows the **root level only** (parity with today); filtering nested levels is cheap to add later if wanted.
    - Fetched caches key on the path and store *children*, so collapse-pruning also fixes Browse export: hidden notes no longer count.
    - Fixed a latent R4 race while restructuring: startup could clear the persisted expansion before restore read it (loadAxes and the tab-refresh both owned collapse). Axis validation no longer touches expansion unless the axis list actually changed.

    **Problems encountered**
    - None beyond the race above. svelte-check 0 errors, vitest 109/109, gate green. Review pass: nest Type → Technology and sanity-check counts, expand to notes, reorder/remove levels, persistence across tab switch + restart, root filter, single-level behaviour.
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 143
sprint: sa8cznq
---
R6 of the Revamp UI milestone (parent DEV-754). The browse sidebar gains multiple taxonomy axes that nest in the order selected (e.g. Type → Technology → notes).

* New `browseTree.ts` (+ unit tests, like `paneTree.ts`): node path model `[(axisId, value), …]`, path keys, expansion helpers.
* `BrowseSection.svelte`: axis picker list with "+" to add another axis, remove/reorder; nested lazy value tree — expanding a node at depth d fetches the next axis's **filtered** values (correct counts); the last axis expands to the filtered notes.
* Changing the axis list clears expansions; fetched children cached per path, invalidated on `noteRev`/`taxonomyRev` bumps.
* Axes + expanded paths live in per-tab workspace state.

Depends on: DEV-763 (R3), DEV-765 (R5); per-tab persistence from DEV-764 (R4).

Checklist:

- [ ] Add/remove/reorder axes
- [ ] Nested tree with filtered counts and leaf notes
- [ ] State persists per workspace tab
- [ ] browseTree unit tests

---

Linear DEV-766 · Revamp UI · created 2026-07-02 · done 2026-07-02