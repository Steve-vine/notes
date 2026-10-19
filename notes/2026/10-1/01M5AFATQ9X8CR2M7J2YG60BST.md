---
id: 01M5AFATQ9X8CR2M7J2YG60BST
created: 2026-10-19T16:18:52.2651Z
updated: 2026-10-19T16:19:00.886721Z
type: task
title: The post-incident review write-up records the external incident number, start and resolved times, incident and outage durations — prefilled from the incident — in a larger form
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1123
sprint: serbigk
blocked_by:
- 01M59MVADP1ZQ71GYS8YR8KYTK
assignee: steve
label:
- feature
priority: medium
task_status: todo
---
Sprint 76 follow-up. Requested by Steve smoke-testing staging, 2026-10-19. Blocked by COM-1113 (Write up crashes), which fixes the same form's contributor picker; this builds on the fixed form.

## What people see

The **Write up** form on the post-incident review:

### Renamed
- "When it was held" → **PIR Date**
- "Who took part" → **PIR Contributors**
- "What happened" → **Incident Description**

The same names are used where the completed review is shown on the incident, in the incident report and in the export.

### New fields, near the top after PIR Contributors

| Field | Prefilled with | Notes |
|---|---|---|
| **External incident number** | (blank) | The reference in a separate ITSM system, e.g. ServiceNow "INC0012345". Free text, optional. |
| **Incident start** (date and time) | When it occurred; if that's not known, when it was detected | Editable. |
| **Incident resolved** (date and time) | When it was recovered | Editable. Not before the start. |
| **Incident duration (minutes)** | The recovery time | Editable. |
| **Outage duration (minutes)** | The outage recorded in the Service impact section | Only for incidents with a Service impact section; blank otherwise. Editable. |

- A prefilled value shows a small hint under the field ("From the incident: recovered 18 Oct 14:20") so the reviewer knows where it came from. If they change it, the hint gives the incident's value, so a difference is visible.
- Values are prefilled when the write-up is first opened, and saved with the draft. Later changes to the incident don't silently rewrite a review in progress; the hint shows the new value instead.
- Once the review is completed, these fields freeze with the rest of it.

### A larger form

The form opens wider (extra large) so the text boxes have room. Short fields sit side by side in pairs:
- PIR Date and External incident number;
- Incident start and Incident resolved;
- Incident duration and Outage duration.

On a phone it stacks to one column.

## Rules

- **Completing the review needs**: PIR Date, PIR Contributors, Incident Description, root cause, lessons learned, plan followed (as today), plus **Incident start**, **Incident resolved** and **Incident duration**. These are prefilled, so normally nothing extra to type. **Outage duration** is needed only for incidents with a Service impact section. External incident number is optional.
- Durations are whole minutes, zero or more. Resolved can't be before start, or in the future.
- Saving a draft needs none of them, as today.

## My calls (Steve to confirm)

- **"Recovery time"** for Incident duration is Compass's time to recover, counted from **detection** to recovery (as Key times shows it today). So it can differ from resolved minus start when the incident occurred before it was detected. Say if it should simply be resolved minus start.
- **External incident number** is asked on the review, as requested. It would also be useful on Incident Details and in the register's search, so an ITSM reference finds the incident. Left out for now; say if you want it there too.

## Notes (technical)

- `incidents/IncidentReviewCard.tsx` `WriteUpModal`: labels, new fields, `size="xl"`, a two-column `SimpleGrid` for the short fields (`cols={{ base: 1, sm: 2 }}`); validation via `useFormErrors`; `fromLocalInput`/`toLocalInput` for the datetimes.
- Review model and `IncidentReviewIn/Out`: `external_reference`, `incident_started_at`, `incident_resolved_at`, `incident_duration_minutes`, `outage_duration_minutes` (all nullable). Migration append-only; the completion check in the review code gains the new required fields. Prefill on the server when the review starts, or on first open, from the incident's occurred/detected, recovered and time-to-recover, and the service section's outage start/end. Check those field names in `models/incident.py` and the service impact section.
- Completed review display, incident report PDF and register export: new fields and the renamed labels.
- Assistant `incidents_save_review` / `incidents_complete_review` take the new fields. Run every `test_assistant*.py` and all `tests/test_incident_*.py`. Regenerate `schema.d.ts`.

**Done when:** on staging, Write up opens a wider form with PIR Date, PIR Contributors and Incident Description, and the five new fields prefilled from the incident where it has the value. Completing the review shows them on the review and in the incident report.