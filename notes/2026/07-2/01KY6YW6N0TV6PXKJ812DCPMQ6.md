---
id: 01KY6YW6N0TV6PXKJ812DCPMQ6
created: 2026-07-23T07:43:39.680122Z
updated: 2026-07-23T11:04:51.845004Z
type: task
title: 'Note font: edit mode differs from read mode (form controls don''t inherit app font)'
task_status: done
number: 68
imported_from: linear
assignee: steve
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
sprint: sr2wq8c
---
A note's title looked different in edit mode vs the rendered read view. Cause: bare `<input>`/`<textarea>` form controls don't inherit `font-family`, so the edit-mode title rendered in the UA default font while the read-mode `h1` used the app font (Inter).

Fix: a global base rule in theme.css makes `button/input/textarea/select` inherit the app font. Explicit per-control fonts (e.g. monospace shortcuts/identifiers) still win on specificity. Also fixes the capture window's title input.

---

Linear DEV-601 · M8 - Styling · created 2026-06-23 · done 2026-06-23