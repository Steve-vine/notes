---
id: 01M4NASAMK50CJKJR5FYVJFH60
created: 2026-10-11T11:15:21.363535Z
updated: 2026-10-11T12:19:02.368455Z
type: task
title: 'Note view: Roadmap section above Sprints on a project and above Projects on an initiative'
project: 01KY6W9951TW0904DT0GGJVGE7
number: 531
sprint: sn8d5g8
blocked_by:
- 01M4NARAY42V3NGB3CK4EJNZFG
- 01M4NARS1BSY19AJS7PSHS37TA
comments:
- id: 01M4NEDXW7GWCECEY28A85VR4J
  author: Steve Vine
  at: 2026-10-11T12:19:02.150905Z
  text: |-
    Built and merged (squash, PR #522), CI green. The branch is deleted.

    What landed:
    - NotePane: a `roadmapSection` snippet above Sprints (project) and above Projects (initiative), every view mode, hidden while locked. Section head with "N of M done" + Collapse all; "No roadmap yet" card; rows in the sprint grid minus the number/progress columns (`.sprint.rm`) — grip (drag reorder), done tickbox (strikes the title), title, description, kind select from the Roadmap Entries pool with its colour swatch, and the date inputs the kind's mode calls for ("Date" → start; "Start"/"End" for range). Delete, NOT-527 collapse, Add entry under the list. The pool refetches on taxonomyRev.
    - noteDocs: `doc.roadmap` (outside the dirty snapshot), add (client-minted `r` + 6), set title/description/done/kind/start/end, remove, move. Edits debounce into `flushRoadmap` → `setRoadmap` with every field (empty strings clear); the returned list is adopted unless an edit landed meanwhile; nothing new since the last save writes nothing. `release` flushes it; `setType` away from Project/Initiative clears it.

    Decided on the fly: the section is one snippet rendered in both type branches rather than two copies; the roadmap's own debounce reuses AUTOSAVE_MS; `brief/ui.md` doesn't describe the note's Sprints section, so nothing was added there.

    Verification: npm check 0 errors, npm test 602 passed (4 new buffer tests), npm run build ok. No Rust changes. Not run in the app — row alignment and the select's height next to the date inputs want an eyeball pass.
assignee: steve
label:
- feature
priority: medium
task_status: done
tech: null
---
So that a project or initiative note shows its Roadmap in place, edited the way Sprints are: a section of rows with a title, a description, a done tickbox instead of a progress bar, a kind selector from the Roadmap Entries pool, and date fields that follow the kind's mode. Sprint association is the next task; this one lands the section, the rows, and the save path.

## Agreed layout

```
Roadmap                                     N of M done   [collapse all]
┌ [✓] 1.0 release                  Release ▾   Date  [2026-10-11]        ⋮ ┐
│     description…                                                          │
└──────────────────────────────────────────────────────────────────────────┘
┌ [ ] Cross-platform                  Phase ▾   Start [……]  End [……]     ⋮ ┐
…
[Add entry]
Sprints …                                   (project)   /   Projects … (initiative)
```

## Agreed work

- [ ] `NotePane.svelte`: `<section class="roadmap">` inserted before `<section class="sprints">` (~L1200) and before `<section class="projects">` (~L1452), gated on `note_type` project | initiative, shown in Read, Live and MD modes like Sprints. Reuse `sec-head` / `sec-count` ("N of M done"), the `sprints-empty` card ("No roadmap yet — Add entry"), `rowToggle` / `collapseAll` (~L957) and `rowCollapse.svelte.ts` keyed by entry id, and the sprint drag-reorder handlers (~L754) generalised or duplicated for roadmap rows.
- [ ] Row: tickbox (`done`) at the left, title input, description textarea in the expanded body, a kind `<select>` listing the `roadmap_entry` values (colour swatch from the value's `colour`), then the date controls: `date_mode` single → one "Date" input bound to `start`; range → "Start" and "End" inputs. Changing kind keeps the stored dates (ADR 0072). Delete via the row's ⋮ / × as sprints do. "Add entry" at the foot of the list (NOT-527 placement).
- [ ] Edit buffer in `noteDocs.svelte.ts`: `doc.roadmap`, `addRoadmapEntry` (mints `"r" + 6` client-side as `addSprint` does), `setRoadmap{Title,Description,Done,Kind,Start,End}`, `removeRoadmapEntry`, `moveRoadmapEntry`. Saves go through the `set_roadmap` command on the same debounce as `markEdited`, **not** through `update_note`; the editor's full-replace flush leaves `roadmap` alone. Adopt the server's returned list after save so ids and cleared fields match.
- [ ] Load the `roadmap_entry` taxonomy once per pane (the `taxonomyRev` store bumps on change) for the select.
- [ ] Encrypted / locked notes: hidden like Sprints (`!handle.doc.locked`).
- [ ] `brief/ui.md`: describe the Roadmap section if it describes Sprints.
- [ ] Tests: whatever covers the sprint buffer mutators in `noteDocs` gets roadmap twins.

## Notes

The initiative variant is the same section; only the sprint picker (next task) differs between the two note types. The Planner right panel is untouched here.