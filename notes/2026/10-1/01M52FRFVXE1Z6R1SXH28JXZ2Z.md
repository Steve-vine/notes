---
id: 01M52FRFVXE1Z6R1SXH28JXZ2Z
created: 2026-10-16T13:52:24.445542Z
updated: 2026-10-17T00:58:21.796529Z
type: task
title: The assistant can read and record who has access to an asset — the groups, people and local accounts on each technology and data asset, and the role each gives
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1027
sprint: sfzoxya
blocked_by:
- 01M52FQBGZ8WV65TRK7VZPWZ63
- 01M52FQSCS4ZH4WYQ1J8W56770
assignee: steve
label:
- feature
priority: medium
task_status: active
---
Sprint 74, MCP - Inventory (ADR in COM-1023). Built on COM-1024 and COM-1025.

## What people can ask of it

- **Read:**
  - the **Access** section of a technology or data asset: each entry (a directory group, a person, or a local account), the role it gives, and its description;
  - **who actually holds that access**, with group members expanded, as the holders list shows;
  - the assets a named person can reach. This is what Access Control's user window shows.
- **Write (whatever the person's role allows on screen):**
  - add, edit or remove an access entry;
  - **confirm a removal** that had to be done by hand. As on screen, that needs Inventory admin.
- **Not here:** recording an entry doesn't grant anything. Compass describes the access an asset gives; it doesn't change it.
- **Example:** "Who can get into the Finance database (AST-7), and through which group?" Then: "add the DBA-Admins group as Administrator."

## Notes (technical)

- Wraps `containers.py` and `data_assets.py`:
  - `holders` and `access` (`inventory.view`);
  - `access` POST, PATCH and DELETE (`inventory.manage_access`);
  - `confirm-removed` (`inventory.admin`).

  Also wraps `GET /directory/users/{id}/assets` (`inventory.view`).
- Groups and people resolve through `find_group` and `find_account` from sprint 72's COM-1013, if that's on main. Otherwise add them here, the same way, and COM-1013 reuses them.
- One set of tools takes `asset` and works out the register from the ref, rather than separate technology and data tools.
- Remove is `destructive`.
- New module `tools/inventory_access.py`.
- Tests: writes are hidden without manage-access; confirm-removed is hidden without admin; an entry added is recorded via assistant.

**Done when:** on staging, the assistant adds a group entry to an asset, and the holders list shows the group's members.