---
id: 01M5AC8Z4T9HGH3TGB0ZF1YW20
created: 2026-10-19T15:25:25.530779Z
updated: 2026-10-20T12:18:23.528328Z
type: task
title: Triage has "Assign to me" beside Owner, so a handler can take an incident in one click
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1119
sprint: serbigk
comments:
- id: 01M5AVZQ54RQJHSQ7VJT00N4QN
  author: Steve Vine
  at: 2026-10-19T19:59:59.652099Z
  text: |-
    Done — PR #1119 merged to main (246ebaf3), 2026-10-19 21:00 BST. Goes to staging once all nine sprint-76 follow-ups are in Review.

    - In Triage, the Owner picker has Assign to me beside it. One click makes the person triaging the owner; they can still pick someone else or clear it.
    - The same button sits beside Owner in Record an incident and Edit, so the owner is picked the same way wherever it's set.
    - Using it saves you as the owner when you record the triage, the incident or the edit.
    - An owner who can no longer handle incidents is still shown by name.
    - The incident owner pickers now show job titles, as owner pickers do elsewhere.
    - Colleagues who share a name are told apart by their sign-in in every owner picker in Compass now (Gaps, Risks, Assessments, Vendors too) — the owner-picker part of backlog task COM-1126.

    My call: once you're the owner the button is greyed out rather than hidden — that's how every other owner picker in Compass behaves. Only incident handlers can open Triage, Record and Edit, so it only ever reaches handlers.
assignee: steve
label:
- feature
priority: low
task_status: done
---
Sprint 76 follow-up. Requested by Steve smoke-testing staging, 2026-10-19.

## What people see

- In **Triage**, the **Owner** picker has **Assign to me** beside it, as owner pickers elsewhere in Compass do. One click makes the person triaging the owner. They can still pick someone else, or clear it.
- It only shows for someone who can handle incidents, since only handlers can own one. It's hidden when they're already the owner.
- The same button sits beside Owner in **Record an incident** and **Edit details**, so the owner is picked the same way wherever it's set (my call).

## Notes (technical)

- `incidents/IncidentTriageCard.tsx` and `incidents/IncidentModal.tsx` both build their own owner `Select` from the handler list. Replace both with the shared `components/OwnerPicker.tsx` (`permission="incidents.handle"`), or add its Assign to me button beside the existing Select. Keep the "still the owner, though no longer a handler" fallback option.
- Vitest: Assign to me sets the current user and the triage/record request sends their id.

**Done when:** on staging, Triage, Record an incident and Edit details each have Assign to me beside Owner, and using it saves the person as the owner.