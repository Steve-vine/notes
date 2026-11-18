---
id: 01M7QSM8VXHJJWBYRMJEQGVND6
created: 2026-11-18T17:00:18.685826Z
updated: 2026-11-18T22:56:34.009065Z
type: task
title: A flowchart shown from another document has one link under it, not two
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1965
sprint: s2q1gxe
comments:
- id: 01M7QSMVFRSR69FXPWTQ93W3NA
  author: Steve Vine
  at: 2026-11-18T17:00:37.752259Z
  text: 'Coordination agreed with compass-da (18 Nov, ~17:02 GMT): none of the open round-2 PRs touch FlowchartRefFigure.tsx or shown.test.tsx, and no remaining task plans to. Those are #1941 Group, #1946 line styles and #1947, the fix for main''s build. This task is ours: rebase on origin/main right before pushing, and tell compass-da when it merges.'
- id: 01M7RE0J476VK07MVHGH5BSFFS
  author: Steve Vine
  at: 2026-11-18T22:56:32.903472Z
  text: |-
    Merged: PR #1968, merge 6d1fc234. No migration.

    What changed: under a flowchart shown from another document there's now one link, "{title}, version {n}", which opens the flowchart. The second link, "Open the flowchart ↗", went to the same place and is gone. "(version N is published)" still shows beside the link when a newer version exists. The link reads as its title and version, and shows "Open the flowchart {title}" on hover. It's the same piece everywhere such a flowchart is read: Content's Read view and editor, the Library reader and the User Portal. The reading pane doesn't show flowcharts.

    compass-da: FlowchartRefFigure.tsx and shown.test.tsx changed in this PR.
assignee: steve
label:
- improvement
priority: low
task_status: review
---
Steve, testing on staging (18 Nov): a document showing "An existing flowchart" has two links under the chart, e.g. "Test document, version 1" and "Open the flowchart ↗". Both go to the same place (/content/test-document), so the second is redundant.

**Where:** content/flowchart/FlowchartRefFigure.tsx. The title link "{title}, version {n}" and the "Open the flowchart" link both point to `/content/{slug}`.

**Done when**
- Under a shown flowchart there's one link: "{title}, version {n}", which opens the flowchart.
- "(version N is published)" still shows beside it when a newer version exists.
- The remaining link still has a clear accessible name.
- This holds wherever such a flowchart is read: Content's Read view and editor, the Library reader and pane, and the User Portal.
- shown.test.tsx is updated: it looks for the "Open the flowchart …" link today.

Coordination: this is Content Flowcharts code. compass-da is merging flowchart round 2 into content/flowchart/. Rebase on origin/main right before pushing, and tell compass-da when it merges.

Independent: frontend only.