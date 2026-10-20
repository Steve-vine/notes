---
id: 01M5CGN35RGZ88J4TD39B9KW6J
created: 2026-10-20T11:20:26.040967Z
updated: 2026-10-20T13:54:07.980972Z
type: task
title: Compass MCP update
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1151
comments:
- id: 01M5CSEG0D02Q1VMZA6M2W5C0D
  author: Steve Vine
  at: 2026-10-20T13:54:06.98969Z
  text: |-
    Merged in PR #1153 at 13:53 UTC on 2026-10-20 (main d719aced).

    **What this covered:** the access-report download cap. A report's CSV download, and the download link the assistant (MCP) hands out, stopped at 10,000 rows, though the assistant said "the download has them all".

    **What changed:**
    - **Download ▸ CSV now gives every row, however many.** The assistant's link does the same.
    - **A PDF still stops at the first 10,000 rows** and says so on its face, pointing to the CSV for the rest. The Download menu labels it "PDF (first 10,000 rows)" when the answer is bigger.
    - **A scheduled report still sends at most 10,000 rows,** marked truncated as before.
    - The screen's table already paged through everything.

    **My calls (the guards kept):**
    - **PDF:** a laid-out table built in memory; 10,000 rows is already a few hundred pages.
    - **Scheduled report:** it rides on an email, and providers refuse large attachments.
    - **The assistant's inline preview stays at 200 rows**, to keep its reply readable. It now says the CSV has every row.

    **Memory:** rows are fetched and written 2,000 at a time, so a big download costs about one copy of the file in memory, not every row held twice as objects.

    **Checks:** new tests for the uncut CSV (cap and batch forced to 2), a truncated PDF, the runner's cap, and the menu label; 106 report integration tests; ruff, mypy, eslint, tsc -b and prettier; schema.d.ts regenerated with no drift. CI green.
assignee: steve
label: null
priority: medium
task_status: review
---
A report’s download stops at 10,000 rows, lift this cap.

