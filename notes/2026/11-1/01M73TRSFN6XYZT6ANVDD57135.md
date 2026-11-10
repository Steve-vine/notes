---
id: 01M73TRSFN6XYZT6ANVDD57135
created: 2026-11-10T22:55:26.709522Z
updated: 2026-11-10T22:55:29.837462Z
type: task
title: Work through an initiative's controls on the Assessments screen — an Initiative filter there, and an Assess button on the initiative's Controls tab that opens it filtered to that initiative
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1717
sprint: s0mep0u
assignee: steve
label:
- improvement
priority: medium
task_status: todo
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