---
id: 01M572WH29P29JZEZ5Y5K8JVKT
created: 2026-10-18T08:43:37.417876Z
updated: 2026-10-18T18:28:39.970985Z
type: task
title: The incident controls show their Evidence of operation — handled incidents prove the response, review, notification and AI-incident controls work, with the last one handled and anything overdue
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1081
sprint: serbigk
blocked_by:
- 01M572TC5E35KF0JEX9T9B3BK0
assignee: steve
label:
- feature
priority: medium
task_status: active
---
Sprint 76, Incidents - Register (ADR in COM-1063). Builds on closure (COM-1075). The second source for the Evidence of operation card (ADR 0115, COM-1051).

## What people see

On a company's assessment of these controls, the **Evidence of operation** card lists incidents alongside SAP entries:

| Control | Evidenced by |
|---|---|
| IMA.2 report weaknesses / A.6.8 | Reports from the portal (count in the last 12 months, the latest) |
| IMA.4 respond per the plan | Closed incidents, and whether the review said the plan was followed |
| IMA.5 lessons learned | Completed post-incident reviews with corrective actions raised |
| IMA.8 / IMA.19 notification | Notifications sent, and on-time or late |
| IMA.10 triage | Triage decisions, triaged-out ones included |
| IMA.11 / IMA.12 categorise and prioritise | Incidents with categories and severity set at triage |
| IMA.17 magnitude | Breach assessments with a validated count |
| IMA.18 closure | Incidents closed through the checklist |
| AIG.16 AI failures | AI incidents handled |
| PDH.16 disclosures recorded | Privacy incidents |

- Each line shows **the latest incident** (its reference and closed date) and the **count in the last 12 months**.
- It also shows **warnings**: overdue notifications, overdue reviews, notifications sent late.
- **Having no incidents is not a failure.** The card says "No incidents in the last 12 months" and nothing more. Overdue and late items only *show*; they never change a control's status or raise a gap (ADR 0115, Steve's decision F).

## Notes (technical)

- Register an `incidents` source in `core/evidence_of_operation.py`. Look controls up by their library **key**, not their ref (memory: control key vs ref, COM-1062).
- Restricted incidents show as "1 restricted incident" to people not named.

**Done when:** each control above shows its incident evidence on a company's assessment, with warnings, and nothing changes status by itself.