---
id: 01M7CRN6ERWG4KJGGQQN7SYN3F
created: 2026-11-14T10:11:41.656884Z
updated: 2026-11-14T12:20:28.24565Z
type: task
title: '"Change the fields it keeps" on a live check shows the last capture as a table, so you can see what each field holds while you tick it'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1819
sprint: spsp226
comments:
- id: 01M7D00VE9QNXTBJWETY2KHN4D
  author: Steve Vine
  at: 2026-11-14T12:20:23.62516Z
  text: |-
    Built — PR #1816 (9d995989), stacked on COM-1820's #1815; retargeted to main once that lands. Frontend only, no API change.

    Change of approach (my call): Compass never stores what a field held once a check stops keeping it, so a table of "the last capture" could only show data for fields already ticked — the unticked ones, the ones you need to see, would be empty. Instead it takes a fresh sample when the view opens. Say if you'd rather have "last capture" and store those values (that needs a migration and is a privacy question).

    What you now see:
    - ⋯ ▸ Change the fields it keeps opens Details if needed, scrolls into view and puts the cursor in the search box.
    - It reads the service with the check's own reads (as Edit the reads' Try it does) and shows the first 10 rows per account as a table, labelled "A sample taken now with the check's own reads… It's only shown, never kept."
    - Every field is a column with a tick on its header; kept fields ticked and highlighted, the rest greyed. Above: "Fields it keeps · n of N ticked", a "Find a field" search that narrows the columns, All / None.
    - A kept field the sample doesn't hold shows below, greyed, "name (not in this sample)", so it can be unticked.
    - If the service can't be read, it says why and shows the last capture instead (kept columns with data, other fields as names only); with no capture, the plain list of names.
    - Keep these fields saves from the next capture; Cancel and "captures already filed stay as they are" unchanged.

    Choices: no "Polaris's choice" button (a live check doesn't carry Polaris's choice, only the fields it keeps); fields the check leaves out as sensitive are never shown or offered; every opening takes a new sample (reads the service each time).

    Tests: collection/checks/control/screen-conventions vitest pass twice (118); eslint/tsc/prettier clean.

    For Steve on staging: open Change the fields it keeps on a check whose service connects; then on one whose account is failing, to see the last-capture fallback.
assignee: steve
label:
- bug
priority: medium
task_status: review
---
## What happened

On 2026-11-14 Steve chose **Change the fields it keeps** from a collected check's ⋯ menu on a control's Evidence tab. He got a list of field names with tick boxes (`FieldPicker` in `collection/SampleReview.tsx`, inside `EditFields` in `CollectionCard.tsx`), with no data. For fields like `custom_fields.closure_code` you can't tell what you're keeping or dropping. When a check is reviewed, the same choice is made on the sample table, with a tick on each column. That's what he expected here.

It also opens at the bottom of Details, below the captures, so it's easy to miss (the same weakness as COM-1818).

## What people see

1. **Change the fields it keeps** opens the check's last capture as a table: every field the service returned as a column, a tick on each column header, the kept ones ticked, and the first rows of data. It's the same table as on the review page (COM-1813).
2. **Above the table**, the controls the list has today stay: "n of N ticked", **All**, **None**, and **Polaris's choice** where there is one. New: a search box that narrows the columns by name, for services that return dozens of fields.
3. **Fields the last capture didn't hold** (the service stopped sending them) still appear, greyed out with "not in the last capture", so they can be unticked.
4. **The view has room.** It opens wide enough for the table (on the check's page from COM-1817, or full width), not squeezed into the bottom of Details, and the cursor lands on it.
5. **Keep these fields** saves the choice. "The change applies from the next capture; captures already filed stay as they are" stays, as does Cancel.
6. If the check has never captured anything, it says so and falls back to the list of names.
7. Display names from COM-1814, once built, show in the headers here too.

## Done when

- On a live check with a capture, Change the fields it keeps shows a table of that capture with a tick per column, and saving keeps the ticked fields from the next capture.
- All, None, Polaris's choice and the new search work on the table.
- Fields missing from the last capture show greyed out.
- It's fully on screen when opened.
- Vitest is updated for EditFields (table, ticks, search, missing field, no-capture fallback).

**Independent** (front end only), unless the last capture's rows aren't already available to the screen. If so, it joins the end of the chain.