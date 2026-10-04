---
id: 01M437AK96JVR8H46P01CAGEHZ
created: 2026-10-04T10:28:33.19032Z
updated: 2026-10-04T10:57:22.139565Z
type: task
title: Exit edit mode
project: 01KY6W9951TW0904DT0GGJVGE7
number: 506
sprint: sx287fa
comments:
- id: 01M438ZBFJBKGY8A46YD6QRWRJ
  author: Steve Vine
  at: 2026-10-04T10:57:21.905493Z
  text: |-
    Done on branch brief-504-crosssync-polish (lands in the combined sprint PR).

    - The "< CrossSync" link is removed from the file editor's bar.
    - Esc closes the editor and returns to the list, flushing unsaved edits exactly as the link did (and still not writing when an on-disk change is waiting for a Reload / Keep mine answer).
    - It works whether or not the cursor is in the text — a read-only vault copy never takes focus, and Esc still closes it.

    Decisions made on the fly:
    - Esc goes to something else first when that thing is open: the find panel closes on the first Esc and the editor on the next; with text selected, the first Esc collapses the selection (CodeMirror's own behaviour).
    - Esc pressed in a field outside the editor (the sidebar filter, the Title field in the properties pane) does not close the editor.
    - With the link gone there was nothing on screen saying how to leave, so the bar carries a quiet "Esc to close" hint at the right. Easy to drop if you would rather not have it.

    Tested: rendered the real editor in headless Chrome on a mocked backend — Esc from inside the text closes it, Esc on a read-only copy closes it, and the row stays selected afterwards. Not run in the Tauri app.
assignee: steve
priority: medium
task_status: review
tech: null
---
At the moment there is a '< CrossSync' link to exit edit mode, this doesn't fit in with the rest of the platform. Remove this link and just use the escape key to exit from edit mode.