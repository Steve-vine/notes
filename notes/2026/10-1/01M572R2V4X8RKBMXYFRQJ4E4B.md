---
id: 01M572R2V4X8RKBMXYFRQJ4E4B
created: 2026-10-18T08:41:11.780021Z
updated: 2026-10-18T12:29:42.182502Z
type: task
title: An incident says what it hit and what it touches — the service impact and outage window, the C/I/A impact, the assets, data assets and vendors involved, and links to risks, controls, decisions and related incidents
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1069
sprint: serbigk
blocked_by:
- 01M572Q0FYNV11AEM6VZXWZ99Q
comments:
- id: 01M57FTF63999PXDTSJXY01KPR
  author: Steve Vine
  at: 2026-10-18T12:29:41.44383Z
  text: |-
    Done: merged in PR #1068.

    - **Service impact** (Availability incidents) records:
      - the services affected, picked from Inventory or typed if not registered;
      - outage start and end, with the duration worked out ("Still going" until it ends);
      - full or degraded;
      - customers affected (a number or "All customers");
      - whether an SLA was breached (yes, no or not known).
    - **Security impact** (Security incidents): confidentiality, integrity and availability each ticked affected or not, plus the attack or cause type and detail. Suspected or Confirmed is shown from triage.
    - **Involved** (every incident): technology assets, data assets, and vendors marked "caused it", "was affected" or "helped respond", plus how many people were affected and whether they're internal or external. Only the incident's own company's records can be linked.
    - **Links** (every incident):
      - risks: link one, or raise a new one pre-filled from the incident;
      - controls: by ref or by framework requirement, as in SAP;
      - decision records;
      - related incidents, at any company;
      - external references: the ISE incident (IN-1234) or a web link.
    - Every add and remove goes on the timeline under the target's name at that moment.
    - Linked assets, data assets, vendors, risks and decision records each list the incident under "Incidents", for people who can see the register.
    - An Inventory asset named by an incident can't be deleted, only decommissioned.

    Choices made:
    - Decision links are made from the incident, not from the decision's page, so they always land on the incident's timeline.
    - Related incidents appear on timelines by reference only, never by title, so a restricted case can't leak through another incident's history.
    - Linking needs incident handling. Raising a brand-new risk still needs risk permissions.
assignee: steve
label:
- feature
priority: high
task_status: review
---
Sprint 76, Incidents - Register (ADR in COM-1063). Builds on COM-1066. It answers EVM.19, IMA.17 (magnitude) and VEM.13 (suppliers).

## What people see

**Service impact** section, shown when a category brings it (Availability):
- the services affected (technology assets from Inventory, or typed if not registered);
- outage start and end, with the **duration** worked out;
- full outage or degraded;
- customers affected (count or "all");
- whether a contractual SLA was breached (yes/no/unknown).

**Security impact** section, shown when a category brings it (Security):
- **Confidentiality / Integrity / Availability**: each ticked as affected or not;
- the attack or cause type: phishing, malware, unauthorised access, lost or stolen device, misconfiguration, insider, vendor, other;
- Suspected or Confirmed (set at triage, shown here).

**Involved** card, always shown:
- technology assets and data assets from the company's Inventory;
- vendors from the company's register, marked as "caused it", "was affected" or "helped respond";
- people affected (count, internal or external).
- Each linked asset and vendor shows the incident on its own page under "Incidents".

**Links** card:
- **risks** (link an existing one, or raise a new one with the incident pre-filled);
- **controls** that failed or were relevant (search by ref or by requirement, as in SAP);
- **decision records**;
- **related incidents**, e.g. the same outage at another company (ADR: one company per incident);
- **external references**: the ISE incident (IN-NNNN) and any ticket or report link.

## Rules

- Every link change goes on the timeline.
- Assets, data assets and vendors must belong to the incident's company.

## Notes (technical)

- Reuse `decision_links` (add `incident` as a target type), the risk link pattern (`vendor_risk_links`), and the SAP control link and requirement search.

**Done when:** both sections show for their categories; links can be added and removed while open; the incident appears on linked assets' and vendors' pages.