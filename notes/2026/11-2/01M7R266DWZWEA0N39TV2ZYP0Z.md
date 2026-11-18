---
id: 01M7R266DWZWEA0N39TV2ZYP0Z
created: 2026-11-18T19:29:54.620149Z
updated: 2026-11-18T22:15:54.599295Z
type: task
title: 'Library reader: a heading''s number is the same size as the heading, as in the PDF'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1973
sprint: s2q1gxe
comments:
- id: 01M7RBNYK993THYVXWZ2YK0H6T
  author: Steve Vine
  at: 2026-11-18T22:15:48.073511Z
  text: |-
    Merged: PR #1964 (the PR number happens to be 1964; it isn't COM-1964), merge 4512cc8e. No migration.

    What changed for a reader: in the Library reader, a heading's number ("2" in "2 Purpose") is now the same size as the heading, as in the PDF. It also matches the PDF's colour and weight: the house style's muted colour (which the house style adjusts for dark mode) in semi-bold. The gap after the number is unchanged, and so is the Contents list.

    Check in the browser: a policy in light and dark mode.
assignee: steve
label:
- improvement
priority: low
task_status: review
---
Steve, testing the Library (18 Nov): "On the Library document read screen, the heading number is in a smaller font than the heading (E.g. 2 Purpose), on the PDF version it's the same size, can you make the number and heading the same size. The size in the content list is fine."

## What changes
- In the Library reader, a heading's number ("2" in "2 Purpose") is drawn at the heading's own size, like the PDF.
- The Contents list's numbers are fine and stay as they are.

## Cause
`libraryFolders/reader.css`, `.library-reader-text [data-number]::before`, sets `font-size: 0.72em` (plus `color: dimmed` and `font-weight: 400`). 

## Implementation notes
- Drop the `font-size` (inherit the heading's). Match the PDF for colour and weight too: check how the PDF/Content view draws the number. If the PDF draws it in the heading's colour and weight, drop those overrides as well, so the number reads as part of the heading. Keep the gap after the number.
- Scope: the reader only (`.library-reader-text`); the Contents list is untouched.
- Frontend CSS only; **independent**. It touches reader.css, as COM-1961/1962/1963 do, so build it after them or rebase onto them.

## Done when
- In the reader, "2 Purpose" (and every heading level) shows the number at the same size as the heading text, matching the PDF; checked in light and dark mode.
- The Contents list's numbering is unchanged.