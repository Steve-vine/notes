---
id: 01M19P5A61VTE0DJG2D7WDREPV
created: 2026-08-30T15:56:09.79346Z
updated: 2026-08-30T16:03:32.477966Z
type: task
title: Table of contents
project: 01KY6W9951TW0904DT0GGJVGE7
number: 410
sprint: segj1dz
assignee: steve
label:
- brief
priority: medium
task_status: active
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

- [ ] `src/lib/toc.ts` — the pure grammar and model: directive parsing, inline-
      markdown stripping, slugs + de-duplicated heading ids, layer ranking, and
      a source-side heading scanner (ATX + setext, outside fenced code). Unit
      tested, no DOM and no marked/CodeMirror import — same shape as `table.ts`
      (ADR 0054).
- [ ] Read view (`markdown.ts`) — a `toc` block extension for marked, headings
      collected in the `processAllTokens` hook so a `[[toc]]` at the top of a
      note knows about headings below it, and a `heading` renderer override
      that stamps the matching id. Entries are **inert unless the caller opts
      in** (`tocLinks`, per ADR 0055); `NotePane` opts in because it handles
      the scroll.
- [ ] `NotePane` — a `data-toc` click scrolls the heading into view, scoped to
      the pane's own render host (heading ids repeat across open panes, so a
      bare `#id` anchor would jump to the wrong pane).
- [ ] Live mode (`livePreview.ts`) — a block widget rendering the same TOC
      off-cursor, source on-cursor, like the callout/code widgets; clicking an
      entry moves the caret to that heading. Inert links, per ADR 0055.
- [ ] Insert menu — a "Table of contents" item inserting `[[toc,3]]`.
- [ ] Shared `.toc` CSS in `theme.css`, so Read and the Live widget render
      identically.
- [ ] ADR: the directive syntax, the layer semantics, and where the heading
      list comes from.
