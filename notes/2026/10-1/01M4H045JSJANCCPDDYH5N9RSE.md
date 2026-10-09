---
id: 01M4H045JSJANCCPDDYH5N9RSE
created: 2026-10-09T18:52:04.56933Z
updated: 2026-10-09T21:53:29.423471Z
type: task
title: 'Initiative type: frontend type plumbing, capture and properties'
project: 01KY6W9951TW0904DT0GGJVGE7
number: 513
sprint: sqcp1k3
blocked_by:
- 01M4H03TJNN8VAXA9HKHDB3EDK
comments:
- id: 01M4HAGBAF2ZF20HMJMM4NAVKN
  author: Steve Vine
  at: 2026-10-09T21:53:29.42298Z
  text: |-
    Built and merged (squash, PR #496), CI green. The branch is deleted.

    What landed:
    - Initiative in every type list: Capture and Properties Type pickers, Settings default-type and per-type default-view, taxonomy scope dropdown and labels, capture prefill, Browse Type folders.
    - One `$lib/typeIcon` helper replaces the ten copies; new `initiative` glyph (Phosphor target) via gen-icons.
    - `initiativeLink.ts` (a Project links up), mirroring projectLink.ts.
    - Capture: an Initiative picker on a Project (keyboard-drivable like the Project picker), written through set_initiative after the save; the "+" prefill carries `initiative` and picks initiative_status on the initiatives board.
    - Properties pane: the same picker; "End" label for an initiative's second date.
    - noteDocs: `initiative` / `initiatives` in the buffer; setInitiative writes through its own command so the link sits outside the dirty snapshot; a Type change away from Project sheds it.
    - TaxonomySettings: initiative_status joins the status axes; the Project-cards toggle is offered for Initiative-scoped taxonomies too.

    Verification: npm run check 0 errors, npm test 535/535 (new initiativeLink, typeIcon, capturePrefill and four noteDocs cases). Not run in the app — the pickers need a visual pass from Steve.
assignee: steve
label:
- feature
priority: high
task_status: done
tech: null
---
So that an initiative can be created in the same way as a project — the capture window and properties pane know the type — and a project can be linked to an initiative. Builds on the commands task. No Planner changes yet; that's the next task.

## Agreed work

- [ ] `initiative` added to every frontend type union and list: `TYPES` in `Capture.svelte` and `NoteProperties.svelte`, `defaultType.svelte.ts`, the default-type and per-type default-view options in `Settings.svelte`, `NOTE_TYPES` in `taxonomyDraft.ts`, the type labels in `TaxonomySettings.svelte`, `CapturePrefill.type`.
- [ ] The ten copy-pasted `typeIcon` helpers (TrashSection, defaultType, NotePane, AddNotePicker, BrowseSection, NoteProperties, WorkspaceView, SchedulesSidebar, Dashboard, SuperSearch) collapsed into one shared helper that includes `initiative`, with a new `initiative` glyph in `iconPaths.ts` generated via `scripts/gen-icons.mjs` (ADR 0063).
- [ ] New `initiativeLink.ts` with `linksInitiative(type)` true for `project` only, mirroring `projectLink.ts`; `PROJECT_LINK_TYPES` unchanged (an initiative never links to a project).
- [ ] Capture window: an Initiative picker shown when the type is Project, next to where the Project picker shows for tasks; the prefill status branch picks `initiative_status` for initiatives; no Identifier field for initiatives.
- [ ] Properties pane: the same Initiative picker on a project; status row uses `initiative_status` on an initiative; `dueLabel` reads "End" for initiatives as it does for projects.
- [ ] `noteDocs.svelte.ts`: `initiative` and `initiatives` in the buffer and flush; type switching clears a stale `initiative` link when a note stops being a project.
- [ ] `notes.ts`: `listInitiatives()` and `initiativeProjects()` wrappers.
- [ ] Tests: `initiativeLink.test.ts`, `capturePrefill.test.ts` for the new type, `noteDocs.svelte.test.ts` for the link round-trip and type-switch clearing; `npm run check` clean.

## Notes

Styled with the existing Nocturne tokens; the picker is the Project picker with a different list behind it, not a new component. A visual pass in the running capture window needs Steve (no screen capture).