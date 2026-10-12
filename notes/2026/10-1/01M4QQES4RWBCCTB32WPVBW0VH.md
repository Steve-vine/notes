---
id: 01M4QQES4RWBCCTB32WPVBW0VH
created: 2026-10-12T09:35:16.120535Z
updated: 2026-10-12T11:26:24.215341Z
type: task
title: Read / Live disparities and anomalies
project: 01KY6W9951TW0904DT0GGJVGE7
number: 537
sprint: sd52non
assignee: steve
label:
- bug
priority: medium
task_status: active
tech:
- svelte
---
There seems to be a difference in the way that empty lines are displayed between live and read views.  Review the code base and ensure that they are treated the same way in both views, preferably the standard markdown way.

E.g.

Example 1 - Markdown
This is paragraph 1.

This is paragraph 2. 

Example 2 - Markdown
This is paragraph 1.


This is paragraph 2. 

Example 1 displays the same in both live and read views, however example 2 looks exactly the same as example 1 in read and shows 2 blank lines in live.
I believe read is the correct markdown way.

## Confirmed

Read is right. `marked` collapses any run of blank lines to one paragraph
break — one, two and three blank lines all render as
`<p>…</p><p>…</p>` — and preserves blank lines inside a fence verbatim. Live
shows the source lines as they are, so the gap grows with every extra blank
line. So Live is the outlier and Read needs no change.

## Agreed work

Live collapses a run of blank lines to one, the same way it already hides
footnote definitions and `[[toc]]` directives: a whole-line `replace` in the
block pass that swallows the preceding newline, lifted off when the cursor is
there.

- [ ] New `src/lib/blankRuns.ts`: `blankRuns(lines, isProtected?)` returns the
      runs of **two or more** consecutive blank lines as 1-based inclusive
      `{start, end}`. A protected line counts as non-blank, so a run never
      spans into or out of a code block. Pure and framework-free, the
      `boardNav.ts` / `blankRuns` pattern, with its own vitest file.
- [ ] `livePreview.ts`, block pass: for each run, hide lines `start+1..end`
      via the existing `hide(line.from - 1, line.to)` — the footnote-definition
      idiom (DEV-906), which joins the lines so the blank line vanishes.
- [ ] **Reveal by run, not by line.** If any line of a run is in
      `activeLines`, the whole run shows its real blank lines, so what you
      edit is what's there. Collapsing some lines of a run while revealing
      others would just look broken.
- [ ] **Protected ranges:** `FencedCode`, `CodeBlock` (four-space),
      `HTMLBlock` and `MathBlock`. Blank lines are significant inside a fence,
      and off-cursor those nodes are already wholly replaced by a block
      widget — a second block decoration over the same lines would collide.
      Collected in one `syntaxTree` walk that doesn't descend into them.

## Verification

- Example 2 above shows one blank line in Live and matches Read.
- Three or more blank lines also collapse to one.
- A fence containing blank lines keeps them (off-cursor it's a code box;
  cursor inside, the source is intact).
- Putting the cursor in a collapsed gap brings the real lines back, and
  moving away re-collapses.
- Arrowing down through a collapsed gap still visits every line (the
  characters are only hidden, never removed).

Out of scope: any change to the read renderer, and trailing-blank-line
trimming on save — a run at the end of a note collapses on screen like any
other, but the file keeps exactly what was typed.
