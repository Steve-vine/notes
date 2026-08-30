---
id: 01M19P5A61VTE0DJG2D7WDREPV
created: 2026-08-30T15:56:09.79346Z
updated: 2026-08-30T16:20:22.925572Z
type: task
title: Table of contents
project: 01KY6W9951TW0904DT0GGJVGE7
number: 410
sprint: segj1dz
comments:
- id: 01M19QH2GAZF2HM8ENSDKSJG88
  author: Steve Vine
  at: 2026-08-30T16:20:03.718884Z
  text: |-
    Built and pushed as PR #404 (branch brief-410-table-of-contents), ADR 0057.

    What shipped:
    - `[[toc]]` / `[[toc,N]]` alone on a line renders the note's outline. `N` counts layers — a heading's rank among the levels the note actually uses — so `[[toc,1]]` still works in a note that starts at `##`, which is most of them since the title renders above the body. `[[toc]]` shows every layer.
    - `src/lib/toc.ts` holds the pure grammar (directive parser, inline-markdown stripping, de-duplicated heading ids, layer ranking, source scanner), unit-tested directly — 30 new tests, plus 5 for the read view's `tocHtml`.
    - Read view: headings collected in marked's `processAllTokens` hook, so a directive above its headings knows the outline; ids keyed on the heading token itself rather than a counter. Every top-level heading now carries an `h-<slug>` id, which marked stopped emitting in v5.
    - Entries are inert unless the surface opts in (`tocLinks`), per ADR 0055. The read view opts in and scrolls the heading itself, scoped to its own pane — heading ids repeat across open panes, so a plain `#` anchor would jump to the wrong one.
    - Live mode: a block widget over the directive line (outline off-cursor, source on-cursor); clicking an entry moves the caret to that heading.
    - Insert menu: "Table of contents", inserting `[[toc,3]]` so the menu teaches the parameter.

    Decisions made on the fly:
    - The `[[…]]` namespace was free — nothing in the app parses double brackets, and ADR 0006 keeps note links in frontmatter by id, so no wikilink syntax is coming to collide with it. The directive degrades to literal text in other markdown readers.
    - Headings nested in a callout or blockquote are out of the outline (and stay unlinkable): a heading inside a box belongs to the box.
    - A TOC in a note with no headings says "No headings" rather than vanishing, so the directive doesn't read as broken.

    Known rough edge, recorded in the ADR rather than fixed: a directive *inside* a callout renders as a TOC in Read and stays raw text in Live, because marked lexes the box body with the same extensions while Live's scanner only looks at top-level lines. Chasing it would mean teaching one side about the other's nesting for an input nobody writes.

    Checks: `npm run check`, `npm test` (312 passing), `npm run build` all clean; no Rust touched. The read pipeline was exercised end to end against duplicate headings, a setext heading, a fenced-code `[[toc]]`, a callout-nested heading, an inline `[[toc,2]]` and a directive interrupting a paragraph. The TOC's computed CSS was measured in headless Chrome against the read view's competing `.markdown ol` / `.markdown a` rules.

    Still wants your eye: the Live widget and the look of the outline in both modes — no DOM tests here and I can't screenshot.
assignee: steve
label:
- brief
priority: medium
task_status: review
---
Create a table of contents control that can be added onto forms. 

The TOC can be defined with custom markdown, I'm thinking [[toc,x]] unless that will clash with something else. Where x is the number of Header layers it shows, E.g. 
[[toc,1]] Would show

Heading1

[[toc,3]] Would show

Heading1
  Heading2
    Heading3

Each heading is a link to that part of the document

---

## Agreed work

`[[toc]]` / `[[toc,N]]` on its own line becomes a table of contents of the
note's headings. The `[[…]]` namespace is free — nothing in the app parses
double brackets today (ADR 0006 deliberately keeps note links out of the body),
so the syntax is available.

**`x` counts layers, not absolute heading levels.** A note whose headings are
`##` and `###` still gets one layer and two layers from `[[toc,1]]` /
`[[toc,2]]`; the layer of a heading is its rank among the heading levels the
note actually uses, so a skipped level (h1 then h3) doesn't cost a layer.
`[[toc]]` with no number shows every layer.

- [x] `src/lib/toc.ts` — the pure grammar and model: directive parsing, inline-
      markdown stripping, slugs + de-duplicated heading ids, layer ranking, and
      a source-side heading scanner (ATX + setext, outside fenced code). Unit
      tested, no DOM and no marked/CodeMirror import — same shape as `table.ts`
      (ADR 0054).
- [x] Read view (`markdown.ts`) — a `toc` block extension for marked, headings
      collected in the `processAllTokens` hook so a `[[toc]]` at the top of a
      note knows about headings below it, and a `heading` renderer override
      that stamps the matching id. Entries are **inert unless the caller opts
      in** (`tocLinks`, per ADR 0055); `NotePane` opts in because it handles
      the scroll.
- [x] `NotePane` — a `data-toc` click scrolls the heading into view, scoped to
      the pane's own render host (heading ids repeat across open panes, so a
      bare `#id` anchor would jump to the wrong pane).
- [x] Live mode (`livePreview.ts`) — a block widget rendering the same TOC
      off-cursor, source on-cursor, like the callout/code widgets; clicking an
      entry moves the caret to that heading. Inert links, per ADR 0055.
- [x] Insert menu — a "Table of contents" item inserting `[[toc,3]]`.
- [x] Shared `.toc` CSS in `theme.css`, so Read and the Live widget render
      identically.
- [x] ADR 0057 — the directive syntax, the layer semantics, and where the
      heading list comes from.
