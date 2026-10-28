---
id: 01M62BA14WS55PRV9WF2YCWXRN
created: 2026-10-28T22:50:18.140421Z
updated: 2026-10-28T22:50:50.272519Z
type: task
title: Commitments take effect — a client's breach-notice deadline becomes an incident notification rule that applies when that client is affected, and a promised test or report becomes a SAP activity; proposed by Compass, confirmed by a person
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1444
sprint: s2v7d6y
blocked_by:
- 01M62B9MPDNWE0GB4PQR6B5M2A
assignee: steve
label:
- feature
priority: medium
task_status: todo
---
Sprint 98, Contract Review (ADR 0134, COM-1435).

## What people see

- On a confirmed commitment, **Put into effect** offers what Compass can do with it, shown before anything changes:
  - **Notification** ("Notify ACME within 24 hours of a personal data breach"): a company **incident notification rule** with recipient "ACME (client)", the deadline from the contract (24 hours), counted from awareness, with the note "Contract CR-7 clause 14.3". It **applies only when the incident affects ACME**.
  - **Testing or reporting** ("annual penetration test, summary to the client"): a **SAP** repeating activity (type Testing or Review, yearly, owner = the commitment's owner) linked to the commitment and to the relevant controls.
  - **Certification** ("maintain ISO 27001"): linked to the certificate in the Evidence register. Its expiry becomes the commitment's at-risk date.
  - **Service level / recovery** ("restore within 4 hours"): compared with the systems' recovery targets. Where they're longer, it's flagged At risk with the systems named. Nothing is changed on the systems.
  - Anything else stays **Tracked here**.
- Confirming creates the rule or the activity. The commitment shows **Met by: incident rule "ACME breach notice"** (linked), and the rule or activity shows **From contract CR-7** (linked). Neither can be deleted while the other points at it without a warning; deleting the rule sets the commitment back to Tracked here.
- **Incidents:** a new fact, **Clients affected**, on an incident's impact (pick from the company's clients). Notification rules gain the condition **"Applies only when: client affected is …"**. So the 24-hour ACME rule appears on an incident's notifications only when ACME is ticked. Triage asks "Which clients are affected?" when a privacy breach is recorded.
- **Ending a contract** (term end passed, or marked ended) offers to switch its rules off and stop its SAP activities, with a confirmation.

## Who can do what

- Putting a commitment into effect needs *Review contracts*, plus the target's own permission: adjusting incident rules, or editing the SAP plan. Without it, the option says who can.
- Polaris can propose but never confirm (ADR 0134).

## Notes (technical)

- Incident: a new condition kind `client_affected` (`IncidentConditionKind`, `core/incident_conditions.py` CONDITION_KINDS), an `incident_clients_affected(incident_id, client_id)` table, and a company-owned obligation (the COM-1122 company rules) with that condition.
- SAP: create a series through the SAP service with `created_via="contract"`. The controls are those linked to the commitment's topic, or the position's facts.
- Two-way links: `met_by_kind` / `met_by_id` on the commitment; `contract_commitment_id` on the obligation and on the SAP series.

**Chain:** on the chain (migration + API).

**Done when:** on staging, Steve puts ACME's 24-hour breach notice into effect. A test incident with ACME affected shows the ACME rule with a 24-hour deadline, and one without ACME doesn't. A pen test commitment appears on the SAP plan.