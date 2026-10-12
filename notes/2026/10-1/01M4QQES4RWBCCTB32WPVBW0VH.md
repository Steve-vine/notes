---
id: 01M4QQES4RWBCCTB32WPVBW0VH
created: 2026-10-12T09:35:16.120535Z
updated: 2026-10-12T11:42:13.395575Z
type: task
title: Read / Live disparities and anomalies
project: 01KY6W9951TW0904DT0GGJVGE7
number: 537
sprint: sd52non
comments:
- id: 01M4QYP9P4PG5GKYVHGFCQH39E
  author: Steve Vine
  at: 2026-10-12T11:41:42.464897Z
  text: |-
    Done on brief-537-live-blank-line-runs, PR #529.

    Confirmed the diagnosis before changing anything: `marked` renders one, two or
    three blank lines identically, and preserves blank lines inside a fence. Read
    was already standard markdown, so only Live changed.

    Live now hides each blank line past the first — in place, newline included,
    the footnote-definition idiom (DEV-906) — so a run reads as the single
    paragraph break Read renders.

    Decisions made on the fly:

    - **Reveal by run, not by line.** My first instinct was per-line (what the
      footnote hide does), but collapsing some lines of a gap while revealing
      others looks broken. Cursor anywhere in the run shows the whole run.
    - **Protected blocks were mandatory, not just correct.** Blank lines are
      content inside a fence, so Read keeps them — but there's a second reason:
      off-cursor those nodes are already replaced wholesale by one block widget,
      and a second block decoration over the same lines would have collided. Covers
      fenced code, four-space indented code, HTML blocks and `$$` blocks.
    - **Nothing leaves the buffer** — the characters are only hidden, so arrowing
      through a collapsed gap still visits every line and the file keeps what was
      typed. No trailing-blank trimming on save; out of scope.
    - **No ADR.** ADR 0017 already says Live "looks like the rendered note"; this
      moves Live toward that decision rather than changing it. `brief/ui.md`
      doesn't describe Live's decorations, so nothing to amend there either.

    Problems / notes:

    - The run maths went into a pure `blankRuns()` with its own tests, but the
      interesting risk was the wiring. Turned out the Live block pass is a
      `StateField`, so its decorations can be read off an `EditorState` with no
      `EditorView` and no DOM — so there's now a headless integration test
      asserting the exact hidden ranges, the cursor reveal and both code-block
      exemptions. First such test in the repo; worth reusing for other Live
      behaviour.
    - Hand-derived the expected range for `a\n\n\nb` as [2,3] before running it,
      and the test agreed — good sign the model of `hide()` was right.

    653 tests pass. Full local pre-push gate green this time, cargo jobs included
    (the toolchain is installed on this laptop now). Not exercised by hand in a
    running app — needs eyes on a real window.
assignee: steve
label:
- bug
priority: medium
task_status: done
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

- [x] New `src/lib/blankRuns.ts`: `blankRuns(lines, isProtected?)` returns the
      runs of **two or more** consecutive blank lines as 1-based inclusive
      `{start, end}`. A protected line counts as non-blank, so a run never
      spans into or out of a code block. Pure and framework-free, the
      `boardNav.ts` pattern, with its own vitest file (10 cases).
- [x] `livePreview.ts`, block pass: for each run, hide lines `start+1..end`
      via the existing `hide(line.from - 1, line.to)` — the footnote-definition
      idiom (DEV-906), which joins the lines so the blank line vanishes.
- [x] **Reveal by run, not by line.** If any line of a run is in
      `activeLines`, the whole run shows its real blank lines, so what you
      edit is what's there.
- [x] **Protected ranges:** `FencedCode`, `CodeBlock` (four-space),
      `HTMLBlock` and `MathBlock`, collected in one `syntaxTree` walk that
      doesn't descend into them.
- [x] Headless integration test over the real Live `StateField`
      (`livePreviewBlankLines.test.ts`) — exact hidden ranges, the cursor
      reveal, and both code-block exemptions.

## Verification

- [x] Example 2 shows one blank line in Live and matches Read.
- [x] Three or more blank lines also collapse to one.
- [x] A fence containing blank lines keeps them; indented code too.
- [x] Cursor in a collapsed gap brings the real lines back.
- [x] Nothing is removed from the buffer, so arrowing through a collapsed gap
      still visits every line.

Out of scope: any change to the read renderer, and trailing-blank-line
trimming on save — a run at the end of a note collapses on screen like any
other, but the file keeps exactly what was typed.

Shipped in PR #529 (squash `65e7ea4`). No ADR — ADR 0017 already says Live
looks like the rendered note; this moves Live toward that.
