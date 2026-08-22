---
id: 01M0D86J2RJV317EKTPNN6XBJR
created: 2026-08-19T14:53:26.488198Z
updated: 2026-08-22T06:55:32.942618Z
type: task
title: Admin - Users tab layout
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 285
sprint: s5thbzy
comments:
- id: 01M0K9WBSNWP99BFXAGBCXJZ6X
  author: Steve Vine
  at: 2026-08-21T23:18:16.117696Z
  text: |-
    Fixed — PR #338, merged to main. Frontend only.

    Both symptoms turned out to be one cause: Admin → Users is wider than the panel it sits in, and **Status is the last column** — so the Disable/Enable action was off the right-hand edge (unreachable, not merely cramped), and the pill beside it lost its label to an ellipsis, which is the "concatenated" pill you saw.

    - The table is wrapped in a `Table.ScrollContainer`, so the overflow is something you can scroll to and the columns keep the widths they need rather than being squeezed.
    - The pill and its button both hold their size. In a nowrap Group they were the two things flex could shrink, which is why the label went first. Source got the same treatment — a provenance badge reading "Entr…" tells a reader nothing.
    - Status now renders through the shared `StatusPill`, so it reads **Active** and **Disabled** — capitalised, in the same colours a status has everywhere else in the app.

    Worth checking at a narrow window when you smoke-test: the fix is that the column scrolls into reach rather than being clipped.
assignee: steve
label: null
priority: medium
task_status: done
---
Some of the pills, E.g. (Active) and (Disabled) under status are concatenated, these always need to be complete.
The ‘Disable’ link next to each status pill goes off the screen, this needs to always be fully visible.