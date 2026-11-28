---
id: 01M8FATYW6WHD4TY9MEYW1K252
created: 2026-11-27T20:23:35.558518Z
updated: 2026-11-28T01:37:48.532912Z
type: task
title: 'Patch level: each reporting server shows its build and revision, its installed updates and when it was last updated, and is Behind after a company''s number of days (default 35)'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2206
sprint: smfrbak
blocked_by:
- 01M8FATKBRPVSNTVEM5E7C89ZT
comments:
- id: 01M8FWT929MRT7DCQZ3NPT5NAW
  author: Steve Vine
  at: 2026-11-28T01:37:47.593162Z
  text: |-
    Built: PR #2219, merged to main (not on staging yet; it goes with the sprint's deploy).

    What's there:
    - Each server reporting through the agent now has a patch level: its build and revision, the updates it has installed (Windows) and the date of its last update (Windows, or when a Linux package was last installed or upgraded).
    - A technology asset with such a server shows a Patch level card: "Build 20348.2849 · last update installed 12 Nov 2026 · 41 updates installed", Up to date or Behind ("Last update installed 52 days ago; this company expects one every 35 days"), the updates newest first, and when the agent said so.
    - The server agent card gets "Expect an update at least every [35] days", a Patch level column with Behind, and a "Behind on updates only" switch to list just those.
    - Updates never appear in the Software register.

    A detail worth knowing: Windows writes an update's installed date as text in the server's own locale. Compass reads it month first, as Windows does, and never guesses when it can't be sure. Windows Update's own history, which has exact dates, fills in or confirms it.

    For you to look at:
    - A Windows server's KB list and last update date once one reports (Couldn't check for me).
assignee: steve
label:
- feature
priority: high
task_status: review
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