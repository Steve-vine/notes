---
id: 01M81A2WC8HSWADT9CR943R4AW
created: 2026-11-22T09:41:04.52049Z
updated: 2026-11-23T12:09:18.339984Z
type: task
title: Polaris adds and edits entries — add, update, archive with a reason, restore, link and unlink as the person; on a register's page "this register" is the one on screen
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2091
sprint: ssj8zkq
blocked_by:
- 01M81A2KFVFRYRDEBCDQ2FT208
assignee: steve
label:
- feature
priority: medium
task_status: active
---
Sprint "Registers - Phase 2" (ADR 0167 §3, in COM-2087). Builds on "Polaris reads registers".

## What people see
- Polaris can, where the person may edit entries:
  - add an entry ("add the Data (Use and Access) Act 2025 to the obligations register, owner me, review in March")
  - change an entry's values
  - archive an entry with a reason, and restore one
  - link an entry to a control, gap, risk, SAP entry, document, decision, vendor, inventory asset or another register's entry, and unlink it
- It asks before changing more than five entries at once, listing them.
- It doesn't make, archive or delete registers, change fields, or Mark a register as reviewed. Asked to, it says that's done on screen and gives the link.
- Every change is in the entry's history and the activity log as made by the person, via Polaris.
- **Inside Compass**: the Polaris window on Assurance ▸ Registers, a register's page or an entry's page offers the Registers tools, and knows "this register" or "this entry". Ticked rows on a register's list are "these entries".

## Implementation notes (technical)
- Tools (write): `registers_add_entry`, `registers_update_entry`, `registers_archive_entry`, `registers_restore_entry`, `registers_link_entry`, `registers_unlink_entry`. Values keyed by field name in the tool input, resolved to field ids; unknown field or choice value → a clear error listing the valid ones.
- Polaris window: a `registers` section in `core/polaris/tools.py` `SECTIONS`, register and entry record kinds in `RECORD_SECTIONS`, and the `/registers` routes in `app/frontend/src/polaris/place.ts` `sectionOf`; send `on_screen` with the register or entry and ticked rows.
- Same permission checks as the screen (owner, editors, administrators).

## Done when
- Polaris adds, edits, archives, restores, links and unlinks entries, each showing in history as via Polaris.
- It refuses to change fields or mark a review, with the on-screen link.
- On a register's page, "add an entry to this register" works without naming it.
- Someone who can only view a register can't change it through Polaris.

Independent (no migration, no /api/v1 change beyond the Polaris context schema if needed — then on the chain).