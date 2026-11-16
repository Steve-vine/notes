---
id: 01M7J4MD8YR5PR37XAK11EB6AH
created: 2026-11-16T12:17:10.942671Z
updated: 2026-11-16T23:03:23.181545Z
type: task
title: 'Workflows and Evidence Collection lists: the ID is its own column, sortable apart from the name, and the lists open sorted by ID, lowest first'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1871
sprint: s7nqsy0
comments:
- id: 01M7JC3S62A4XYKDB1XGC85T0J
  author: Steve Vine
  at: 2026-11-16T14:27:54.690536Z
  text: |-
    Done — PR #1865, merged to main (52768fd3). Not on staging yet.

    - Evidence Collection ▸ All checks has an ID column (CHK-n) and a separate Check column (the name, still linked), each sortable on its own.
    - Automation ▸ Workflows has an ID column (WF-n) and a Workflow column, each sortable.
    - Settings, the other Evidence Collection table that names checks, splits ID and Check the same way, and stays unsorted as before. Review already had its own ID column.
    - IDs sort by number, so CHK-9 comes before CHK-10, and rows without an ID come last.
    - Both lists open sorted by ID, lowest first. A sort you pick stays in the address as before.

    To check on staging: open All checks and Workflows. Both should open in ID order; then sort by name and back.
- id: 01M7JECSZ7FT8172X0VQS30M7H
  author: Steve Vine
  at: 2026-11-16T15:07:47.559204Z
  text: |-
    **Pre-UAT: Passed** (staging 43d03f09, E2E Test Company, E2E Admin A)

    Steps and what I saw:
    - **All checks** opens sorted by ID, lowest first, with the ID column marked as the active sort. ID and Check are separate columns, and the check name is still a link. The order runs CHK-2, 4, 5 … 9, 10 … 15, so it sorts by number (CHK-9 before CHK-10).
      - Click ID: descending, CHK-15 … CHK-2 (?sort=-ref).
      - Click Check: by name A–Z, then Z–A (?sort=check / -check).
      - Click ID again: back to ascending.
    - **Workflows** opens sorted by ID, lowest first (WF-1 … WF-6), with separate ID and Workflow columns.
      - ID descending: WF-6 … WF-1.
      - Workflow A–Z, then Z–A: correct.
      - The sort stays in the address.
    - **Settings** has separate ID and Check columns (CHK-4 … CHK-15), unsorted as before. Review has its own ID column.

    Not covered:
    - E2E has no WF number above 9 (WF-7 and WF-8 were added today), so number order for WF IDs was only proved on CHK.
    - No unnumbered row was present, so I couldn't see one sort last.

    Screenshots: ~/compass-uat/s7nqsy0/COM-1871/ (all-checks-default-id-asc.png, workflows-default-id-asc.png, settings-tab.png)
assignee: steve
label:
- improvement
priority: medium
task_status: done
---
Asked for by Steve while testing sprint "Automation - Workflows" on staging (2026-11-16).

## Today

- **Automation ▸ Evidence Collection ▸ All checks**: the check's ID (CHK-n) and its name share one "Check" column, sorted by name. There's no way to sort by ID.
- **Automation ▸ Workflows**: one "Workflow" column with the name. Workflows have no ID yet (COM-1869 adds WF-n).

## Done when

- **All checks** has an **ID** column (CHK-n) and a separate **Check** column (the name), each sortable on its own.
- **Workflows** has an **ID** column (WF-n) and a separate **Workflow** column (the name), each sortable on its own.
- Any other table on Evidence Collection that lists checks by ID (e.g. Review, if it shows CHK IDs) gets the same split.
- **IDs sort by number,** so CHK-9 comes before CHK-10. A row without an ID (e.g. a proposal not yet numbered) sorts last.
- **Both lists open sorted by ID, lowest first.** A sort the person picks still stays in the address, as today, and the ID column shows it's the active sort.
- The screen-conventions test still passes: both new columns are SortableTh.
- Tests cover: the split columns; numeric ID order in both directions; the default sort by ID ascending.

Follows COM-1869 (workflow IDs). Independent of the chain otherwise: frontend only, once WF-n is in the API.