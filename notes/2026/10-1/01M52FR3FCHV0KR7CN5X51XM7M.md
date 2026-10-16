---
id: 01M52FR3FCHV0KR7CN5X51XM7M
created: 2026-10-16T13:52:11.756543Z
updated: 2026-10-16T13:54:02.987378Z
type: task
title: The assistant can read and change Software assets — licensing, support, where each is deployed, and the database engines discovery found that aren't in the register yet
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1026
sprint: sfzoxya
blocked_by:
- 01M52FQBGZ8WV65TRK7VZPWZ63
assignee: steve
label:
- feature
priority: medium
task_status: todo
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