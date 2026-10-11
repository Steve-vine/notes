---
id: 01M4NARS1BSY19AJS7PSHS37TA
created: 2026-10-11T11:15:03.339919Z
updated: 2026-10-11T11:16:13.992765Z
type: task
title: 'Settings: Roadmap Entries pool with a Single / Range date mode per value'
project: 01KY6W9951TW0904DT0GGJVGE7
number: 530
sprint: sn8d5g8
blocked_by:
- 01M4NAQY0Q6PMR3N1F47KXXZCN
assignee: steve
label:
- feature
priority: medium
task_status: backlog
tech: null
---
So that the Roadmap Entries pool can be edited in Settings like the other built-ins — add, rename, recolour, reorder, merge — with one extra control per value: whether entries of that kind carry a single Date or a Start / End range. The pool must stay out of every place a note's taxonomies are offered.

## Agreed work

- [ ] `src/lib/taxonomy.ts`: `roadmap_entry` in `BUILTIN_TAXONOMY_IDS`; `date_mode` on `TaxonomyValue` if the commands task didn't add it.
- [ ] `TaxonomySettings.svelte`: it lists under "System taxonomies" (`isBuiltin`, ~L118) with scope / multi / free-form locked (~L528–606) — the scope control should read "Roadmap entries" or similar rather than an empty type list. A `hasDateMode(id)` predicate beside `hasInitials` (~L76), included in `hasDetail` (~L228), a Single / Range select in the `v-detail` panel (~L785–838) defaulting to Single, and a small "Range" chip on the value row (~L731) so the mode is visible collapsed. Save already round-trips the whole draft (~L246).
- [ ] `taxonomyDraft.ts`: `blankValue` leaves `date_mode` unset (= single).
- [ ] Keep it out of: capture-window selectors, the properties pane, the Kanban card-chip options (`NOT_CARD_CONFIGURABLE`, ~L45), browse-by-taxonomy in the sidebar, and `applicableTaxonomies` consumers — verify the empty scope achieves this everywhere and special-case by id where it doesn't (`Capture.svelte` ~L513, `Main.svelte` ~L2567, `KanbanView.svelte` ~L97, `board.ts` ~L83 are where `initiative_status` had to be touched).
- [ ] Rename / merge of a `roadmap_entry` value must rewrite `kind` on every roadmap entry in the vault, as `renameTaxonomyValue` / `mergeTaxonomyValue` rewrite note values today — check whether the core rename path walks frontmatter lists; if it doesn't, add it in core and note it in the completion comment.
- [ ] Tests: whatever `TaxonomySettings` coverage exists; a core test for rename/merge rewriting `kind`.

## Notes

The user-facing name is "Roadmap Entries"; the id is `roadmap_entry`. Deleting the pool is refused like the other built-ins (`runtime.rs` ~L2729).