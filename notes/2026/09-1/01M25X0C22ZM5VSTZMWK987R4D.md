---
id: 01M25X0C22ZM5VSTZMWK987R4D
created: 2026-09-10T14:54:32.002168Z
updated: 2026-09-10T14:54:32.002168Z
type: task
title: List items sit tight against each other in the PDF — no paragraph gap between bullets
task_status: active
priority: medium
label: bug
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 659
---
Found by Steve smoke-testing staging, 2026-09-10, after COM-656 landed. Bullets and numbers now appear, but each item still carries a paragraph-sized gap below it, so a list reads as spaced-out paragraphs rather than a list.

## Cause

Each list item is a Word paragraph. When the template has no List styles, the item inherits the body style's spacing (Word's default is 8pt after), and the merge sets nothing to counter it. Word's own lists avoid this because its List Paragraph style suppresses spacing between neighbouring items; the merge does not apply that style or its setting.

## Fix

Items in a list sit tight against each other, with the normal paragraph gap kept before the first item and after the last — matching the on-screen preview. Nested items are tight too, and a loose list (blank lines between items in the text) renders tight, as the preview does.

- `core/templating.py`: set space-after to zero directly on every list paragraph (items and continuation paragraphs) except the last paragraph of the outermost list, so the gap after the list is the body's. Direct spacing wins over the style, so this holds whether or not the template has List styles.
- Bump `_RENDERER_VERSION` in `tasks/pdf.py` so cached PDFs re-render.
- Tests: a two-level list followed by a paragraph — every list paragraph but the last has space-after 0; the last keeps the style's spacing; a paragraph after the list is untouched. Two consecutive lists each end with a gap.

## Done when

The bulleted list from the COM-648 screenshots exports with its items directly under one another and a single normal gap before and after the list, in both Word and the PDF.