---
id: 01M7ZM1CC2CVHSYSATCNHSV245
created: 2026-11-21T17:56:32.258758Z
updated: 2026-11-21T17:56:32.258758Z
type: task
title: Import a register from a spreadsheet — match each column to a field, preview every row with its problems, and bring the good rows in as entries
task_status: todo
label: feature
assignee: steve
priority: high
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2081
---
Sprint "Registers" (ADR in COM-2076). Builds on COM-2078. This is how Steve's current legal register spreadsheet gets into Compass.

## What people see

**Import** on a register's Entries tab, for its owner, editors and administrators:

1. **Choose a file:** CSV or Excel (.xlsx). For an Excel file with several sheets, pick the sheet. The first row is taken as column headings.
2. **Match columns to fields.**
   - Each column is matched to a field by name where they agree, and the rest are chosen from a list or left as **Don't import**.
   - Someone who can change the register's fields also sees **New field from this column**, which suggests a type from the values.
   - The Title field must be matched.
3. **Preview** shows every row as it would be added, with problems marked on the row:
   - a required value missing
   - a date it can't read (it says what it read, e.g. "31/02/2025")
   - a number that isn't one
   - a choice value that isn't in the list. **Add these values to the list** fixes them all at once, for someone who can change fields.
   - a person it can't find (matched by name or email)
   - a company it can't find
   - a title that's already an entry in this register, marked **Possible duplicate**

   Rows with problems can be left out or fixed in the preview.
4. **Import N entries** adds the good rows. Each gets the next ID, and its history says "Imported from legal-register.xlsx by Steve Vine". A summary says how many were added and how many were left out, and why.

**In a per-company register** the entries go into the current company. **In a shared register** they're shared, and a Company column can fill the Company field.

**This first version only adds entries.** It doesn't update existing ones; updating by ID is planned for the second sprint (ADR in COM-2076).

## Implementation notes (technical)

- Parse in the API (openpyxl for .xlsx; the csv module with encoding detection for UTF-8 with or without BOM, and Windows-1252).
- Two calls: preview (stateless; returns the matched rows and problems) and commit (re-validates; writes in one transaction).
- Dates: try ISO, then UK day-first, then Excel serial numbers. Never guess US month-first; flag it instead.
- Cap at 5,000 rows and 5 MB. Check the file's real type by its bytes, as uploads already do.
- Commit writes an entry revision per entry (COM-2078), marked as imported.

## Done when
- A CSV or Excel file can be imported with columns matched to fields, including making a new field from a column and adding missing choice values.
- The preview shows each row's problems, and only the rows chosen are added, each with an ID and "Imported from …" in its history.
- Dates in ISO, day-first UK and Excel serial form are read. Anything ambiguous is flagged, not guessed.

On the chain: API.