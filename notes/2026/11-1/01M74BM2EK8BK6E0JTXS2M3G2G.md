---
id: 01M74BM2EK8BK6E0JTXS2M3G2G
created: 2026-11-11T03:49:57.843461Z
updated: 2026-11-11T08:10:33.25017Z
type: task
title: 'Assessments: a link with an initiative in it shows an empty list and no filter to clear for someone who can''t see initiatives'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1719
sprint: s0mep0u
comments:
- id: 01M74D0W5H8HCDJCNCG4QWYNMF
  author: Steve Vine
  at: 2026-11-11T04:14:25.969353Z
  text: |-
    Fixed in PR #1717 and on staging (1e507a64, Browser smoke green).

    Pre-UAT (Claude, 2026-11-11): **Passed.**
    Steps: as E2E Assessor (records assessments, can't see initiatives), I opened /assessments?initiative=1.
    Seen: the filter bar now shows "Initiative: INI-1" beside the others, with "0 control(s)". Choosing "Any" brings back all 419 controls, clears it from the address, and the Initiative filter goes away again.
    Screenshot: ~/compass-uat/s0mep0u/COM-1719/
assignee: steve
label:
- bug
priority: medium
task_status: done
---
Found in the COM-1717 pre-UAT (2026-11-11, staging 305de68a).

**What happens:** the E2E Assessor can record assessments but can't see initiatives. Opening `/assessments?initiative=1` (a link a colleague shares, say) shows "0 control(s)" and "No controls match these filters". The Initiative filter is hidden from them, so nothing on screen explains the empty list or clears it. The same applies to an initiative's owner who can record assessments but doesn't hold the right to see initiatives: their Assess button works, but the filter it sets can't be seen.

**Done when**
- When an initiative is in the address, the Initiative filter shows, whoever is looking, and "Any" clears it.
- If the initiative isn't among the ones they can list, the filter reads "INI-<n>" rather than a bare number.
- Someone who can't see initiatives, with no initiative in the address, still gets no Initiative filter (as now).

**Where:** `AssessmentsQueuePage.tsx` (the `canSeeInitiatives` guard) and `initiativeFilterOptions`. **Independent**, frontend only.