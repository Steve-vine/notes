---
id: 01M50GJVGJ693A4RS0KN3A2EJ9
created: 2026-10-15T19:28:19.474712Z
updated: 2026-10-15T19:47:27.167307Z
type: task
title: Each section is edited like a Word document — or in Markdown, switching freely — with tables with merged cells, callouts, page breaks, and blocks for contents, posture and domain controls
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 988
sprint: s2ufsxd
blocked_by:
- 01M50GJB3136FZW2H01E1PWX7J
assignee: steve
label:
- feature
priority: medium
task_status: todo
---
Sprint 71, Improve templated content (ADR in COM-986). Builds on COM-987.

## What people see

- **Each section is a formatted editor** with a toolbar for:
  - heading levels;
  - bold, italic, underline and strikethrough;
  - bullets, numbering and indent;
  - links, quotes, callouts (Note, Warning, Important) and horizontal rules;
  - page breaks, and undo/redo.
- **Tables:**
  - insert a table, then add or remove rows and columns;
  - set a header row, merge and split cells, and drag column widths;
  - shade a cell in one of the house style's colours.
- **Pasting** from Word or a web page keeps headings, lists, bold, italic, links and tables, and drops everything else (fonts, colours, odd spacing).
- **Insert** menu: *Contents*, *Posture* and *Domain controls*. Each shows in the editor as a labelled box and is filled in when the document is exported.
- Word's keyboard shortcuts work (Ctrl+B and so on). Markdown shortcuts work as you type (`## `, `- `, `1. `).
- Adding, reordering and deleting sections works as today.
- The Read view shows the formatting as written.

## Rich text or Markdown, switching freely (Steve, 2026-10-15)

- **The switch:** each section has a **Rich text | Markdown** switch. You can draft quickly in Markdown, switch to rich text to tweak, and switch back at any time.
- **Nothing is lost either way.** The Markdown is COM-987's lossless form:
  - callouts are `> [!NOTE]`;
  - special blocks are `{{contents}}`, `{{posture}}`, `{{domain-controls}}` and `{{page-break}}`;
  - images and diagrams appear as one-line references;
  - a table with merged cells appears as a small HTML table.
- **Pasting Markdown into the rich view** converts it as you paste: headings, lists, tables and the rest arrive formatted. Ctrl+Shift+V pastes the text exactly as it is, unconverted.
- **The Markdown view** is a plain text editor in a monospaced font, with gentle syntax colouring. It is the same size as the rich view, so the page doesn't jump when you switch.
- **Your choice of view** is remembered per person (not per document), so a Markdown fan lands in Markdown every time.
- **A mistake in Markdown** (for example an unclosed table) never loses text. Anything the converter can't place stays as a plain paragraph, so you can see and fix it.
- **Saving, drafts, review and versions** don't care which view you were in. Both save the same content.

Until COM-989 lands, the Word-template PDF falls back to plain tables (merged cells are flattened) and callouts become quotes.

## My calls

- Text colour is limited to the house style's palette, not a free colour picker. This keeps documents on brand.
- No font or size picker in the editor: the house style decides those.
- The view preference is per person, as above.
- Pasting Markdown is detected only when the clipboard holds plain text that looks like Markdown (a heading, list, table or fence marker). Pasting from Word or a web page is never treated as Markdown.

## Notes (technical)

- `@mantine/tiptap` and Tiptap extensions pinned to the versions Mantine's release expects (see the memory on the mantine-charts version pin):
  - StarterKit, Underline, Link, Placeholder;
  - Table, TableRow, TableHeader and TableCell, with merge/split;
  - custom nodes: callout, page break, and `special_block` (`kind: contents | posture | domain_controls`).
  Add the custom nodes to the shared schema and the converters from COM-987, with fixtures.
- The switch uses COM-987's converters (a TS port or the convert endpoint, whichever that PR chose). Converting happens on the switch, not on every keystroke. The section saves as `doc` from either view (the Markdown view converts on save).
- Markdown view: CodeMirror 6 with `@codemirror/lang-markdown` (MIT, small), lazy-loaded. A plain `Textarea` is acceptable if CodeMirror fights the layout. Record the bundle size either way.
- Paste: a Tiptap `handlePaste` that reads `text/plain` only when there is no `text/html` on the clipboard, and applies a "looks like Markdown" heuristic. Semgrep: no `new RegExp(variable)`.
- The view preference is a user setting (existing per-user preferences, if there is a store; otherwise `localStorage` with a try/catch).
- Paste sanitising for HTML goes through Tiptap's schema, so anything outside the node and mark set is dropped by construction. Test with a real Word clipboard HTML fixture.
- jsdom can't type into contenteditable reliably. Test through the editor's command API, and use the Playwright harness for a real-browser check of table merge and the switch (memory: headless-chromium-layout-harness).
- Screen conventions apply: `w="fit-content"` on toggles (the switch is a SegmentedControl); the react-hooks lint is strict.

**Done when:** on staging, Steve:
- pastes a Markdown draft, switches to rich text, merges two table cells and adds a callout;
- switches back to Markdown and sees them;
- switches to rich text again and finds everything intact;
- publishes, and the version history shows it.