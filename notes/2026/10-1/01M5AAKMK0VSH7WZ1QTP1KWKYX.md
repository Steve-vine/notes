---
id: 01M5AAKMK0VSH7WZ1QTP1KWKYX
created: 2026-10-19T14:56:18.016524Z
updated: 2026-10-19T14:56:40.735155Z
type: task
title: An incident is eradicated between contain and recover — what was removed and how, when and by whom, or not applicable with a reason
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1118
sprint: serbigk
assignee: steve
label:
- feature
priority: medium
task_status: todo
---
Sprint 76 follow-up. Requested by Steve smoke-testing staging, 2026-10-19. Blocked by the page layout task (COM-1117), which gives it its place in the **Respond** area: Contain → **Eradicate** → Recover.

Eradication is the step NIST SP 800-61 and ISO/IEC 27035 put between containment and recovery: removing the cause (the malware, the compromised account, the faulty change) so recovery doesn't bring it back. It strengthens the evidence for SOC 2 CC7.4, ISO 27001 A.5.26 and the IMA response controls.

## What people see

A new **Eradicate** card, between Contain and Recover:

- Once the incident is contained, or containment was marked not applicable, a handler can **Mark eradicated**. They record:
  - **What was removed, and how** (required), e.g. "Reimaged the laptop; reset the user's password and revoked their sessions";
  - **When** (defaults to now; not in the future, not before it was contained);
  - **Root cause addressed?** Yes / Partly / Not yet known.
- Or **Not applicable**, with a reason, e.g. an outage with nothing to remove.
- The card then shows what was recorded, when, and who recorded it.
- **Recover** opens only once Eradicate is settled, as Recover waits for Contain today.
- The status reads **Eradicated** between Contained and Recovered: on the page, in the register's status filter, on the Overview and in exports.
- The **Timeline** gets an entry ("Eradicated: …" / "Eradication marked not applicable: …"). **Key times** shows when it was eradicated.

## Rules

- Like the other stages: forward only, frozen at closure, and changed after closure only through a correction with a reason.
- **Closing** checks Eradicate is settled, alongside Contain and Recover.
- **Recover** no longer asks "Was the cause removed first?" (asked today for service incidents). That question belongs to Eradicate now.
- **Incidents already past this point** (recovered, in review or closed before this ships) show Eradicate as "Not recorded — before this step existed", and nothing is asked of them. Recover's old "cause removed" answer still shows where it was given. An open incident that is Contained but not yet Recovered gets the Eradicate step next.
- The assistant can mark an incident eradicated, or eradication not applicable, as the person (as it does for contain and recover).

## Notes (technical)

- A new status `eradicated` between `contained` and `recovered` in `IncidentStatus`, plus `eradicated_at`, `eradication_summary`, `root_cause_addressed`, `eradicated_by`, `eradication_na_reason`. Migration: create/extend the enum explicitly (Alembic enum memories), and add the columns nullable so existing rows are untouched.
- `core/incident_timeline.py` `_SENTENCES` for the two new event kinds; the stage rule in the stages code (recover requires contain **and** eradicate settled; existing incidents already past recover are exempt).
- Closure completeness check, Overview (status counts; durations stay contain/recover unless trivially added), register filter, exports/incident report and the HIPAA log columns where stages appear.
- `cause_removed` on recovery: stop asking it; keep the column and keep showing old answers.
- Assistant: `incidents_eradicate`; `incidents_stage_not_applicable` accepts the eradicated stage. Run every `test_assistant*.py`.
- ADR 0116 gets an amendment paragraph (§6 stages) recording the new stage.
- Run all `tests/test_incident_*.py`, and the stage migration test with raw-SQL seeding.

**Done when:** on staging an incident goes Contained → Eradicated → Recovered, with the eradication facts on the card, the timeline and the incident report, and an incident recovered before this shipped shows "Not recorded" without blocking its closure.