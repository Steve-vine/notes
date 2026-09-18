---
id: 01M2SNTZS1C1VV950C8HWA8G5J
created: 2026-09-18T07:14:04.193581Z
updated: 2026-09-18T10:41:14.13879Z
type: task
title: Most viewed notes
project: 01KY6W9951TW0904DT0GGJVGE7
number: 425
sprint: segj1dz
comments:
- id: 01M2SV359PQF5R1D4FCMJ721PK
  author: Steve Vine
  at: 2026-09-18T08:45:54.870655Z
  text: |-
    Built on brief-425-most-viewed, PR #425, with ADR 0061.

    What was done:
    - decisions/0061-per-machine-view-counts.md — records the new category of state (durable, behavioural, per-machine) and why neither the index nor frontmatter was the right home.
    - notuvia-core/src/views.rs (new) — ViewCounts / ViewCount over .notuvia/views.json, tolerant load/save, record, top, forget.
    - runtime.rs — the counts live behind a Mutex on VaultRuntime (recording is a read path, so it mustn't need &mut self); record_note_view and most_viewed; delete_one forgets a count when a note is permanently deleted.
    - index.rs — a new live_summary(id) lookup, so the ranking can resolve ids and drop anything trashed or gone.
    - src-tauri/src/lib.rs — record_note_view and most_viewed commands beside recent_notes.
    - notes.ts / Main.svelte — a countView() helper called from openNote and openCardOverlay, the two functions every deliberate open funnels through.
    - dashboard.ts / Dashboard.svelte — "viewed" in PANEL_IDS and PANEL_LABELS, plus a Most Viewed panel in the recent-panel format with the count where the date sits (hover shows when it was last opened).

    Decisions made on the fly:
    1. A new viewRev rune (src/lib/viewRev.svelte.ts). Opening a note isn't a write, so noteRev never fires and the panel — which stays mounted behind the note overlay it opens into — would have shown a stale count until you switched views and back. viewRev is the noteRev idiom in miniature, deliberately without the cross-window broadcast: counts are per-machine bookkeeping anyway.
    2. most_viewed over-fetches from the counts file (2x the limit) before resolving ids, so a heavily-read note that was later deleted can't shorten the list.
    3. Wired forget() into the permanent-delete path as well as skipping dead ids at read time, so views.json doesn't accumulate entries for ids that can never come back.
    4. The render slot in Dashboard.svelte had a bare {:else} catching "updated"; made that explicit so the new panel had somewhere to go.

    Problems encountered: two existing dashboard.test.ts cases hard-code the full panel list and failed with "viewed" appended — which is the append-without-migration behaviour working as designed. Updated both, and added a case asserting that an order saved before this panel existed keeps its shape and gains the new panel at the end.

    Checks: cargo fmt --check and clippy -D warnings clean; cargo test --workspace 473 passing (6 new, including one that counts survive a full index rebuild — the point of the ADR); npm run check 373 files 0 errors; npm test 341 passing.

    Still to confirm in the running app (the review step): the panel appears, ranks sensibly after opening a few notes from different surfaces, and .notuvia/views.json fills up.
assignee: steve
label:
- feature
priority: medium
task_status: done
tech: null
---
Add a new section onto the dashboard tab called Most Viewed
In there show the top most viewed notes
I don't believe there is currently a view counter on notes so this may be required.

## Agreed shape

There is no view tracking of any kind today, so the counter is net-new. The
design question is **where the counts live**, and it earns an ADR:

- The SQLite index is disposable (ADR 0003) — a `views` column would be wiped
  by every rebuild, and ADR 0003 forbids user-meaningful state living only
  there.
- Frontmatter is the other sanctioned home, but a view is not an edit: writing
  there on every open rewrites the file, bumps `updated` (polluting the
  Recently Updated panel next to it, and the new Date updated browse axis), and
  auto-commits under git-sync.

**Store:** `<vault>/.notuvia/views.json` — beside the index, never part of it,
so counts survive a rebuild; `.notuvia/` is gitignored, so they are per-machine
and never sync. Precedent: the git-sync lock (ADR 0059) lives there for the
same reason.

**A view is a deliberate open** — from Browse, search, a board card, the
Dashboard, or the capture window's "Open in UI". The right panel's properties
preview is not a view.

## Agreed work

- [ ] ADR 0061 recording the new category of state and why.
- [ ] `views.rs` — `ViewCounts` / `ViewCount`, tolerant load/save, `record`,
      `top`, `forget`.
- [ ] `runtime.rs` — hold the counts behind a `Mutex`; `record_note_view` and
      `most_viewed` (resolving ids against the index, skipping trashed and
      deleted notes); forget a count on permanent delete.
- [ ] `lib.rs` — `record_note_view` and `most_viewed` commands.
- [ ] `notes.ts` / `Main.svelte` — count from the two open paths only.
- [ ] `dashboard.ts` / `Dashboard.svelte` — a "viewed" panel id and a Most
      Viewed panel in the recent-panel format, count where the date sits.
- [ ] Tests: counts file round-trip, ranking, deleted/trashed notes leaving the
      list, counts surviving an index rebuild, panel order appending.