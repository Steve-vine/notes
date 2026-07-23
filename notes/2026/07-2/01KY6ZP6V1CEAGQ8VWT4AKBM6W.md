---
id: 01KY6ZP6V1CEAGQ8VWT4AKBM6W
created: 2026-07-23T07:57:51.841068Z
updated: 2026-07-23T07:57:51.841068Z
type: task
title: 'Hybrid editor: Insert menu'
imported_from: linear
assignee: steve
label: brief
task_status: done
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 108
---
An **Insert** menu in the editor toolbar that inserts markdown constructs at the cursor, driving Brief 1's `Editor.insertAtCursor` (CM6 transactions).

## Items (from the M13 brief, + suggestions)

- [ ] **Table** (Obsidian-style starter grid, e.g. 2×2 with header row)
- [ ] **Link** (`[text](url)`; prompt for url, wrap selection as text if present)
- [ ] **Footnote** (`[^1]` ref + definition stub)
- [ ] **Callout** (`> [!note]` block)
- [ ] **Horizontal rule** (`---`)
- [ ] **Code block** (fenced, optional language — reuse `parseFence` info-string conventions, DEV-602)
- [ ] Suggested extras: **Task list item** (`- [ ] `), **Date** (today), **Image/attachment** (route to existing attach picker)

DoD: each item inserts valid markdown at the cursor (or wraps the selection where it makes sense); renders correctly in Read + Live; menu reachable in both Live and Source.

---

Linear DEV-689 · M13 - Hybrid Edit Mode · created 2026-06-27 · done 2026-06-28