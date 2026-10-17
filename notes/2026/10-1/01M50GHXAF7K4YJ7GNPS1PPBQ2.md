---
id: 01M50GHXAF7K4YJ7GNPS1PPBQ2
created: 2026-10-15T19:27:48.559273Z
updated: 2026-10-16T10:52:21.266922Z
type: task
title: 'ADR: Compass writes its own documents — a rich editor, a house style and one renderer replace Word templates and LibreOffice'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 986
sprint: s2ufsxd
assignee: steve
label:
- brief
priority: high
task_status: done
---
Sprint 71, Improve templated content. Scoped with Steve on 2026-10-15. This task gates the rest of the sprint.

## Why

Templated documents are written in Markdown, merged into an uploaded Word template, and turned into a PDF by LibreOffice. Steve's list of problems:

- the PDF doesn't match the template, because the fonts and layout differ from Word's;
- LibreOffice is a large third-party product inside every Compass image;
- the template's .docx file has to be kept somewhere else so it can be changed and uploaded again;
- working between Word and Compass is clunky;
- tables, diagrams and richer formatting are out of reach.

## What was decided (Steve, 2026-10-15)

- **Only templated content changes.** Uploaded, linked and managed (SharePoint) documents stay exactly as they are.
- **Compass holds the whole document.** The content is written in a rich editor. The look comes from a **house style** designed in Compass. Word is no longer part of the process.
- **One house style across all companies.** It carries the organisation's branding, not the governed company's.
- **Export to PDF, Word and plain text.** The Word file is good enough to edit, but not pixel-perfect.
- **Diagrams both ways.** Drawn diagrams use Excalidraw, which has an MIT licence and is free. Diagrams can also be written as text. Images from outside Compass can be added.
- **Rich text or Markdown, switching freely.** A section can be written or pasted in Markdown and switched to rich text to tweak, and back again. Compass's Markdown is extended so that switching loses nothing (COM-987, COM-988).
- **Special blocks use double braces:** `{{contents}}`, `{{posture}}`, `{{domain-controls}}`, `{{page-break}}`. Square brackets were confused with ordinary text.

## My calls (Steve has not confirmed these)

- Content types still map to a style, the way they map to a Word template today. A new install has one style mapped to every type. More styles are possible but not expected.
- Compass keeps its own copy of every image and diagram. Making a PDF never reaches out to the internet.
- Today's special placeholders change place:
  - contents, posture and domain controls become blocks you insert in the editor (written as `{{…}}` in Markdown);
  - title and date move into the house style's cover, header and footer.
- Existing templated documents convert automatically. A Word template can't be converted, so the house style is set up once by hand, by Steve on staging.
- The assistant (sprint 70) keeps writing in Markdown, in the same lossless form, and Compass converts it.
- The kind keeps the name "Templated".

## Notes (technical)

- Write `decisions/0110-*.md` (the next free number; check first). It supersedes ADR 0030 §3–§6 (Word templates, the merge and the LibreOffice render) and amends 0035's description of templated. ADR 0030 §1 and §2 (sections, editable content types) still stand.
- **Editor**: Tiptap (ProseMirror) through `@mantine/tiptap`, pinned to the same version as `@mantine/core`. Section bodies are stored as ProseMirror JSON, with a plain-text rollup kept for search and diff.
- **Lossless Markdown**: GitHub-flavoured, plus alerts for callouts, `{{…}}` blocks, `compass:` image and drawing references, and an allow-listed HTML subset (`<table>` with spans, `<span data-colour>`, `<u>`) for what Markdown can't express. Record the full mapping in the ADR. It is a contract the assistant relies on.
- **Renderer**: WeasyPrint (BSD licence). It turns HTML plus CSS Paged Media into a PDF, with running headers and footers, `counter(page)`, and `target-counter` for the contents page numbers. It is Python plus the Pango system libraries, with no separate office suite.
  - Typst was considered: better typography, but a second markup to generate and to preview.
  - Headless Chromium was considered: it matches the browser exactly, but it is as heavy as LibreOffice.
- **One stylesheet** comes from the house style. The Read view uses it with web fonts loaded from the same font files, and the PDF uses it too.
- **Word export**: built with python-docx (already a dependency) from the rich content and the style. There is no template merge.
- **Diagrams**:
  - Excalidraw (`@excalidraw/excalidraw`, MIT) with its assets self-hosted, so nothing calls excalidraw.com. Check the CSP.
  - Mermaid (MIT), rendered in the browser. The source, an SVG and a PNG (for Word) are stored together.
  - The server never runs JavaScript.
- **LibreOffice** is used only by templated content. Uploaded files are download-only (DEV-817), and managed documents get their PDF from Graph. LibreOffice and its apt font packages leave the image when the Word path is retired.
- **Fonts**: open fonts are bundled (Carlito, Caladea, Liberation, Noto, plus a modern sans and serif), and .ttf, .otf and .woff2 uploads are allowed. Microsoft's fonts can't be bundled.

**Done when:** the ADR is merged and every task in this sprint points to it.