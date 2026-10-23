---
id: 01M5G5N3G9GF001WDFQ1CCTMWS
created: 2026-10-21T21:25:09.76965Z
updated: 2026-10-23T18:06:05.386792Z
type: task
title: Risk Assessments appears under Modules — and who can view assessments, run them, and approve them and accept risks
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1220
sprint: s33gwqy
blocked_by:
- 01M5G5MSMWW9GSEARB69GRXTWP
comments:
- id: 01M5JJZ9DQJNP267MPH7T5V8E3
  author: Steve Vine
  at: 2026-10-22T19:56:23.863222Z
  text: |-
    Done — merged in PR #1237 (migration 0495). Not yet on staging.

    - Modules ▸ Risk Assessments appears after Inventory and before SAP, for anyone who can view risk assessments. It follows the company picker.
    - The page has the Risk Assessments header and two tabs, Assessments and Overview. Both say "No risk assessments yet." until the later tasks fill them in.
    - With no company chosen, it says "Select a company to see its risk assessments."
    - Someone without View doesn't see it in the menu. Opening the link tells them they need permission to view risk assessments.
    - Admin ▸ Roles has a new Risk Assessments group, between Inventory and Security Assurance Plan: View risk assessments, Manage risk assessments, and Approve risk assessments and accept risks.
    - The built-in Admin holds all three, including on existing databases (the migration adds them). The starter roles are unchanged.

    My calls:
    - The task was marked "API only", but it needed a migration so that existing databases' Admin role gets the new permissions.
    - The tabs show a fixed empty message until COM-1224 (Assessments) and COM-1228 (Overview) replace them.
    - None of the three permissions is marked dangerous.
    - Menu icon: a checkered shield.
assignee: steve
label:
- feature
priority: high
task_status: done
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