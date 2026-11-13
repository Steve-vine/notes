---
id: 01M79ACVZ7Q312MW09S3VN1AFR
created: 2026-11-13T02:04:45.415939Z
updated: 2026-11-13T10:06:57.065359Z
type: task
title: The New asset window's Owner isn't marked required, and cancelling it keeps the finding's earlier choice
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1783
sprint: spsp226
comments:
- id: 01M79B4KRZGG2M7NKBEK5B7WMR
  author: Steve Vine
  at: 2026-11-13T02:17:43.455634Z
  text: |-
    Built — PR #1775 (auto-merge set; frontend only).

    - The New asset window's Owner has no asterisk; blank still means the company's default vulnerability owner gets its vulnerabilities. A chosen person can be cleared again (a field that's fine blank should be clearable). Every other owner field is unchanged.
    - Choosing "New asset…" on a pen-test finding or in Record a vulnerability now only opens the window; what was chosen before (Company-wide, or the systems) stays. Add to Inventory: the new asset replaces Company-wide, or joins the systems already picked. Cancel: the finding is exactly as it was.
    - Also fixed: a pen-test finding row marked Company-wide had its pill inside a paragraph (invalid markup); now a block — nothing changes on screen.

    Checks: tsc, eslint, prettier; the two touched test files (new tests for Cancel keeping Company-wide, adding replacing it, adding joining earlier systems — the Cancel tests fail on the old code); full vitest suite 4012 passed.
- id: 01M79F2XE68FR4GN5QHPSZF5XY
  author: Steve Vine
  at: 2026-11-13T03:26:42.118237Z
  text: |-
    Pre-UAT on staging (ee4bff02), E2E Test Company: **Passed**.
    Record a vulnerability → Company-wide → New asset…: Owner shows no asterisk under "Leave blank and the company's default vulnerability owner gets its vulnerabilities."; Name and Kind keep theirs. After Cancel, System still shows "Company-wide (no single system)" and the panel says "One company-wide vulnerability, on no single system". Closed without recording.
    Seen outside the bar (logged as COM-1784): the System list offers deleted technology assets (e.g. "E2E UAT4 1780 dup", just deleted). Screenshots ~/compass-uat/spsp226/COM-1783/.
assignee: steve
label:
- bug
priority: low
task_status: done
---
Found in the sprint 116 round-4 pre-UAT pass on staging (6e988b9d, 2026-11-13), from COM-1775 and COM-1776.

**What happens:**
1. The "New asset…" window marks Owner as required (*), while its hint says "Leave blank…" — and blank does work.
2. On a pen-test finding (or Record a vulnerability) with Company-wide chosen, choosing "New asset…" clears Company-wide at once; cancelling the window then leaves the finding with nothing chosen.

**What it should do:** (1) Owner shows no asterisk. (2) The earlier choice (Company-wide, or the systems chosen before) is only replaced once the new asset is added; Cancel leaves the finding as it was.

**Done when:** both behave as above on the pen-test import page and in Record a vulnerability; vitest covers both. Frontend only, independent.