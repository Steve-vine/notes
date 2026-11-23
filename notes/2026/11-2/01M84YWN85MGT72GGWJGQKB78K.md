---
id: 01M84YWN85MGT72GGWJGQKB78K
created: 2026-11-23T19:42:24.005502Z
updated: 2026-11-23T19:42:25.846073Z
type: task
title: Each provided register an auditor opens gets its own Viewed line in the audit's trail
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2126
sprint: ssj8zkq
assignee: steve
label:
- bug
priority: low
task_status: active
---
Sprint "Registers - Phase 2". Found in the auditor portal check of COM-2095 on staging d8a915977 (23 Nov 2026). Screenshot: `~/compass-uat/sprint-122/COM-2095/28-second-copy-view-not-logged.png`.

## The problem
The same register is provided as at the same day on two requests (AQ-2 and AQ-5). The auditor opens both in one visit. AQ-5's copy becomes "Seen by the auditor" and locks, but neither its History nor the audit's Activity has a Viewed line for it. The audit's record of what the auditor opened is incomplete.

## What people see
- Every provided item the auditor opens has its own Viewed line, on its request's History and the audit's Activity, even when the same register is provided on another request.
- Opening the same item again in the same visit doesn't add another line, as for evidence today.
- Downloads are recorded per item in the same way.
- Who can read a line's register name is unchanged (COM-2108).

## Done when
- Opening two provided copies of one register in one visit writes one Viewed line for each.
- Reopening one in that visit adds none.
- Downloading each copy is recorded against the right request.

No migration expected.