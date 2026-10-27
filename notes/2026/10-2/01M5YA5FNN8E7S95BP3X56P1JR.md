---
id: 01M5YA5FNN8E7S95BP3X56P1JR
created: 2026-10-27T09:13:22.869004Z
updated: 2026-10-27T18:38:21.870562Z
type: task
title: Vulnerabilities appears in Modules — per company, with Overview, Register and Settings tabs, and who can view, work, accept and manage them
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1363
sprint: s6wypy5
blocked_by:
- 01M5YA50427VV9TF8B3VTA44Q6
comments:
- id: 01M5ZAG028A6FRDSJ35FM0WJDT
  author: Steve Vine
  at: 2026-10-27T18:38:21.768018Z
  text: |-
    Done — PR #1378, merged to main (migration 0714_vulnerabilities).

    - Modules ▸ Vulnerabilities sits after Inventory and before Risk Assessments. It is company-scoped and shown to anyone who can view vulnerabilities; without that permission it's absent from the menu and refused by URL.
    - Tabs: Overview, Register and, for managers, Settings. Settings has "Show informational items" (off by default) and "Owner when a system has none".
    - Permissions vulnerabilities.view / .work / .accept / .manage, granted to the built-in Admin only. The starter roles are untouched.
    - The migration makes every table the register needs: vulnerabilities, sightings, comments, each company's settings and VUL counter, and the fix-by rubric seeded 15 / 30 / 90 / 180 days, none for Informational. Later tasks add no migrations of their own.
    - Vulnerabilities are in global search by VUL reference, title and CVE.

    Also fixed while landing it: tests now start with the file store read afresh. A few seconds of cached store state was leaking between tests, so one test saw "Attachments store not configured" because of another.
assignee: steve
label:
- feature
priority: high
task_status: review
---
Sprint 91, Vulnerabilities - Register (ADR in COM-1362). The first build task; every later sprint 91 task builds on it.

## What people see

- **Modules ▸ Vulnerabilities**, after Inventory and before Risk Assessments. That follows the reading order: what a company holds, what is wrong with it, what could go wrong.
  - Company-scoped like Incidents: the company picker chooses whose vulnerabilities you see.
  - Shown to anyone who can view vulnerabilities.
- **Tabs:**
  - **Overview** (the dashboard, a later task; until then a short "nothing recorded yet" state);
  - **Register**;
  - **Unmatched** (added in sprint 92, hidden until then);
  - **Settings**.
- **Settings**, per company:
  - **Show informational items**: off by default;
  - **Default owner when a system has none**: a person, or leave unassigned.
  - Fix-by targets are an Admin rubric (a later task), not here.

## Who can do what

| Permission | Allows |
|---|---|
| View vulnerabilities | See the module, register, overview and history |
| Work vulnerabilities | Record, assign, change severity, mark fixed or false positive, raise a risk, comment |
| Accept vulnerabilities | Accept a vulnerability (a sign-off) |
| Manage vulnerabilities | Change Settings; in sprint 92, map sources to the company and keep matching rules |

Built-in Admin only. The starter roles stay frozen.

## Notes (technical)

- Permissions `vulnerabilities.view`, `.work`, `.accept`, `.manage` in `core/permissions.py`; record them in `brief/permission-catalogue.md`.
- `nav.ts`: a new `NavGate` in section Modules, path `/vulnerabilities`; add it to the IA brief's Modules table.
- Tables: vulnerabilities, sightings, a per-company settings row and a per-company reference counter. Audited, and in global search, with title and VUL reference.

**Chain:** on the chain (migration + API).

**Done when:**
- an Admin sees the module and can save Settings;
- someone without the view permission doesn't see it in the menu or reach it by URL.