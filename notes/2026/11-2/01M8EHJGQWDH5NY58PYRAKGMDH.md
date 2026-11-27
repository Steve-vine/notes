---
id: 01M8EHJGQWDH5NY58PYRAKGMDH
created: 2026-11-27T13:02:04.540993Z
updated: 2026-11-27T22:31:18.39578Z
type: task
title: A recertification removals request names the directory role it takes away — "Global Administrator (eligible)", not "Eligible"
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2187
sprint: smq8t5s
comments:
- id: 01M8EMWHE4V2R4C12S4WEDGS2N
  author: Steve Vine
  at: 2026-11-27T13:59:58.660821Z
  text: |-
    Built — PR #2185, merged to main as ed8ffaa7d (not yet on staging; goes with the sprint deploy).

    What changed:
    - A directory-role review's removals now name the role and how it's held: "Global Administrator (eligible)", "Global Administrator (active)". Held through a group it says so: "Global Administrator (active, through G) — leaves G, which gives Global Administrator". Same on the request page and in Polaris.
    - The approval reason names the role: "takes away a directory role: Global Administrator (eligible)"; several read "takes away directory roles: …; …".
    - The evidence export's role column on directory-role rows reads the same way (was just "Eligible").
    - Worked out when the request is shown, so ACR-37 reads correctly with no data fix. Groups, mailboxes, lists and the Actions item are unchanged.

    For you to look at:
    - Held through a group, the Loses line shows both forms joined by a dash (the brief gave both) — it's long on screen.
    - Anyone reading the export's role column by machine will now see "Global Administrator (eligible)" where it said "Eligible" (directory-role reviews only).
- id: 01M8FA0A8SRB3EXEJ9VNKXX67P
  author: Steve Vine
  at: 2026-11-27T20:09:02.489038Z
  text: |-
    Pre-UAT on staging 30786db4f: Couldn't check (E2E Test Company has no removals request for a directory role).

    Steps: as E2E Admin A, opened Access Control ▸ Requests for E2E Test Company. There are 134 requests (before mine): 132 leavers, 1 joiner and 1 recertification removals request (ACR-197). ACR-197 comes from a group review (Intune.Users.Application.UniPrintDownRight). Its "Loses" column names the group, which is unchanged, as it should be. No directory-role review in E2E Test Company has produced a removals request. The Domain Name Administrator review was withdrawn; Yammer and Viva Pulse had nobody holding them.

    For Steve: on production, ACR-37 should now read "loses: Global Administrator (eligible)", with the approval reason "takes away a directory role: Global Administrator (eligible)". No data fix is needed; it's worked out when the page is shown.

    Screenshots: none. Folder ~/compass-uat/sprint-128/COM-2187/
assignee: steve
label:
- bug
priority: medium
task_status: done
---
**Independent** (wording only — no migration, no API shape change).

Seen by Steve on production 27 Nov 2026 in **ACR-37**, the removals request from the Global Administrator review. S Kinsella's removal reads **loses: Eligible**, and the reason it needs an Access Admin reads "takes away a directory role: **Eligible**". The role's name appears nowhere; only the kind of assignment does.

## What people see
- **Directory-role review removals** (request page, Polaris, the evidence export) say which role and how it's held:
  - "Global Administrator (eligible)"
  - "Global Administrator (active)"
  - "Global Administrator (active, through Intune.Users.Admin.HelpDeskOps)" — held through a group, so the removal takes the person out of that group. Say so: "leaves Intune.Users.Admin.HelpDeskOps, which gives Global Administrator".
- **The approval reason** names the role: "takes away a directory role: Global Administrator (eligible)". Several roles are listed by name.
- **The Actions item** for a directory-role removal already names the role and is unchanged.
- **Other review kinds** are unchanged: groups, mailboxes, lists.

## Notes (technical)
- `core/recert_requests.py`:
  - `loses(item)` returns `item.role`, which for `RecertItemSource.directory_role` rows is the kind ("Active" / "Eligible"). The role's name is the review's subject (`instance.entity_name`). For directory-role rows, return "<role name> (<kind lower>[, through <groups>])".
  - Pass the instance in (callers at `api/v1/access_requests.py:1459` and the Polaris request tools), or store the role name on the row.
  - `privilege_reasons()` builds the same string, so fix both from one helper.
- Rows already in production (ACR-37) come right once the wording is computed at read time; no data fix needed if the name comes from the instance.
- Tests: the recert-request tests pinning "loses".

**Done when:** on staging, a Global Administrator review's removals request reads "loses: Global Administrator (eligible)", and its approval reason names the role.