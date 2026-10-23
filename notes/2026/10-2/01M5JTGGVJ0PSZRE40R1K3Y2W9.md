---
id: 01M5JTGGVJ0PSZRE40R1K3Y2W9
created: 2026-10-22T22:08:08.56276Z
updated: 2026-10-23T18:06:19.631606Z
type: task
title: DDQ appears under Modules — and who can view DDQs, work on them, approve their answers, and release held-back information
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1249
sprint: s5uw2fz
blocked_by:
- 01M5JTGCC18QBK3S98RE8G1RSX
comments:
- id: 01M5KWYWXERZ619V6E86YH0JYF
  author: Steve Vine
  at: 2026-10-23T08:10:11.24655Z
  text: |-
    Done — merged in #1263 (ef1a6c86, migration 0590_ddq_perms).

    - **Modules ▸ DDQ** after Trust Centre, following the company picker. Tabs **Requests** and **Q&A library** ("No DDQs yet." / "No answers in the library yet." until their tasks land), and **Settings** for people who can manage DDQs.
    - **Admin ▸ Roles ▸ DDQ**: View DDQs, Manage DDQs, Approve DDQ answers, Release held-back information (marked dangerous). Built-in Admin holds all four; starter roles unchanged.
    - View DDQs only: the tabs, no buttons. Without it: no DDQ in the menu, and a link to /ddq says you need permission to view DDQs.

    My calls:
    - Menu label and page title are just "DDQ".
    - Release's description on the roles screen also says the item's own classification doesn't change and the assistant can't do it.
    - Menu icon: chat bubbles.
assignee: steve
label:
- feature
priority: high
task_status: done
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