---
id: 01M74BM2EK8BK6E0JTXS2M3G2G
created: 2026-11-11T03:49:57.843461Z
updated: 2026-11-11T03:50:00.532547Z
type: task
title: 'Assessments: a link with an initiative in it shows an empty list and no filter to clear for someone who can''t see initiatives'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1719
sprint: s0mep0u
assignee: steve
label:
- bug
priority: medium
task_status: active
---
Found in the COM-1717 pre-UAT (2026-11-11, staging 305de68a).

**What happens:** the E2E Assessor can record assessments but can't see initiatives. Opening `/assessments?initiative=1` (a link a colleague shares, say) shows "0 control(s)" and "No controls match these filters". The Initiative filter is hidden from them, so nothing on screen explains the empty list or clears it. The same applies to an initiative's owner who can record assessments but doesn't hold the right to see initiatives: their Assess button works, but the filter it sets can't be seen.

**Done when**
- When an initiative is in the address, the Initiative filter shows, whoever is looking, and "Any" clears it.
- If the initiative isn't among the ones they can list, the filter reads "INI-<n>" rather than a bare number.
- Someone who can't see initiatives, with no initiative in the address, still gets no Initiative filter (as now).

**Where:** `AssessmentsQueuePage.tsx` (the `canSeeInitiatives` guard) and `initiativeFilterOptions`. **Independent**, frontend only.