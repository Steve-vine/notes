---
id: 01M7HXGBNPMHY3CYT7PSK7YVK0
created: 2026-11-16T10:12:40.9937Z
updated: 2026-11-16T15:06:45.958904Z
type: task
title: Evidence alignment
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1863
sprint: s7nqsy0
comments:
- id: 01M7HXTCY5SZA0QTZR59PVMF8A
  author: Steve Vine
  at: 2026-11-16T10:18:07.17307Z
  text: |-
    Read the screenshot: it's a check's capture history (CHK-26, 5 captures).

    Cause: each row's status column is only as wide as what's in it, and it sits at the right of the row. A capture judged by a workflow has a long "Workflow: …" line under its pill, so the column is wide and the pill starts further left. "Unchecked · Not checked" is short, so it hugs the right edge.

    Done when:
    - In the capture history, every row's status column is the same width, with its pill and the line beneath left-aligned, whether it's Compliant, Non-compliant or Unchecked, short or long.
    - The same is checked on the control's Evidence tab and the Evidence register, which use the same piece.
    - A test fixes the column width so the alignment can't drift back.

    Independent (frontend only).
- id: 01M7J8NKQ66RT6A467WVC38YZR
  author: Steve Vine
  at: 2026-11-16T13:27:44.614326Z
  text: |-
    Done — PR #1859, merged to main (76aa134e). Not on staging yet.

    - In a check's capture history, the status column is now the same fixed width on every row, with the pill and the line beneath it left-aligned. A short "Unchecked · Not checked" no longer sits against the right edge.
    - This applies on the check's page and on each check card on a control's Evidence tab. The Evidence tab's table and the Evidence register were already fixed-width and left-aligned.
    - A test pins the width.

    To check on staging: CHK-26's history on CHM.2. The Compliant, Non-compliant and Unchecked pills should all start at the same left edge.
- id: 01M7JEAXT6Z4QPDX248YV2E3NF
  author: Steve Vine
  at: 2026-11-16T15:06:45.958714Z
  text: |-
    **Pre-UAT: Passed** (staging 43d03f09, E2E Test Company, E2E Admin A). I couldn't see the long "Workflow: …" line here.

    Steps and what I saw:
    - CHK-2's page ▸ History, with 4 Unchecked "Not checked" captures and 1 Compliant "E2E Admin A". Every row's status column is the same width (220px), and every pill starts at the same left edge (x=830).
    - ACC.13 ▸ Evidence tab ▸ CHK-2's card history: the same, 220px wide and left-aligned on every row.

    Not covered: E2E Test Company has no capture judged by a workflow, so the long "Workflow: …" line under a pill never appeared. The column is now fixed-width, so it should hold, but look at CHK-26's history on CHM.2 in Test Company to confirm by eye.

    Screenshots: ~/compass-uat/s7nqsy0/COM-1863/ (chk2-page-history-status-column.png, acc13-card-history-status-column.png)
assignee: steve
label: null
priority: medium
task_status: review
---
![CleanShot 2026-11-16 at 10.12.12.png](attachments/2026/11/01M7HXGBNPMHY3CYT7PSK7YVK0/CleanShot-2026-11-16-at-10.12.12.png)
