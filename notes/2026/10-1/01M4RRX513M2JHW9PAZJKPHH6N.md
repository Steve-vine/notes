---
id: 01M4RRX513M2JHW9PAZJKPHH6N
created: 2026-10-12T19:19:50.05201Z
updated: 2026-10-12T21:14:19.702411Z
type: task
title: Roadmap chart
project: 01KY6W9951TW0904DT0GGJVGE7
number: 543
sprint: sd52non
comments:
- id: 01M4RZESNANT6AASDG423FFKKM
  author: Steve Vine
  at: 2026-10-12T21:14:19.688778Z
  text: |-
    Done in PR #535 (merged 2026-10-12). All five points:

    1. Dates drag on the chart like the project Gantt: a bar moves start+end together, a range bar's edge handles move one date (clamped so start never passes end), live preview, commit on release. A plain click on a bar still opens the note.
    2. Reorder from the chart: a grip appears on hover at the left of each row; drag to an insertion line between the dated rows. Undated entries keep their places (datedInsertIndex, unit-tested).
       Both edits go through the note's shared DocHandle (the NOT-404 idiom) so a pane showing the note stays in step; its roadmap flush writes set_roadmap and bumps noteRev, which refetches the chart.
    3. The rail's right border drags to resize the title column (140–640px), remembered per machine in localStorage.
    4. Kind chip removed from the title column (the colour stays on the bar; the chip remains in the Undated list where there is no bar).
    5. View persistence: the Planner's "has a roadmap?" probe was one value across tabs, so switching away and back found it stale and the fall-back effect knocked the tab onto Kanban before its own probe answered. The fall-back now waits for the probe to answer for that tab's own scope.

    Not seen in-app (no screen capture) — the drag, reorder and border handle want a pass.
assignee: steve
priority: medium
task_status: done
tech: null
---
It should be possible to amend the start and end dates on the roadmap gantt chart like you can on the project gantt.

Allow re-ordering or roadmap items from the chart.

Allow the user to resize the column with the titles in by dragging the vertical border on its right.

Remove the 'kind' from the Title section.

After selecting the roadmap view, if the user switches to a different tab and switches back the display goes back to kanban view. It should remain on the last view like kanban and gantt do.