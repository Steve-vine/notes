---
id: 01M50GJVGJ693A4RS0KN3A2EJ9
created: 2026-10-15T19:28:19.474712Z
updated: 2026-10-15T19:28:25.336453Z
type: task
title: Each section is edited like a Word document — headings, lists, tables with merged cells, callouts, page breaks, and blocks for contents, posture and domain controls — no Markdown
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 988
sprint: s2ufsxd
assignee: steve
label:
- feature
priority: medium
task_status: todo
---
Sprint 71, Improve templated content (ADR in COM-986). Builds on COM-987.

## What people see

- **The Markdown box is gone.** Each section is a formatted editor with a toolbar for:
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
- **Insert** menu: *Contents*, *Posture* and *Domain controls*. Each shows in the editor as a labelled box and is filled in when the document is exported, as the `[contents]`, `[posture]` and `[domain-controls]` placeholders are today.
- Word's keyboard shortcuts work (Ctrl+B and so on). Markdown shortcuts still work for anyone who likes them (`## `, `- `, `1. `).
- Adding, reordering and deleting sections works as today.
- The Read view shows the formatting as written.

Until COM-989 lands, the Word-template PDF falls back to plain tables (merged cells are flattened) and callouts become quotes.

## My calls

- Text colour is limited to the house style's palette, not a free colour picker. This keeps documents on brand.
- No font or size picker in the editor: the house style decides those.

## Notes (technical)

- `@mantine/tiptap` and Tiptap extensions pinned to the versions Mantine's release expects (see the memory on the mantine-charts version pin):
  - StarterKit, Underline, Link, Placeholder;
  - Table, TableRow, TableHeader and TableCell, with merge/split;
  - custom nodes: callout, page break, and `special_block` (`kind: contents | posture | domain_controls`).
  Add the custom nodes to the shared schema from COM-987, and their Markdown fallback.
- Paste sanitising goes through Tiptap's schema, so anything outside the node and mark set is dropped by construction. Test with a real Word clipboard HTML fixture.
- jsdom can't type into contenteditable reliably. Test through the editor's command API, and use the Playwright harness for a real-browser check of table merge (memory: headless-chromium-layout-harness).
- Screen conventions apply: `w="fit-content"` on toggles; the react-hooks lint is strict.

**Done when:** on staging, Steve writes a section with a merged-cell table, a callout and a contents block, publishes it, and the version history shows it.