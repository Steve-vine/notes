---
id: 01M79ACKXM5KTXKV8Y6PXTC98E
created: 2026-11-13T02:04:37.172523Z
updated: 2026-11-13T02:04:41.148283Z
type: task
title: Vulnerability history, Polaris's ask-first card and the issue row name things in screen words, never identifiers
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1782
sprint: spsp226
assignee: steve
label:
- bug
priority: low
task_status: active
---
Found in the sprint 116 round-4 pre-UAT pass on staging (6e988b9d, 2026-11-13), from COM-1772, COM-1774 and COM-1776.

**What happens:**
1. A vulnerability page's History, after Move to a system…, shows "Container: — → 934a655e-…"; adding a comment shows "created vulnerability comment fd3bf5ec-…". The Sources table's "Its reference" for a pen test shows the raw import identifier.
2. Polaris's ask-first card for a pen-test finding reads "Remove 3 from 058939d0-…" / "Report: 058939d0-…".
3. A register issue row for an issue that is only company-wide reads "1 system".
4. The activity summary for an audit finding reads "deleted audit finding finding AUD-1-F2".
5. Pen-test finding rows in the activity log carry no company, so Admin ▸ Activity filtered by company doesn't show them.

**What it should do:** (1) "moved from Company-wide to AST-51 · Name", "added a comment", and the report's name linked to its import; (2) the report's name ("Pen test, 10 Nov 2026") and the finding's title; (3) "Company-wide" (or "1 system, company-wide" when mixed reads oddly — keep it plain); (4) "deleted audit finding AUD-1-F2"; (5) pen-test finding rows belong to the import's company.

**Done when:** each of the five reads/behaves as above on staging in E2E Test Company; tests cover each. Say whether old rows change.