---
id: 01M8GKK8MX8TSKVP0R9DRJ82S3
created: 2026-11-28T08:15:55.037388Z
updated: 2026-11-28T10:54:01.033715Z
type: task
title: 'The script editor is hard to read in dark mode: its text colours are light mode''s'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2224
sprint: s09wwd3
assignee: steve
label:
- bug
priority: medium
task_status: active
---
**Independent** (frontend only). Found by Steve testing the Scripting sprint on staging 89c46a222, 28 Nov 2026. Same editor as COM-2223 (no visible cursor); build them together.

## What people see
- In **dark mode**, the SQL in a script (writing it, the draft and published versions, and Preview's text) is too hard to read. Keywords, names, strings and numbers are drawn in colours meant for a light background. **Light mode is fine.**
- In both schemes, the script should read as clearly as the rest of the page: plain text in the page's text colour, keywords, strings, numbers and comments each distinct, and all of it readable against the box's background. That includes the line numbers and the placeholder ("-- Name inputs as @SignInName…").
- The editor follows the colour scheme as it's switched, without reloading the page.

## Notes (technical)
- `app/frontend/src/scripts/SqlEditor.tsx` uses `syntaxHighlighting(defaultHighlightStyle)` from @codemirror/language, which has fixed colours chosen for a light background, and the editor never knows the scheme.
- Fix: a `HighlightStyle` of Compass's own whose colours are Mantine CSS variables that adapt by scheme (e.g. `var(--mantine-color-blue-text)`, `-grape-text`, `-teal-text`, `-orange-text`, `var(--mantine-color-dimmed)` for comments), and `.cm-content { color: var(--mantine-color-text) }`, with the background from `--mantine-color-body`. CSS variables mean no remount when the scheme changes. No fixed colours (adaptive-colours rule).
- Check every place the editor appears: New script, Edit draft, the Script tab's read-only text, Versions (and its diff) and Preview.

**Done when:** on staging, in dark mode, every part of a script's SQL is easy to read wherever it's shown, and light mode looks as it does now.