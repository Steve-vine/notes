---
id: 01M572T0RGS2CD4KH7CN6K7NDD
created: 2026-10-18T08:42:15.184241Z
updated: 2026-10-18T14:06:16.869547Z
type: task
title: A post-incident review records the root cause and lessons learned, and turns each corrective action into a gap or a risk with an owner and a date — required for P1/P2, every breach and every AI incident
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1074
sprint: serbigk
blocked_by:
- 01M572QQ5TYWT3H8VS1JN6Q5F1
- 01M572R2V4X8RKBMXYFRQJ4E4B
assignee: steve
label:
- feature
priority: high
task_status: active
---
Sprint 76, Incidents - Register (ADR in COM-1063). Builds on the stages (COM-1068) and links (COM-1069). It answers ISO 27001 A.5.27, ISO 42001 10.2, SOC 2 CC7.5, IMA.5 and INA.5.

## What people see

When an incident reaches **Recovered**, a **Post-incident review** card appears. It is marked **Required** when the severity or any category says so (Rubrics, COM-1064), and **Optional** otherwise.
- A required review is **due 14 days after recovery**.
- It shows as overdue after that (Actions, later task).

The review records:
- **when it was held** and **who took part**;
- **what happened**: a short narrative;
- **root cause**;
- **contributing factors**;
- **what went well** and **what didn't**;
- **lessons learned**;
- **was the incident response plan followed?** Yes / Partly / No, with notes. This feeds IMA.4.
- **Corrective actions**: each one is raised as a gap against a control, or as a risk, pre-filled from the incident. It is linked both ways and owned and dated in the usual way. Existing gaps or risks can be linked instead. The card shows each action's live status, so open actions are visible from the incident.

Moving to **In review** happens when the review is started. Finishing the review lets the incident close (closure task).

## Rules

- An optional review can be marked **"No review needed"** with a reason.
- A required one can't be skipped. It can only be done.
- The finished review freezes with the incident. Corrective actions carry on in Gaps and Risks after the incident closes. Closure doesn't wait for them, because they are tracked to closure there (INA.5).

## Notes (technical)

- Mirror SAP's finding links (`kind` gap/risk + target), and set `raised_via` the way SAP did.

**Done when:** reviews record their fields; actions raise or link gaps and risks; required vs optional follows Rubrics; the due date is set from recovery.