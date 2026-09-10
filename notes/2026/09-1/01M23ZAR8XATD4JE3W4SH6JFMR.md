---
id: 01M23ZAR8XATD4JE3W4SH6JFMR
created: 2026-09-09T20:56:40.477786Z
updated: 2026-09-10T11:34:31.229466Z
type: task
title: '[contents] lists every heading in every section, indented and linked, not just one line per section'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 647
sprint: s9q4m6q
blocked_by:
- 01M23ZADYM4KXAPK37TBF44SPT
- 01M23ZN5JQFWM1MPZZYHT2DJD3
assignee: steve
label:
- improvement
priority: medium
task_status: active
---
Decided with Steve, 2026-09-09, reviewing the Content section. Follows the heading-field removal (stack on it).

A Word template can carry a `[contents]` placeholder. Today it is replaced by one linked line per section, using the section's heading, and every heading written *inside* a section's text is ignored. Real sections have several headings and sub-headings, so the contents list is far thinner than the document.

## What the reader gets

- **Every heading in every section becomes an entry**, in document order, at the level it was written: `#` at the outer level, `##` indented under it, and so on to `#####`.
- Each entry is a clickable link to that heading, as now.
- Still no page numbers — same as today. (A real Word contents field with page numbers would need the reader to update fields on open; deliberately not doing that.)
- The PDF inherits this because it is produced from the same Word document.

## Implementation notes

- `core/templating.py`: `_insert_section` bookmarks every heading paragraph it emits (`_toc{n}`), returning `(text, level, bookmark)` entries; `merge_sections_into_template` collects them across sections; `_insert_toc` writes each entry with the Word style `TOC {level}` (TOC 1–9 exist in the default template; keep the existing fall-back to the body style when a template lacks one).
- Body headings map to Word styles Heading 1–6 to match (today they cap at Heading 4).
- Update the Templates-tab help text: "`[contents]` — a linked table of contents built from every heading in your sections".
- Tests: a template with `[contents]` and two sections each with nested headings produces entries in order with the right TOC styles and working bookmarks; a section with no headings contributes nothing; an old version snapshot that still carries a `heading` produces a level-1 entry for it.

## Done when

Exporting a content item whose sections contain `#`, `##` and `###` headings to Word gives a contents list with every one of them, indented by level, each linking to its heading; the PDF shows the same list.