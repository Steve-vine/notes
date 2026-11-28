---
id: 01M8GKE48KB4GHJ8JA5P71EX0Y
created: 2026-11-28T08:13:06.707145Z
updated: 2026-11-28T10:54:00.386894Z
type: task
title: The script editor shows no cursor while you type
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2223
sprint: s09wwd3
assignee: steve
label:
- bug
priority: medium
task_status: active
---
**Independent** (frontend only). Found by Steve testing the Scripting sprint on staging 89c46a222, 28 Nov 2026.

## What people see
- Editing a script (Automation ▸ Scripts ▸ New script, or Edit draft), there's **no visible cursor** in the SQL box, so you can't see where typing goes.
- It should show a cursor in the page's text colour, in light and dark colour schemes alike, as every other text box does. A selection should show too.

## Notes (technical)
- `app/frontend/src/scripts/SqlEditor.tsx` builds the CodeMirror editor without `drawSelection()` and sets no caret colour. CodeMirror's base theme gives the native caret a fixed dark colour (`caret-color: black`), which disappears on Compass's dark scheme.
- Fix: add `drawSelection()`, and set `.cm-content { caretColor }` plus `.cm-cursor, .cm-dropCursor { borderLeftColor }` to `var(--mantine-color-text)`; also a visible `.cm-selectionBackground` in both schemes. No fixed colour, per the adaptive-colours rule.

**Done when:** on staging, in both colour schemes, the script editor shows a blinking cursor where you type and a visible selection.