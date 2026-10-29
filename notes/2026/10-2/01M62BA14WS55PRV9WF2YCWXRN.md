---
id: 01M62BA14WS55PRV9WF2YCWXRN
created: 2026-10-28T22:50:18.140421Z
updated: 2026-10-29T23:16:23.54287Z
type: task
title: Commitments take effect — a client's breach-notice deadline becomes an incident notification rule that applies when that client is affected, and a promised test or report becomes a SAP activity; proposed by Compass, confirmed by a person
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1444
sprint: s2v7d6y
blocked_by:
- 01M62B9MPDNWE0GB4PQR6B5M2A
comments:
- id: 01M64Z6G2WGASQ2Q4Z6AZMKV5N
  author: Steve Vine
  at: 2026-10-29T23:16:22.748198Z
  text: |-
    Done — PR #1462 merged (c94faab3), migration 0748.

    What's there:
    - **Put into effect** on a confirmed commitment's page: a preview of what Compass would do, then a confirm. The kind decides what happens:
      - **Notification** ("Notify ACME … within 24 hours"): adds a company notification rule.
        - It is "ACME Ltd breach notice (CR-n)", telling "ACME Ltd (client)" within the contract's deadline from awareness. The deadline is read from the wording; you can set it if none is found.
        - It is triggered by the categories that bring a personal data breach, and noted "Contract CR-n clause 14.3".
        - It has the new condition **Applies only when: client affected is ACME Ltd**.
      - **Testing or reporting:** a repeating SAP activity (testing, or review for reporting) at the commitment's cadence, owned by its owner, "From contract CR-n", linked to the controls its position rests on.
      - **Certification:** linked to a certificate in the Evidence register; its expiry becomes the at-risk date (an expired one is At risk at once).
      - **Service level / recovery:** compared with the systems' recovery targets; any slower ones make it At risk, naming them. Nothing on the systems changes.
      - Anything else stays Tracked here.
    - **Two-way links:** the commitment shows "Met by" the rule or activity. The rule shows "From contract" in Incidents ▸ Settings, with a warning on delete; deleting it returns the commitment to Tracked here.
    - **Incidents ▸ Impact ▸ Clients affected:** pick the company's clients, or "None of our clients". It shows prominently when a privacy-breach category is on the incident.
      - Until it's answered, a client's rule still applies (unknown means it applies, as for every other condition).
      - Once answered, the ACME rule applies only when ACME is ticked; otherwise it shows "Doesn't apply: ACME Ltd isn't among the clients affected".
    - **End contract** offers to retire its rules and stop its plan activities (ticked by default).
    - **Permissions:** this needs Review contracts and the target's own permission (Manage incident settings, or managing the plan). Without it, the preview says who can. Polaris can't put a commitment into effect.

    Small gaps for later:
    - The "A client is affected" editor in Incidents ▸ Settings lists clients from Contracts, so someone without View contracts can't pick one there. A rule made from a contract already has its client.

    To test on staging: put ACME's 24-hour breach notice into effect. A test incident with ACME affected shows the rule with a 24-hour deadline; one with "None of our clients" doesn't. A pen test commitment appears on the SAP plan.
assignee: steve
label:
- feature
priority: medium
task_status: review
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