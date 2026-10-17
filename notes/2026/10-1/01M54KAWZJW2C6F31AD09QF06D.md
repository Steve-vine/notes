---
id: 01M54KAWZJW2C6F31AD09QF06D
created: 2026-10-17T09:33:22.290523Z
updated: 2026-10-17T17:55:39.759114Z
type: task
title: Management signs off a year's plan — who approved it, when, with a note, and a copy of the plan as it stood, so later changes show as "changed since approval"
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1056
sprint: sxflvhs
blocked_by:
- 01M54K92R1EN3AEVA0F2YSF56F
comments:
- id: 01M55G2GG8KH77TZA8QH9BXJNX
  author: Steve Vine
  at: 2026-10-17T17:55:36.072261Z
  text: |-
    Done: merged in PR #1055.

    - The Overview has a sign-off panel for the selected year. It shows either "Not yet approved", with "Approve the 2027 plan" for people with "Approve the Security Assurance Plan", or "Approved by Sam Patel (CISO) on …" with the note and "View approved plan".
    - Approving shows the year's entries, with a repeating entry as one line plus its cadence, and asks for a note. It keeps a copy of the plan exactly as it stood.
    - After approval, anything added, removed, moved or cancelled for that year counts as a change: "4 changes since approval", with a list under "See changes". The Schedule marks those entries "Changed since approval".
    - "Approve again" appears once something has changed. The new approval becomes the current one, and earlier ones are listed underneath.
    - A year with no entries can't be approved, and an approval can never be edited or deleted. Approving is recorded in Activity.
assignee: steve
label:
- feature
priority: medium
task_status: review
---
Sprint 75, SAP - Schedule (ADR in COM-1041; Steve, C). Built on COM-1053, which leaves the sign-off space on the Overview.

## Why

ISO 27001 (clauses 5 and 9.3) and SOC 2 (CC1) look for management approving the security programme. The auditor wants to see what was approved, by whom and when.

## What people see

- On the Overview, for the selected year:
  - **Not yet approved**, with **Approve the 2027 plan** for people with `sap.approve_plan`;
  - or **Approved by Sam Patel (CISO) on 3 January 2027**, with their note and **View approved plan**.
- **Approve** shows the year's entries (title, type, owner, dates; repeating ones as one line with their cadence) and asks for a **note** ("Approved at the January board meeting, minute 4.2"). Confirming records the approval.
- **View approved plan** shows the copy as approved, frozen.
- **Changed since approval:** after approval, an entry added, removed, moved or cancelled for that year shows a small "changed since approval" marker, and the Overview says "4 changes since approval". You can open a list comparing the approved copy with now.
- **Approve again** is offered once anything has changed. The new approval becomes current, and earlier approvals stay in a list.

## Rules

- You can't approve a plan that has no entries for that year.
- An approval can't be edited or deleted. A wrong one is superseded by approving again.
- Approving is in Activity.

## Notes (technical)

- `sap_plan_approvals`: company, year, approver (and job title at the time, like `ContentReview.reviewer_job_title`), note, approved_at, and a JSON snapshot of the year's entries (ids + the fields shown). "Changed since" compares the snapshot with live rows on read.
- `sap.approve_plan` was added in COM-1042.

**Done when:** a year's plan can be approved with a note, the approved copy can be viewed, later changes are marked and listed, and re-approval keeps the history.