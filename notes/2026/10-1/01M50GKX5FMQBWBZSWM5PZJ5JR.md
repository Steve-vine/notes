---
id: 01M50GKX5FMQBWBZSWM5PZJ5JR
created: 2026-10-15T19:28:53.935984Z
updated: 2026-10-16T03:58:48.974652Z
type: task
title: The house style is designed in Compass — page, fonts, colours, logo, cover page, header and footer — with a live preview, and no file to keep anywhere else
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 990
sprint: s2ufsxd
blocked_by:
- 01M50GKAQT4KHC9X4PZT2WMMKY
assignee: steve
label:
- feature
priority: medium
task_status: review
---
Sprint 71, Improve templated content (ADR in COM-986). Builds on COM-989's built-in style and renderer.

## What people see

**Admin ▸ Templates becomes House styles.** You edit the built-in style, or add another. One style serves every company (Steve, 2026-10-15). Each part of the style can be set:

- **Page:** A4 or Letter, and the margins.
- **Fonts:**
  - pick the heading font and the body font from the bundled set, or upload the organisation's own (TTF, OTF or WOFF2);
  - set the body size and the size of each heading level.
  An uploaded font is used everywhere the style is: the Read view, the PDF and the Word export.
- **Colours:** primary, accent, table header, and the callout colours. These are also the colours the editor offers.
- **Logo:** uploaded once, and shown on the cover and, if chosen, in the header.
- **Cover page:**
  - choose which details appear: title, content type, version, owner, approver, effective date, next review date, classification text;
  - set their alignment, and an optional colour band.
- **Header and footer:** left, centre and right slots. Each holds title, version, date, *page X of Y*, classification text, logo, free text, or nothing. You can leave the cover page without them.
- **Headings:** numbered (1, 1.1, 1.1.1) or not.
- **Tables:** header shading, borders, and banded rows.

**Live preview.** It shows a sample document, or a real one you choose, and updates as you change things. The preview is the real PDF.

**Moving a style between Compass installs.** *Download* saves the style as a single file with its fonts and logo, and *Load* reads it into another Compass. This is how a style set up on staging reaches production. It is a convenience: you never need the file to change the style.

**Governance:**

- every change is in Activity;
- a style in use can't be deleted (disable it or remap the types first), the same as templates today;
- who can edit is the same as for templates today.

## My calls

- The font upload shows one line: "Only upload fonts your organisation is licensed to embed in documents."
- The sample document is built in, and covers every block type (headings, lists, tables, callouts, contents, an image placeholder).

## Notes (technical)

- The style settings schema is Pydantic, and versioned. A change bumps `version`, which invalidates cached PDFs.
- Fonts and logo are stored in object storage, referenced by the style. Font upload is checked by magic bytes and a size cap (5 MB), served with a strict content type and `nosniff`.
- The preview reuses the COM-989 render task, debounced, with the PDF shown in an iframe. Keep it on the worker. Never render in the API process.
- The download/load file is a zip of a JSON manifest plus assets, validated against the schema on load. Fonts are re-checked.
- `require_library_write` gates editing, as it does for templates. The style and its assets are audited.

**Done when:** on staging, Steve rebuilds the organisation's look as a house style (logo, brand font, colours, cover, footer), the preview matches the exported PDF, and the style downloads and loads back cleanly.