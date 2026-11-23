---
id: 01M81A2A2EEFTA9WNY3N38KG9B
created: 2026-11-22T09:40:45.774401Z
updated: 2026-11-23T10:45:37.197977Z
type: task
title: An import that updates — a spreadsheet row with an entry's ID updates that entry, and the preview shows every change, old value beside new, before anything is saved
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2089
sprint: ssj8zkq
blocked_by:
- 01M81A1ZNSNWH7FM10E1J579E3
assignee: steve
label:
- feature
priority: high
task_status: active
---
Sprint "Registers - Phase 2" (ADR 0167 §2, in COM-2087). Extends the add-only import from COM-2081.

## What people see
- **Import** works as before, and an **ID** column can be matched like any other. A row with an ID updates that entry; a row without one adds a new entry.
- The preview marks each row **Add**, **Update**, **No change** or **Problem**, with counts at the top ("12 to add, 30 to update, 58 unchanged, 2 problems").
- An Update row expands to show each field that changes: the field, its value now, and its value after. Unchanged fields aren't listed.
- **A blank cell leaves the field as it is.** The preview says so once, above the rows. Clearing a value is done on the entry's page.
- Problems, each explained on its row and left out unless fixed:
  - an ID that isn't in this register, or (per-company register) isn't in the company being viewed
  - an archived entry ("Restore OBL-7 first")
  - the same ID on two rows
  - a choice value the field doesn't have: offered as a new value to someone who can change fields, as when adding
  - everything COM-2081 already flags (dates, required fields…)
- Rows are ticked to choose what's applied, as for adding. **Import** applies them.
- Each updated entry's history shows the change as made by the importer, "by import from obligations-2026.xlsx".
- Who: anyone who can edit the register's entries, as before.

## Implementation notes (technical)
- Copy the audit requests import: `core/audits/requests.py` `plan_rows()` (add/update per row) and `apply_rows()`, preview → row preview → commit routes as in `api/v1/audit_requests.py`.
- The per-field diff compares the latest revision's values with the parsed row (blank = absent key, so no change). Return it in the preview response.
- One revision per updated entry, with an import source and the filename; a No change row writes nothing.
- Recheck at commit that each entry hasn't changed since the preview (compare revision ids); a changed one becomes a Problem rather than being overwritten.

## Done when
- An exported register, edited in Excel and re-imported, previews exactly the edited cells as changes and applies them.
- A blank cell doesn't clear a value.
- An unknown ID, an archived entry and a duplicate ID each show as a Problem and aren't applied.
- An entry edited on screen between preview and import isn't overwritten; its row is reported.

On the chain: API.