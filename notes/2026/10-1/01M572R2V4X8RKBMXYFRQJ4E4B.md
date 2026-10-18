---
id: 01M572R2V4X8RKBMXYFRQJ4E4B
created: 2026-10-18T08:41:11.780021Z
updated: 2026-10-18T08:44:38.086904Z
type: task
title: An incident says what it hit and what it touches — the service impact and outage window, the C/I/A impact, the assets, data assets and vendors involved, and links to risks, controls, decisions and related incidents
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1069
sprint: serbigk
blocked_by:
- 01M572Q0FYNV11AEM6VZXWZ99Q
assignee: steve
label:
- feature
priority: high
task_status: todo
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