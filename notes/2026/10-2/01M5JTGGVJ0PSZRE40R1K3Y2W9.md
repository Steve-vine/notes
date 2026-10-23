---
id: 01M5JTGGVJ0PSZRE40R1K3Y2W9
created: 2026-10-22T22:08:08.56276Z
updated: 2026-10-23T07:33:29.650287Z
type: task
title: DDQ appears under Modules — and who can view DDQs, work on them, approve their answers, and release held-back information
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1249
sprint: s5uw2fz
blocked_by:
- 01M5JTGCC18QBK3S98RE8G1RSX
assignee: steve
label:
- feature
priority: high
task_status: active
---
Sprint 84, DDQ-1 (ADR in COM-1245).

**Chain:** on the chain — API

## What people see

- **Modules ▸ DDQ** (`/ddq`), after Trust Centre, company-scoped. Tabs **Requests** and **Q&A library** (empty states until their tasks land), plus **Settings** for managers.
- **Admin ▸ Roles** offers four new permissions: **View DDQs**, **Manage DDQs**, **Approve DDQ answers** (also approves Q&A library entries), **Release held-back information**. Built-in Admin holds all four; the starter roles are unchanged.

## Notes (technical)

- Permission keys `ddq.view`, `ddq.manage`, `ddq.approve`, `ddq.release`; catalogue + IA brief rows are in the ADR task.
- Page header and tab titles per *Screen conventions*.

**Done when:** a role with View DDQs only sees the module read-only; a role without it doesn't see DDQ in the menu.