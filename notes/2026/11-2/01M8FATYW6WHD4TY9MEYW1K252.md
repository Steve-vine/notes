---
id: 01M8FATYW6WHD4TY9MEYW1K252
created: 2026-11-27T20:23:35.558518Z
updated: 2026-11-27T20:25:26.428552Z
type: task
title: 'Patch level: each reporting server shows its build and revision, its installed updates and when it was last updated, and is Behind after a company''s number of days (default 35)'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2206
sprint: smfrbak
blocked_by:
- 01M8FATKBRPVSNTVEM5E7C89ZT
assignee: steve
label:
- feature
priority: high
task_status: todo
---
**On the chain** (new table and API). ADR 0187 §7. After COM-2205.

## What people see
- A **Patch level** section on a reporting server and its technology asset: "Build 20348.2849 · last update installed 12 Nov 2026 (KB5044284) · 41 updates installed", with the list of installed updates (KB number, description, installed on), newest first.
- **Up to date** or **Behind** ("Last update installed 52 days ago; this company expects one every 35 days"). A server not reporting shows its last known patch level with "as of 3 Oct".
- **Inventory ▸ Discovery settings ▸ Servers from the agent** gains **Expect an update at least every [35] days**.
- **Inventory** gets a way to list servers that are Behind (a filter on technology assets, or a column; pick what fits the existing list).
- Updates still never appear in the Software register (ADR 0114).
- Linux servers: build/revision is the kernel and distribution version; "last update" is the newest package install date where the package manager records it, otherwise "Not reported".

## Notes (technical)
- New table of installed updates per discovered resource, replaced whole on each read (same rule as software). Windows: osquery `patches` (hotfix_id, description, installed_on) plus `os_version.revision`; consider `windows_update_history` where present for a more reliable last-installed date — decide in the PR. Parse `installed_on` defensively (locale formats).
- Per-company setting on the agent connection (days, default 35).
- The built-in check that judges this lands with the checks task; this task gives it its facts.

**Done when:** on staging, the test-rig server shows a patch level and flips to Behind when the company's number of days is set below its last update's age; a Windows server Steve installs shows its KBs and last update date (Couldn't check for me).