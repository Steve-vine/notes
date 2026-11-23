---
id: 01M81A2A2EEFTA9WNY3N38KG9B
created: 2026-11-22T09:40:45.774401Z
updated: 2026-11-23T19:36:29.383206Z
type: task
title: An import that updates — a spreadsheet row with an entry's ID updates that entry, and the preview shows every change, old value beside new, before anything is saved
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2089
sprint: ssj8zkq
blocked_by:
- 01M81A1ZNSNWH7FM10E1J579E3
comments:
- id: 01M8440WEAG3WMM1GB0R2WN517
  author: Steve Vine
  at: 2026-11-23T11:52:50.890286Z
  text: |-
    Built and merged to main: PR #2092 (70bf44371). No migration.

    What people see:
    - Import matches an ID column. A row with an ID updates that entry; a row without one adds a new entry.
    - The preview marks each row Add, Update, No change or Problem, with counts at the top.
    - An Update row opens to show each changed field, its value now and after.
    - The preview says once that a blank cell leaves the field as it is.
    - Problems can be fixed on the row, including the ID.
    - If an entry changed after the preview, it isn't overwritten: the result names its row and offers Preview again.
    - History shows the importer and "By import from <file>".

    Worth Steve's attention:
    1. Importing into the wrong company. A per-company register reuses IDs across companies, so OBL-7 is a different entry in each. An Excel export from another company is a Problem on every ID row. A CSV doesn't say which company it came from, so this can't be caught: its rows would match the same-numbered entries here, and only the preview's changes would show it.
    2. If a company is renamed between export and import, its own Excel file is wrongly flagged as another company's.

    Other decisions made while building:
    - An ID column is matched automatically only if it holds at least one of this register's IDs, so someone's own numbering still imports as new entries.
    - A sheet with IDs doesn't need a Title column.
    - Any change to an entry after the preview counts as changed, including a link or evidence being added.
    - Renaming an entry to another entry's title is a possible duplicate, left out unless ticked.
    - Numbers are compared to 15 significant digits, as Excel holds them.

    Tested against real Postgres, on a register with every field type: an export read straight back changes nothing; Excel and CSV round trips show exactly the edited cells; a blank never clears a value; unknown, archived, duplicate and other-company IDs are Problems and aren't applied; an entry changed after the preview isn't overwritten; a No change row writes nothing. CI green.

    Not checked: a file actually re-saved by desktop Excel (edits were made programmatically; a CSV saved by US-locale Excel could show a day-first date misread as a change in the preview), and the Activity log wording when an import changes a title.

    Not yet checked in a browser on staging: that comes with the sprint's pre-UAT pass.
- id: 01M84ENAXN2TWNT95S18TWSBYQ
  author: Steve Vine
  at: 2026-11-23T14:58:46.836931Z
  text: |-
    Pre-UAT on staging e2248892e: PASSED, with one caveat on Excel itself.

    Account: E2E Admin A, E2E Test Company. Register E2E UAT 122 Import (UIM), with every kind of field.

    - An exported register, edited and re-imported, previews exactly the edited cells and applies them: PASSED, on a file edited by script. I exported All columns to Excel, changed cells with a spreadsheet library and imported it. The preview read "1 to add, 3 to update, 1 unchanged, 4 problems". UIM-1 showed Status Met → Not met and Score 10 → 15; UIM-2 showed Due 15 Feb → 20 Feb; UIM-3, untouched, showed No change and got no new History line. History reads "By import from uat-import-edited.xlsx". COULDN'T CHECK a file actually saved by desktop Excel: please try one.
    - A blank cell doesn't clear a value: PASSED. UIM-2's Notes was blanked in the file and kept "Original note 2". The preview says once that a blank leaves the field as it is.
    - Unknown ID, archived entry and duplicate ID are Problems and aren't applied: PASSED. "UIM-99 isn't in this register for the company you're viewing", "Restore UIM-6 first: it's archived", "UIM-5 is on more than one row (rows 6 and 10)". None changed.
    - An entry edited on screen between preview and import isn't overwritten and is reported: PASSED. I changed UIM-4's Score to 44 in a second tab after the preview. The result said "1 row changed on screen since the preview, so not overwritten (row 5: UIM-4)" and it stayed 44. Preview again then showed 44 → 99.

    Screenshots: ~/compass-uat/sprint-122/COM-2089/
assignee: steve
label:
- feature
priority: high
task_status: done
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