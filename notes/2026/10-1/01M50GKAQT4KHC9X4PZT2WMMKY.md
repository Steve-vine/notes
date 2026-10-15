---
id: 01M50GKAQT4KHC9X4PZT2WMMKY
created: 2026-10-15T19:28:35.066064Z
updated: 2026-10-15T19:30:27.747831Z
type: task
title: Compass makes a templated document's PDF itself — Print preview shows exactly what prints, in the house style's own fonts
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 989
sprint: s2ufsxd
blocked_by:
- 01M50GJB3136FZW2H01E1PWX7J
assignee: steve
label:
- feature
priority: medium
task_status: todo
---
Sprint 71, Improve templated content (ADR in COM-986). Builds on COM-987. The style designer (COM-990) and the Word and plain-text exports (COM-991) build on this.

## What people see

- **Compass ships with a built-in house style.** It has:
  - a cover page with the title, content type, version, owner and date;
  - a header with the title, and a footer with *page X of Y*;
  - numbered headings, and tables with a shaded header row;
  - the review record at the end, as today.
- **Admin ▸ Content types:** a type can be mapped to the house style instead of a Word template. A type still mapped to a Word template keeps working the old way until COM-995 retires it. Nothing changes for anyone until someone switches a type.
- **On a document of a switched type:**
  - **Print preview** opens the PDF. It is the same file you'd export, so there are no surprises.
  - **Export PDF** and the list's bulk export work as today.
- **Fonts are never substituted.** The PDF uses the font files the style names, and the Read view uses the same files, so the screen and the paper match.
- **Contents** lists every heading with its number and page number, linked. **Posture** and **Domain controls** look as they do in today's PDFs.
- A PDF takes a second or two, and is cached until the document or the style changes.

## Notes (technical)

- WeasyPrint runs on the worker. Add the Pango system libraries to the Dockerfile (small), and record the image size.
- HTML is built server-side from the ProseMirror JSON (one Python serialiser). The house style is turned into a CSS file of variables plus a fixed print stylesheet, using:
  - `@page` margin boxes for headers and footers;
  - `string-set` for the running title;
  - `target-counter(attr(href), page)` for the contents page numbers.
- The Read view uses the same style CSS (screen rules) and `@font-face` from Compass's font endpoint.
- Style storage: a `house_styles` table (Pydantic-validated settings JSON, `version`, `status`, audited), with the built-in one seeded insert-missing-only. `content_types` gains a nullable `style_id` beside `template_id`, and exactly one of them is set.
- The PDF cache key adds the style id and version. The review-record append (pypdf) is unchanged.
- Tests: extract the PDF's text with pypdf and check its embedded fonts; give contents page numbers a golden test.

**Done when:** on staging, Steve switches Policy to the house style, and a policy's Print preview shows the cover, numbered headings, a contents page with page numbers, a merged-cell table and the review record, with nothing substituted.