---
id: 01M4377S1GVA8CZQP3WNHTJPGB
created: 2026-10-04T10:27:00.784825Z
updated: 2026-10-04T12:55:59.747852Z
type: task
title: File Title
project: 01KY6W9951TW0904DT0GGJVGE7
number: 505
sprint: sx287fa
comments:
- id: 01M438GAVZP8SPTW2NJF1CP993
  author: Steve Vine
  at: 2026-10-04T10:49:09.758636Z
  text: |-
    Done on branch brief-504-crosssync-polish (commit b9f7dde; lands in the combined sprint PR).

    - The Add file form has an optional Title field under the path.
    - The title is stored in the entry's synced meta.yaml (new optional `title` key), so it shows on every machine.
    - The list shows it beside the file name, before "added on …".

    Decisions made on the fly:
    - Optional, not required: an untitled file looks as it did before.
    - The task only asks for the field when adding, which would leave the five files already synced with no way to get a title. So there is also a set-title command, and the title is editable in the right-hand properties pane (NOT-507).
    - Titles are kept to one line; a blank title clears it.

    Tested: unit test for add-with-title / change / clear; type-check clean. Not run in the Tauri app.
assignee: steve
priority: medium
task_status: done
tech: null
---
When adding a new file into CrossSync add a title field so the user can describe what the file is. This should also be included in the list to identify one .config file with another.