---
id: 01M73TRSFN6XYZT6ANVDD57135
created: 2026-11-10T22:55:26.709522Z
updated: 2026-11-11T03:52:29.104807Z
type: task
title: Work through an initiative's controls on the Assessments screen — an Initiative filter there, and an Assess button on the initiative's Controls tab that opens it filtered to that initiative
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1717
sprint: s0mep0u
comments:
- id: 01M749THSKPREV2ZVJDZ1W3TDZ
  author: Steve Vine
  at: 2026-11-11T03:18:33.011384Z
  text: 'Built in PR #1716, 2026-11-11. This turned out to be **independent**, not on the chain: the filter reads the initiative''s existing controls list in the browser, as the maturity and owner filters already do, so there''s no API change and no migration. Choices made: the filter lists open initiatives first, then finished ones marked "(Complete)" or "(Cancelled)". It shows only to people who can see initiatives. The Assess button shows to anyone who can record assessments, on a finished initiative too.'
- id: 01M74BRH173TXNKVGGBKSK5Y3A
  author: Steve Vine
  at: 2026-11-11T03:52:23.847154Z
  text: |-
    Pre-UAT (Claude, 2026-11-11, staging 305de68a): **Passed**, with one defect found and logged as **COM-1719** (fix in PR #1717).
    Steps: as E2E Admin A, I started "E2E 20261111 COM-1717 assess filter" (INI-4) in E2E Test Company.
    Seen:
    - With no controls, the Controls tab shows "Add controls first" and a disabled Assess.
    - After adding INS.1 and INS.3, Assess opens /assessments?initiative=4. The list and progress card show only those 2 controls, the filter reads "Initiative: INI-4 …", and the breadcrumb leads back to INI-4.
    - Opening INS.1 shows "1 / 2". The Down arrow goes to INS.3, "2 / 2", the end of the run.
    - A reload keeps the filter. "Any" brings back all 419 controls.
    - I marked INI-4 Complete. Assess still shows on it, and the menu lists "INI-1 E2E initiative" first, then "INI-4 … (Complete)".
    - The Viewer (can't see initiatives) gets no Initiative filter. The Analyst owns INI-1 but can't record assessments, so gets no Assess button.
    Defect: the Assessor (records assessments, can't see initiatives), opening /assessments?initiative=1, got an empty list with the filter hidden and no way to clear it. Logged as COM-1719.
    INI-4 is left in E2E Test Company as a completed test record.
    Screenshots: ~/compass-uat/s0mep0u/COM-1717/
assignee: steve
label:
- improvement
priority: medium
task_status: review
---
Steve wants to work through all of an initiative's controls the way he works through controls on Posture ▸ Assessments: one after another, with Save & next and the arrow keys. Today an initiative's Controls tab lists them, but each one is assessed on its own. The simple fix reuses the Assessments screen rather than building a second one.

## What people see

**On Posture ▸ Assessments**
- A new **Initiative** filter sits beside Domain, Framework, Tier and Maturity. It lists the company's initiatives, with open ones first; finished ones are marked as finished.
- Choosing an initiative narrows the list to that initiative's controls, which are the controls on its Controls tab. It combines with the other filters like any other filter.
- The filter is kept in the address like the others, so a link to the filtered list works, and so do Back and coming back to the list.
- The progress card and the run (Save & next, ↑/↓) cover only the filtered controls. The last control in the initiative ends the run.
- Clearing the filter shows every control again.

**On an initiative's Controls tab**
- An **Assess** button opens Posture ▸ Assessments with the Initiative filter already set to this initiative.
- It shows to anyone who can record assessments. Someone who can't record them doesn't see it.
- The breadcrumb trail on the Assessments screen leads back to the initiative.
- An assessment saved this way is an ordinary assessment of the control, and the initiative's tabs and percentage pick it up as they already do.
- If the initiative has no controls, the button is disabled with "Add controls first".

## Done when
- [ ] Posture ▸ Assessments has an Initiative filter that narrows the list to that initiative's controls and combines with the other filters.
- [ ] The filter is kept in the address, and a reload or Back keeps it.
- [ ] Save & next and ↑/↓ step through only the filtered controls, and the progress card counts only them.
- [ ] The initiative's Controls tab has an Assess button that opens Assessments filtered to the initiative. It is hidden from people who can't record assessments and disabled when the initiative has no controls.
- [ ] The breadcrumb from there leads back to the initiative.
- [ ] Tests cover the filter (API and screen) and the button.

## Notes (technical)
- Probably **on the chain**: the assessments list needs an `initiative` query parameter, filtered server-side to the initiative's controls. Filtering client-side would mean fetching the initiative separately and would break paging and counts. If the existing list call can be filtered without an API change, it becomes independent.
- Frontend: `AssessmentsQueuePage.tsx` adds `useQueryState('initiative')` beside domain, framework, tier, status and maturity (COM-792 URL-backed filters). The button goes in the Controls tab of `InitiativePage.tsx` and links to `/…/assessments?initiative=<id>`.
- Fields on one row: the filter bar stays a `FieldRow` if any filter has a description (COM-1623).