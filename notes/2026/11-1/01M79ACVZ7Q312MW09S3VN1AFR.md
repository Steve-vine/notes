---
id: 01M79ACVZ7Q312MW09S3VN1AFR
created: 2026-11-13T02:04:45.415939Z
updated: 2026-11-13T02:04:50.723869Z
type: task
title: The New asset window's Owner isn't marked required, and cancelling it keeps the finding's earlier choice
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1783
sprint: spsp226
assignee: steve
label:
- bug
priority: low
task_status: active
---
Found in the sprint 116 round-4 pre-UAT pass on staging (6e988b9d, 2026-11-13), from COM-1775 and COM-1776.

**What happens:**
1. The "New asset…" window marks Owner as required (*), while its hint says "Leave blank…" — and blank does work.
2. On a pen-test finding (or Record a vulnerability) with Company-wide chosen, choosing "New asset…" clears Company-wide at once; cancelling the window then leaves the finding with nothing chosen.

**What it should do:** (1) Owner shows no asterisk. (2) The earlier choice (Company-wide, or the systems chosen before) is only replaced once the new asset is added; Cancel leaves the finding as it was.

**Done when:** both behave as above on the pen-test import page and in Record a vulnerability; vitest covers both. Frontend only, independent.