---
id: 01M52FQBGZ8WV65TRK7VZPWZ63
created: 2026-10-16T13:51:47.231049Z
updated: 2026-10-16T13:54:00.941195Z
type: task
title: The assistant can read and change Technology assets — the register, each asset in full, its lifecycle and the software installed on it
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1024
sprint: sfzoxya
blocked_by:
- 01M52FPZCECZPJEEHSF1M28PAM
assignee: steve
label:
- feature
priority: high
task_status: todo
---
Sprint 74, MCP - Inventory (ADR in COM-1023). **Do this one first.** Every other Inventory task finds assets through the lookup it adds.

## What people can ask of it

- **Read (for a named company):**
  - **the register**, filtered as on the tab: environment, kind, status, support, discovered or hand-entered, and findings to answer.
  - **an asset in full**, as its page shows it:
    - its record, owners, criticality and derived classification;
    - hosting and dependencies;
    - the data assets it holds;
    - the discovered resources attached to it;
    - its open findings;
    - its installed software;
    - when it was last confirmed accurate, and when it's next due for review.
  - **the Inventory summary** the dashboard tile shows.
- **Write (whatever the person's role allows on screen):**
  - add a technology asset;
  - edit one: its record, owners, dependencies and supplier;
  - mark it live, offline or deprecated;
  - decommission it;
  - delete it. As on screen, this is refused if anything else cites the asset.
  - **confirm it accurate**, which is the review evidence;
  - add, edit or remove installed software, including the licences used.
- **Search:** the assistant's existing search also finds technology, data and software assets.
- **Example:** "Which production technology assets haven't been confirmed accurate in a year, and who owns them?" Then: "mark AST-14 deprecated."

## Notes (technical)

- Wraps `containers.py`:
  - record: list, get, POST, PATCH, DELETE and confirm-accurate;
  - installed software: POST, PATCH, DELETE.

  Also wraps `GET /inventory/summary`, and `GET /inventory/people` for owner choices.
- **Shared lookup in `tools/common.py`: `find_asset(kind, ref_or_words)`** covers all three registers: the ref (AST-n and the data and software prefixes), then the id, then words. It refuses with candidates rather than guessing. Add `find_software` for the installed-software picker. Owners resolve through `/inventory/people`, which is not the people list `resolve_person` uses, so add a variant.
- Delete and decommission are `destructive`. Decommission is terminal.
- Add the asset types back to `_SEARCH_TYPES` in `session.py`. Add the Inventory paragraph and the untrusted-text line to INSTRUCTIONS.
- New module `tools/inventory_technology.py`.
- Tests:
  - ref resolution;
  - writes are hidden without manage-register;
  - a cited asset's delete is refused readably;
  - an edit is recorded via assistant.

**Done when:** on staging, the assistant adds a technology asset with an owner and a dependency, and its page shows the record and an Activity line via assistant.