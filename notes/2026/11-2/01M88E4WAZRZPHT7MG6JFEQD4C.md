---
id: 01M88E4WAZRZPHT7MG6JFEQD4C
created: 2026-11-25T04:06:45.343593Z
updated: 2026-11-25T05:16:38.384058Z
type: task
title: Editing an amendment request only asks for and shows what it actually changes
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2161
sprint: sectbn9
comments:
- id: 01M88G4VYYBH00V0CW7N5HBAMD
  author: Steve Vine
  at: 2026-11-25T04:41:42.110322Z
  text: |-
    Built and merged to main: PR #2158 (82c0bf7e4). No migration. One small API addition (an amendment edit can withdraw a proposed field).

    What people see:
    - Edit request on an amendment opens with what the amendment proposes and the engagement's own values for the rest. Criticality and annual cost aren't required: a criticality-only amendment on an engagement with no cost saves without one. The cost field says "Leave blank to keep it as it is".
    - Only fields that differ from the engagement are proposed. Clearing a field the amendment proposed takes that change back out (e.g. a mistaken £500).
    - After an edit, My requests' summary, the approver's diff and the activity log list only real changes, never "none → none" or "X → X".
    - The pre-UAT's open amendment on Engagement A1 now drops the no-change lines. Its typed £500 still shows because it is part of the amendment; clearing the cost in Edit request removes it.
    - New-vendor and new-engagement edits are unchanged. Amendments proposing cost or departments still edit and show correctly.

    Tested: backend integration for a criticality-only amendment edit (no cost needed, only criticality in summary, proposal and log), withdrawing a mistaken cost, withdraw allowed only on amendments, plus the existing edit, request, department, approval and Polaris tests. Vitest covers the amendment edit form and the approver's diff hiding unchanged fields. CI green first time.

    For Steve to decide:
    1. Clearing a proposed field withdraws that change (the engagement keeps its value). It doesn't blank the field; amendments still can't clear one.
    2. Proposing a value the engagement already has is saved as "unchanged", from the form or Polaris.

    Not checked yet: in a browser (recheck on staging next). Polaris can't use the new "withdraw" option, though its edits get the same "same value = unchanged" handling.
- id: 01M88J4V3G05XD338GT1A1BZP6
  author: Steve Vine
  at: 2026-11-25T05:16:38.383883Z
  text: |-
    Pre-UAT recheck on staging 82c0bf7e4: **Passed**.
    - The existing A1 amendment: the approver's diff and My requests list only criticality and the typed £500, with no "none → none" lines.
    - After "Request info", Edit request opened with "Leave blank to keep it as it is". Clearing the £500 saved without "Required"; the summary and diff then show only "criticality Low → High", and the log reads "annual cost £500.00 → unchanged".
    - A new criticality-only amendment on A2 (no cost) was edited to High with the cost blank: it saved, and the summary, diff and log show only the criticality change.
    - Regression: editing a new-vendor request still updates its summary (cost £3,000), and a new-vendor request still requires a cost.
    Screenshots: ~/compass-uat/sectbn9/COM-2161/recheck-*
assignee: steve
label:
- bug
priority: medium
task_status: review
---
Sprint "Vendor Departments". Found in the round 2 pre-UAT of COM-2143 on staging a63d542b2 (25 Nov 2026). Screenshots: `~/compass-uat/sectbn9/COM-2143/03*`, `04*`, `06*`, `07*`.

## The problem
1. **Edit request on an amendment demands an annual cost the engagement never had.** As E2E Asset Owner, an amendment on "E2E Departments 1503 Engagement A1" (no cost) changing only the criticality. After the approver asks for information, Edit request refuses to save: "Estimated annual cost: Required." The requester has to invent a cost, which then becomes part of the amendment.
2. **After that edit, unchanged fields show as changes.** My requests' summary adds "Changed data types from none to none" and "Changed data entities from none to none". The approver's diff lists "title: X → X", "scope: X → X", "data types: — → —". The activity log reads "title unchanged → …; data types unchanged → none".

## What people see
- Editing an amendment shows what it proposes and lets the requester change it. A field the amendment doesn't propose can be left alone; nothing is required that the amendment doesn't change.
- After the edit, the summary, the approver's diff and the activity log list only the fields the amendment actually changes (e.g. criticality Low → High), never "none → none" or "X → X".
- New-vendor and new-engagement edits behave as now.

## Done when
- In E2E Test Company: an amendment changing only criticality can be edited after "Request info" without typing a cost. The summary, diff and log show only the criticality change.
- An amendment that proposes cost or departments still edits and shows those correctly.
- The open amendment on Engagement A1 (left by the pre-UAT, with a typed £500) reads sensibly.

Independent unless it needs an API change.