---
id: 01M7ZM01R4WXTDT5YZ3SBHSXF7
created: 2026-11-21T17:55:48.612932Z
updated: 2026-11-22T10:24:36.363242Z
type: task
title: Entries — add, edit and archive a register's entries, each with its own ID (OBL-4) and full change history, in a sortable, filterable list
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2078
sprint: s64t54m
blocked_by:
- 01M7ZKZFECD5CZKNMCJ88YT8ZS
comments:
- id: 01M81CJGFGH1FEPD09ZXFB9ZBS
  author: Steve Vine
  at: 2026-11-22T10:24:33.775973Z
  text: |-
    Done — merged in PR #2073 (32b55b78), migration 0891_register_entries.

    What changed for people:
    - A register opens on its Entries tab: a column for each field the person picks with Columns (remembered for them), every column sortable, a filter for each Choice, Multiple choice, Person, Company and Yes/No field, a search across text and IDs, and Incomplete and Archived filters, all kept in the address.
    - Each entry gets an ID from the register's prefix (OBL-4): across Compass for a shared register, within each company for a per-company one. Numbers are never reused. Compass's search box finds an entry by ID or title, in registers the person can see.
    - A per-company register shows the current company's entries. A shared register with a Company field offers "Only entries for <company>".
    - Add entry and Edit show the fields in order with their hints. Required fields are checked. An edit can't empty a required value the entry had, and an entry already incomplete can still be saved and shows Incomplete.
    - Each entry has its own page with its fields, Links and Evidence sections (filled in by COM-2079 and COM-2080), and a History tab: who, when, field, before → after, plus added, archived (with the reason) and restored. Renamed fields show their current name, and removed ones are marked "(field removed)".
    - Archive needs a reason and Restore undoes it. Entries are never deleted. Only the owner, editors and administrators change entries; everyone else who can see the register reads it.
    - Browser smoke opens a register and an entry on every tab. A new journey adds, edits, reads the history of and archives an entry in an "E2E browser tests register".

    My calls (yours to overturn):
    1. The Archived filter shows archived entries instead of current ones, as the Registers list does.
    2. Default columns: Title plus the first three other fields, skipping Long text.
    3. The Person filter offers every Compass user.
    4. Polaris's search can find register entries by ID or title. A test requires every search-box result type to be in Polaris's search. It can only find them, not change them; the rest of Polaris is ADR 0167.
    5. Adding, archiving and restoring an entry also write an activity-log line. Edits write one line, with the field-by-field detail in the entry's History.
    6. A per-company entry opened by its link from another company still reads, and says which company it belongs to (as with other records: Compass doesn't limit which companies a person sees).
    7. Changing a Choice field to Multiple choice turns each entry's single value into a one-item list, without a History line.
assignee: steve
label:
- feature
priority: high
task_status: review
---
Sprint "Registers" (ADR in COM-2076). Builds on COM-2077.

## What people see

**A register's page**
- Header: the register's name, description, owner and Shared or Per company.
- Tabs: **Entries** (opens first) and **Settings** (COM-2077's details and fields). History of the register itself is in the activity log.

**The Entries list**
- A table with a column for each field. The Title and the first few fields show by default, and **Columns** chooses which show. That choice is remembered for the person.
- Every column sorts. There's a filter for each Choice, Multiple choice, Person, Company and Yes/No field, a search box across the text fields, and an **Archived** filter (archived entries are hidden by default). Filters live in the address, so a filtered list can be shared.
- An entry missing a required value shows an **Incomplete** marker, and there's a filter for those.
- **Per-company register:** the list shows the current company's entries. Switching company shows that company's list.
- **Shared register:** every entry shows. If the register has a Company field, **Only entries for <current company>** narrows the list to those that apply.

**Entry IDs**
- Every entry gets an ID from the register's prefix: OBL-1, OBL-2…
- A shared register numbers its entries across Compass. A per-company register numbers them within each company, as CHC-n is (ADR 0157).
- Numbers are never reused, even after archiving.
- The ID shows everywhere the entry does, and Compass's search box finds an entry by its ID or title.

**Adding and editing**
- **Add entry** opens a window with the register's fields in order. Each field's hint shows under it, and required fields must be filled before saving.
- In a per-company register the entry belongs to the current company.
- Opening an entry shows its own page: its fields, then Links and Evidence (empty until COM-2079 and COM-2080), and a **History** tab.
- **Edit** changes any field. On save, required fields are checked again. An entry that was already incomplete can be saved while still incomplete, but it can't lose a required value it had.

**History**
- Every change is listed: who, when, which field, and before → after. Creating the entry, archiving it and restoring it are listed too.
- A field renamed since shows under its current name. A removed field's changes stay, marked "(field removed)".

**Archiving**
- **Archive** asks for a reason (for example, "Repealed by the Data (Use and Access) Act 2025"). The entry becomes read-only, keeps its ID and history, and is hidden unless the Archived filter is on.
- **Restore** brings it back.
- Entries are never deleted.

**Who can do what**
- The register's owner, its editors and administrators add, edit, archive and restore entries.
- Anyone else who can see the register reads it, and sees no Add entry or Edit.

## Implementation notes (technical)

- One table for entries, with values in JSONB keyed by field ID. Values are validated on every write against the field definitions: type, required, choice value IDs, people and companies that exist.
- An entry-revision table keeps the **full** values after each change, plus who and when. History is worked out by comparing revisions. COM-2082's "as it stood on a date" reads the latest revision at or before that date, so write a revision for create, edit, archive and restore alike.
- Per-company numbering follows the CHC-n pattern (a counter per register and company). Shared numbering uses a counter per register.
- Sorting and filtering on JSONB values: index what the list needs (GIN on values), and sort by the field's typed value (dates as dates, numbers as numbers).
- Add the entry and its ID to the global search index.
- Add the register page and an entry page to the Browser smoke.

## Done when
- Entries can be added, edited, archived (with a reason) and restored by the owner, editors and administrators, and are read-only to everyone else.
- Each entry has an ID from the register's prefix, numbered across Compass or per company as the register says, and search finds it by ID.
- The list sorts by any column, filters by choice, person, company and yes/no fields, searches text, and hides archived entries by default.
- An entry's History shows every change with who, when and before → after, including changes to fields renamed or removed since.
- A per-company register shows each company only its own entries. A shared register can be narrowed to the entries for the current company.

On the chain: migration and API.