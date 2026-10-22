---
id: 01M5G5N3G9GF001WDFQ1CCTMWS
created: 2026-10-21T21:25:09.76965Z
updated: 2026-10-22T19:23:16.102395Z
type: task
title: Risk Assessments appears under Modules — and who can view assessments, run them, and approve them and accept risks
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1220
sprint: s33gwqy
blocked_by:
- 01M5G5MSMWW9GSEARB69GRXTWP
assignee: steve
label:
- feature
priority: high
task_status: active
---
Sprint 83, Risk Assessments (ADR in COM-1219). First feature task; everything else builds on it.

**Chain:** on the chain — API

## What people see

- **Modules ▸ Risk Assessments** (`/risk-assessments`), after Inventory and before SAP, shown only to people who can view it. Company-scoped, following the company picker.
- An empty register for now ("No risk assessments yet"), with the page header and tabs the later tasks fill: **Assessments** and **Overview**.
- Three new permissions in Admin ▸ Roles, in their own **Risk Assessments** group:
  - **View risk assessments** — read every assessment and download its PDF.
  - **Manage risk assessments** — start, edit, submit and withdraw.
  - **Approve risk assessments and accept risks** — approve or send back an assessment, and approve a risk acceptance in the register (COM task on acceptance).
- Built-in Admin holds all three; starter roles are unchanged.

## Notes (technical)

- `risk_assessments.view / .manage / .approve` in `core/permissions.py`; permission catalogue table; IA brief Modules row.
- Breadcrumb trail and menu entry per the Screen conventions.

**Done when:** an Admin sees Risk Assessments under Modules; a role without View doesn't; the three permissions show in the role editor.