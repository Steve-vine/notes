---
id: 01M5AC8Z4T9HGH3TGB0ZF1YW20
created: 2026-10-19T15:25:25.530779Z
updated: 2026-10-19T15:25:29.162454Z
type: task
title: Triage has "Assign to me" beside Owner, so a handler can take an incident in one click
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1119
sprint: serbigk
assignee: steve
label:
- feature
priority: low
task_status: todo
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