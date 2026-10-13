---
id: 01M4VKSK2PPAM7WDC4J15X9HPG
created: 2026-10-13T21:48:13.782185Z
updated: 2026-10-13T21:48:14.369546Z
type: task
title: 'Bug: the drag badge is the wrong way round when reordering roadmap entries and sprints'
project: 01KY6W9951TW0904DT0GGJVGE7
number: 546
sprint: sd52non
assignee: steve
label:
- bug
priority: medium
task_status: active
tech: null
---
After NOT-545 the drop lands wherever you release, but the pointer badge macOS draws during the drag reads backwards: a red "not allowed" style badge while over the list (where the drop works), a green plus once outside it. Seen on 1.3.1.

## Cause

The lists use HTML5 drag and drop with `effectAllowed = "move"` / `dropEffect = "move"`, the textbook pairing and the same one the Kanban board, dashboard panels and taxonomy values use. The badge is drawn by macOS from the operation WebKit reports, and WebKit's mapping of the HTML5 effects to macOS drag operations is loose and not under our control (WebKit bugs 26700, 34970, 108021; the Mac build's not-allowed cursor handling is a known oddity). There is no combination of effects that can be verified from here.

## Agreed work

- [ ] Move the three row lists — the note's Roadmap and Sprints sections and the Roadmap chart's rows — off HTML5 drag and drop onto pointer events (the Workspace canvas idiom): pointer capture on the grip, a small movement threshold so a click does nothing, the insertion index from the rows' rects (`insertIndexAt`), auto-scroll of the pane near its edges, Escape to cancel. Nothing native is drawn, so there is no badge at all: the row dims and the insertion line shows, as now, and the cursor is `grabbing`.
- [ ] One shared helper (`rowDrag.ts`) feeds all three lists.
- [ ] The Kanban board, dashboard and taxonomy lists keep HTML5 drag and drop for now — same badge quirk, separate task if it bothers.