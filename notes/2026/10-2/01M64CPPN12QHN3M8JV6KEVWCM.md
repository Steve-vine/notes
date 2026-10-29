---
id: 01M64CPPN12QHN3M8JV6KEVWCM
created: 2026-10-29T17:53:10.817526Z
updated: 2026-10-29T20:15:39.981058Z
type: task
title: 'Operators Manual: Reports — registers, framework coverage and the Statement of Applicability'
project: 01M32Q7WT6058ZQFMMRM8KP1K6
number: 21
sprint: sstqjgj
blocked_by:
- 01M64CNWM12FKRY4C9ZPVKB4XW
comments:
- id: 01M64MVKED4FZPR90YTCBMP8HR
  author: Steve Vine
  at: 2026-10-29T20:15:39.980908Z
  text: |-
    Pushed to staging (7fd2b3a): one page, "Download a report". It covers who can download what, and each of the five reports with its formats, file name and columns. It also says plainly that the page has no history and no schedule.

    The report list in CLAUDE.md is still accurate at 0.16.0: framework coverage, the gap, risk and vendor registers as CSV or PDF, and the Statement of Applicability as CSV or Excel.

    Possible app issues for COM:
    - The page checks only posture.view, but four downloads need posture.run_reports, so a custom role can see buttons that fail.
    - The SoA's column is headed "Annex A ref" for every framework.
    - Owners show as email addresses.
    - No report carries a generation date.
assignee: steve
label:
- feature
priority: medium
task_status: review
---
How to get each report out: framework coverage and the gap, risk and vendor registers (CSV or PDF), and the Statement of Applicability (CSV or Excel). Checked against the released version.