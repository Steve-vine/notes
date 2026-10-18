---
id: 01M54K629ZG5MVJVZGX3PAHN3E
created: 2026-10-17T09:30:43.903179Z
updated: 2026-10-18T07:50:05.915641Z
type: task
title: The SAP calendar and timeline also show the reviews Compass already schedules — access recertifications, asset recertifications and content reviews — read-only, linking through
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1048
sprint: sxflvhs
blocked_by:
- 01M54K5M5TJ48FR4MDKQN96EW7
comments:
- id: 01M558KYE44QXZG8HWXTZJTRC2
  author: Steve Vine
  at: 2026-10-17T15:45:18.788178Z
  text: |-
    Done: merged in PR #1048.

    - The Timeline and Calendar have a "Show other Compass reviews" switch, on by default. It adds:
      - access recertifications and asset recertifications for the company. Upcoming runs are worked out from each schedule, recent ones come from the runs that happened, and each opens where it lives;
      - content reviews (a document's next review date), marked Playbook, on every company's calendar.
    - They're drawn neutral and dashed, with their own icons in the legend, so they don't look like plan entries. They're read-only, and they're never counted in the list, the Overview or the sign-off.
    - You only see a kind if you could open it where it lives (Access Control, Inventory or Playbook permissions).
assignee: steve
label:
- feature
priority: medium
task_status: done
---
Sprint 75, SAP - Schedule (ADR in COM-1041; Steve, D). Built on COM-1047.

## Why

An auditor asks for "the security programme". Recertifications and content reviews are part of it, but they live in their own modules on their own schedules. Showing them here makes the plan complete without anyone entering them twice.

## What people see

- A **Show other Compass reviews** toggle on the Timeline and Calendar (on by default). It adds three kinds of item, each with its own icon and a neutral colour so they don't read as plan entries:
  - **Access recertification:** each schedule's upcoming and recent runs for this company, with dates from the schedule. Click to open the schedule or the run.
  - **Asset recertification:** the same, for technology and data assets.
  - **Content review:** a policy, standard or procedure's next review date. These belong to the shared Playbook, so they show on every company's calendar, labelled **Playbook**. Click to open the content.
- These items **can't be edited, completed or commented on here.** That happens where they live. They don't appear on the List view, in the plan summary's counts, or in the sign-off.
- The legend explains the three icons.

## Rules

- You see an item only if you could open it where it lives. A person without `access.view` sees no access recertifications.
- Overdue for these items follows their own module's rule. SAP doesn't decide it.

## Notes (technical)

- Read-only adapters that return calendar items `{kind, title, start, end, url, status}` from `RecertSchedule` / `RecertInstance` (cadence + start_date, and instances' period/`review_due_at`), the inventory recert equivalents, and `ContentItem.next_review_at`. Keep them behind one small interface. The "Evidence of operation" sources in the backlog follow-up will want a similar one.
- Project future runs from cadence without materialising anything.

**Done when:** the three kinds show on the timeline and calendar for people allowed to see them, open where they live, and stay out of SAP's counts.