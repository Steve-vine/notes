---
id: 01M437W9XGTY8RJ3P03TVGSMKF
created: 2026-10-04T10:38:13.42501Z
updated: 2026-10-04T10:52:58.212493Z
type: task
title: Left pane
project: 01KY6W9951TW0904DT0GGJVGE7
number: 509
sprint: sx287fa
comments:
- id: 01M438Q9TFW3SBYH02S7FG7VAY
  author: Steve Vine
  at: 2026-10-04T10:52:58.06332Z
  text: |-
    Done on branch brief-504-crosssync-polish (commit 7 of the sprint branch: "filter the CrossSync list from the sidebar"; lands in the combined sprint PR).

    I read "right hand pane" in the task as the left-hand one — the CrossSync section with the three paragraphs of text.

    - The explanatory text is gone from the CrossSync section.
    - In its place: a filter box ("Filter by name or title…") and a dropdown of the computers files were added on — "All computers", then each name, with "(This PC)" against the one you are on (listed first).
    - Both narrow the list in the main panel and combine. The header count reads "2 of 6" while a filter is on, and if nothing matches the list says so with a Clear filter button.

    Decisions made on the fly:
    - The text filter is the same literal, case-insensitive match the other sidebar filters use (DEV-943), not fuzzy.
    - The dropdown lists only computers that have added a file. If the picked computer's last file is removed, the filter resets to All computers.
    - Filters stay set while the app is open (switching tabs and back keeps them); they are not saved across a restart.
    - "This PC" is decided by install id (NOT-508), so it is right even for a file recorded under the wrong name.
    - The empty-state text shown before any file is added still explains what CrossSync does; only the sidebar text was removed.

    Tested: unit tests for the filter and the machine list; type-check clean. Not run in the Tauri app.
assignee: steve
priority: medium
task_status: review
tech: null
---
Remove the text fro the CrossLink section from the right hand pane and replace it with:
Search filter box to filter on filename or title
Dropdown list to filter on the 'added on' computer name, including a '(This PC)' note against the computer the user is currently on