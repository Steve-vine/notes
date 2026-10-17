---
id: 01M52FR3FCHV0KR7CN5X51XM7M
created: 2026-10-16T13:52:11.756543Z
updated: 2026-10-17T07:52:34.702038Z
type: task
title: The assistant can read and change Software assets — licensing, support, where each is deployed, and the database engines discovery found that aren't in the register yet
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1026
sprint: sfzoxya
blocked_by:
- 01M52FQBGZ8WV65TRK7VZPWZ63
comments:
- id: 01M53NVWGHTV56CGQ72PMJA5EP
  author: Steve Vine
  at: 2026-10-17T00:58:21.585094Z
  text: |-
    Done — merged to main (PR #1024). Goes to staging with the rest of sprints 73 and 74.

    What the assistant can now do, for a named company:
    - List the Software register, filtered by support state or "support ends within N months", type, deployed or not, licences over-allocated or unused, or name. Each row: SFT reference, support and when it ends, licences used of those held.
    - Read a software entry in full: owners, licensing (model, held, used, annual cost), support dates, the technology assets it's deployed on (and whether discovery found it there), review dates.
    - Add, edit, confirm accurate, and delete (asks first) entries.
    - Suggestions: list the database engines discovery found that aren't in the register; add one as a new entry (engine, version and support dates filled in from the suggestion); match one to an existing entry — "PostgreSQL 15 is our PostgreSQL entry"; or dismiss one for good (asks first).
    Tested against the fake AWS account the discovery tests use: matching shows the entry deployed on AST-1 "found by discovery", and the suggestion leaves the list. Changes show in Activity via assistant.

    My calls: "support ends within N months" uses the date that matters next — the mainstream end while still in mainstream support, otherwise the extended end — and includes anything already out of support. "Unused licences" means more held than used.
assignee: steve
label:
- feature
priority: medium
task_status: done
---
Sprint 74, MCP - Inventory (ADR in COM-1023). Built on COM-1024.

## What people can ask of it

- **Read (for a named company):**
  - **the register**, filtered as on the tab: support, type, deployment, and licences over-allocated or unused.
  - **a software asset in full:**
    - its record and owners;
    - licensing: model, licences used and total, annual cost;
    - support dates;
    - the technology assets it's deployed on;
    - when it was last confirmed accurate, and when it's next due for review.
  - **the suggestions:** database engines discovery found that aren't in the register yet.
- **Write (whatever the person's role allows on screen):**
  - add, edit or delete a software asset;
  - **confirm it accurate**;
  - for a suggestion:
    - **add** it as a new entry;
    - **match** it to an existing entry;
    - **dismiss** it for good.
- **Example:** "What software is out of support or within six months of it, and where is it deployed?" Then: "PostgreSQL 13 is our existing 'PostgreSQL' entry — match it."

## Notes (technical)

- Wraps `software_assets.py`: list, get, POST, PATCH, DELETE, confirm-accurate, suggestions, and suggestions/dismiss. Match is a PATCH that sets `discovery_key`. Give it its own tool (`inventory_match_software_suggestion`), so the assistant doesn't have to know that.
- Dismiss and delete are `destructive`.
- Deployed-on comes from the technology assets' installed software (COM-1024). Read it from what the detail route returns, not by walking every asset.
- New module `tools/inventory_software.py`, reusing `find_asset`.
- Tests: writes are hidden without manage-register; match sets the key, and the suggestion leaves the list; an edit is recorded via assistant.

**Done when:** on staging, the assistant matches a suggestion to an existing entry, and the suggestion is gone from the Software assets tab.