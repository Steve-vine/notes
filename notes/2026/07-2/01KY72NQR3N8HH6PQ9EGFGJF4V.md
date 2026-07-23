---
id: 01KY72NQR3N8HH6PQ9EGFGJF4V
created: 2026-07-23T08:50:02.115779Z
updated: 2026-07-23T11:00:29.302453Z
type: task
title: Blocked by dropdown
imported_from: linear
task_status: done
assignee: steve
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 301
comments:
- id: 01KY72NY6SJ65Q13REFT4AERS2
  author: Steve Vine
  at: 2026-07-23T08:50:08.7294Z
  text: |-
    Steve Vine · 2026-07-12:

    Built on `steve/dev-954-blocked-by-dropdown` → PR [#286](https://github.com/Steve-vine/notuvia/pull/286).

    **What was done**

    - Root cause: picker popovers are `width: max-content` (sized to their longest item) and the `clampToViewport` action only clamped against the *window*. The right panel's scrollable body clips horizontal overflow, so a popover wider than the panel couldn't escape it — the viewport nudge just shifted it left inside the scroll container, creating the sideways scroll off the panel's left edge.
    - The action (renamed `clampToPane`, `src/lib/popover.ts`) now clamps against the nearest ancestor that clips horizontal overflow and caps the popover's `max-width` to that box — a popover can never be wider than the pane it lives in. Where nothing clips (the Workspace toolbar's Add-note picker) it falls back to the window, i.e. the old behaviour.
    - Long entries in the `NoteProperties` picker lists truncate with an ellipsis; the Blocked-by search input shrinks with a narrow popover (`max-width: 100%`).

    **Decisions made on the fly**

    - Fixed at the shared action level rather than just the Blocked-by popover: the Type/Project/Milestone/Sprint pickers and the Status/Priority pickers share the same idiom and had the same latent bug with long project/taxonomy names.

    **Checks:** `npm run check` clean, 180 tests pass. Needs your visual pass — worth trying a task with a long-titled blocker candidate and a narrowed right panel.
sprint: sx9znt9
label: null
---
The blocked by dropdown on the right pane is bigger than the size of the pane and scrolls off the left hand side, the dropdown should never be bigger than the pane itself and should truncate task names if they don't fit.

---

## Agreed work

**Diagnosis.** Picker popovers are `width: max-content` (sized to their longest item) and `clampToViewport` (DEV-826) only clamps against the *window*. Inside the right panel — whose scrollable body clips horizontal overflow — a popover wider than the panel can't escape it; the viewport-clamp nudge just shifts it left inside the scroll container, creating sideways scroll off the panel's left edge.

**Fix.**

- [ ] Generalise the popover clamp action (`src/lib/popover.ts`): clamp against the nearest ancestor that clips horizontal overflow (the right panel's scroll body) rather than the window, and cap the popover's `max-width` to that box — a popover can never be wider than the pane it lives in. Falls back to the viewport when nothing clips (e.g. the Workspace toolbar's Add-note picker — unchanged behaviour).
- [ ] Truncate long entries in the `NoteProperties` picker lists (Blocked-by search hits, plus the Type/Project/Milestone/Sprint lists which share the popover idiom) with `text-overflow: ellipsis` instead of letting titles set the popover width unbounded.
- [ ] Keep the Blocked-by search input inside a narrow popover (`max-width: 100%`).

One branch + PR: `steve/dev-954-blocked-by-dropdown`.

---

Linear DEV-954 · Backlog · created 2026-07-12 · done 2026-07-12