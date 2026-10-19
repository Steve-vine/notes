---
id: 01M5B0CEYKQ2R690TXW5WT4MVD
created: 2026-10-19T21:16:51.539722Z
updated: 2026-10-19T21:16:51.539722Z
type: task
title: Data Subject Requests appears in Modules after Attestations — per company, an empty Requests tab, a Settings tab with the company's privacy contact and default law, and who can view, handle, see restricted requests and change settings
label: feature
priority: high
assignee: steve
task_status: todo
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1130
---
Sprint 79, Data Privacy (ADR in COM-1129). The first build task. Every later task builds on it.

## What people see

- **Modules ▸ Data Subject Requests**, below Attestations, shown to anyone who can view it. Company-scoped like Incidents: the company picker chooses whose requests you see.
- Tabs: **Requests** (empty for now: a one-line empty state saying what goes here), **Disclosures** and **Compliance** (added by later tasks; hidden until then), **Settings**.
- **Settings ▸ Company** (per company):
  - **Privacy contact**: the name, email address and postal address that go on letters (the privacy mailbox, not a person's own inbox);
  - **Default law**: the law a new request starts on (UK GDPR, EU GDPR, HIPAA, US state privacy (CCPA)); changeable on each request;
  - **Regulator** for each law, as it appears on refusal letters: shipped as the ICO (UK GDPR), "your lead supervisory authority" for EU GDPR (the company names it), the HHS Office for Civil Rights (HIPAA), and the California Privacy Protection Agency (CCPA).

## Who can do what

| Permission | Allows |
|---|---|
| View data subject requests | See the module, the register and the Disclosures log. Restricted requests show as a redacted row |
| Handle data subject requests | Log, work and close requests; log disclosures |
| See restricted data subject requests | See and work restricted requests, and mark a request restricted |
| Manage data subject request settings | Change Settings: the company details, deadline rules, letter templates, reasons and retention |

Built-in Admin only. The starter roles stay frozen, as with SAP, Incidents and Attestations.

## Notes (technical)

- New permission identifiers `dsr.view`, `dsr.handle`, `dsr.manage_restricted`, `dsr.manage_settings` in `core/permissions.py` and a new "Data Subject Requests" table in `brief/permission-catalogue.md`.
- `nav.ts`: a new `NavGate`, section `Modules`, path `/privacy-requests` (or `/dsr`; pick one and record it in the IA brief's Modules table).
- A company-scoped settings table (privacy contact, default law, regulator per law), audited.
- Add the module to `brief/information-architecture.md` → Modules.

**Done when:** an Admin sees the module and can save the company's privacy details; someone without the permission doesn't see it in the menu or reach it by URL.