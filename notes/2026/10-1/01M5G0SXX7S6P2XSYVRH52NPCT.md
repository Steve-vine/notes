---
id: 01M5G0SXX7S6P2XSYVRH52NPCT
created: 2026-10-21T20:00:24.999944Z
updated: 2026-10-21T20:35:19.598568Z
type: task
title: Audit appears in the menu below Modules, with Evidence inside it — and who can view it read-only, manage evidence, and delete archived evidence
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1199
sprint: sno3i7m
blocked_by:
- 01M5G0SH9NVF55RT8FF5ZFKD93
assignee: steve
label:
- feature
priority: high
task_status: active
---
Sprint 82, Evidence (ADR in COM-1198). The first build task; every later task builds on it.

**Chain:** on the chain — API

## What people see

- A new menu section, **Audit**, below Modules and above Portals. For now it holds one item, **Evidence**. The heading appears only when the person can see something in it.
- **Audit ▸ Evidence** follows the company picker, like Incidents.
- Tabs, each filled in by a later task and hidden until then: **Register**, **By core control**, **By framework**, **Archived**, **Audit packs**.
- An archived company's evidence can be read but not changed.

## Who can do what

| Permission | Allows |
|---|---|
| View audit | Open Audit ▸ Evidence: search, open and download evidence, see which controls it supports, see archived evidence, build and download audit packs. Read-only. |
| Manage evidence | Add evidence, edit its details, link it to more controls, replace it with a new version, archive it |
| Delete archived evidence | Download and then permanently delete archived evidence older than a chosen date. **Marked dangerous.** |

- The built-in Admin holds all three. The starter roles stay frozen.
- Evidence on a restricted incident or a data subject request stays out of the register unless the person can also see those. The register never widens who can see personal data.
- Adding files where they already go (an assessment, a plan activity, an incident) keeps its own permission. Manage evidence makes the register one more place to do it; it doesn't replace them.

## Notes (technical)

- `audit.view`, `audit.manage_evidence`, `audit.delete_archived` in `core/permissions.py`; the last is flagged dangerous. A new **Audit** table in `brief/permission-catalogue.md`, and the dangerous list grows to six.
- `nav.ts`: new `NavSection` `'Audit'` between Modules and Portals, a `NavGate` `'Audit'`, path `/audit/evidence`. Record it in the IA brief's menu table.
- Page shell with the tabs and a route guard. No data yet.

**Done when:** an Admin sees Audit ▸ Evidence; a role holding only View audit sees it with no way to change anything; someone without it sees neither the section nor the page by its address.