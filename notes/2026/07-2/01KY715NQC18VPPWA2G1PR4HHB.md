---
id: 01KY715NQC18VPPWA2G1PR4HHB
created: 2026-07-23T08:23:47.180654Z
updated: 2026-07-23T09:17:32.574702Z
type: task
title: Favourites section
assignee: steve
label:
- brief
task_status: done
comments:
- id: 01KY715X7SJSE9F9F13Q6YRGTN
  author: Steve Vine
  at: 2026-07-23T08:23:54.873575Z
  text: |-
    Steve Vine · 2026-07-05:

    Built as agreed — PR: https://github.com/Steve-vine/notuvia/pull/184

    **What was done**

    - `favourite: true` frontmatter field following the `due` core-field pattern: indexed as its own column (RESERVED, never a taxonomy), removed entirely on unstar. No index migration — the disposable index rebuilds its schema on launch.
    - `set_favourite` (single-field write path with self-write guard + immediate reindex) and `favourite_notes` (starred notes, any Type, title order) commands.
    - Star toggle in the note status bar left of the delete button, on every note type including the board/dashboard overlay: new `star` icon, grey outline → filled yellow, `aria-pressed`, optimistic update with rollback, `bumpNotes()` on success.
    - Dashboard Favourites panel below To Do: title + muted Type rows, click opens over the dashboard, header count, explanatory empty state. The ToDo box styling was generalised to a shared `.panel` class.

    **Decisions made on the fly**

    - The star sits between History and Delete (the literal "left of the delete button"). Easy to move left of History if that reads better.
    - Star yellow is `#d9a441` (the amber already used elsewhere in the app) rather than a new colour.
    - Favourite is excluded from the editor's autosave dirty-tracking and flush — toggling never triggers a note save; it's its own write.

    **Problems encountered**

    None. Visual pass needed: star off/on states in light + dark themes, the fill on the icon (the icon system is stroke-only; the fill comes from CSS), and the Favourites panel spacing under To Do.
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 201
sprint: sjgxe93
---
Add a Dashboard section called Favourites.  In here show all notes that have been 'favourited'.

Add the capability to 'favourite' notes.  Create a star type button to the left of the delete button on notes, grey star initially but yellow when selected.  notes where this has been selected are 'favourite' notes.

## Agreed work

**Data** — `favourite: true` in note frontmatter, following the `due` core-field pattern (ADR 0022): present when starred, removed when unstarred (frontmatter stays clean). Indexed as a `favourite INTEGER` column on the notes table — added to the index's `RESERVED` keys so it's never mistaken for a taxonomy; the disposable index (ADR 0003) recreates the schema on next launch, no migration.

**Backend** —

* `set_favourite(id, on)` command: the single-field write pattern (`set_taxonomy_value`'s shape — touch updated, atomic write, self-write guard, immediate reindex, git touch).
* `favourite_notes()` command: `NoteSummary` rows where `favourite = 1`, title order.
* `NoteView` gains `favourite: bool` (read path only — the editor's full save doesn't touch it).
* Tests: core-field indexing (mirrors the `due` test), set/unset round-trip, listing.

**Star button** — in the note pane's status bar, left of the delete button, on every note type. New `star` icon in `Icon.svelte`. Grey outline when off; yellow + filled when on (`aria-pressed`). Toggling writes via `set_favourite`, updates the open doc optimistically, and `bumpNotes()` so other views refresh.

**Favourites section** — a second panel on the Dashboard below To Do, same soft-panel styling (shared class): header with count, rows of starred notes (title + muted type), click opens the note over the dashboard like a ToDo row. Empty state explains how to star a note. Refreshes via `noteRev`.

Checks: `cargo test`, `npm run check`, `npm test`.

---

Linear DEV-849 · Dashboard · created 2026-07-05 · done 2026-07-05