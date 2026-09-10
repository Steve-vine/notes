---
id: 01M25NZMA7V6JF9C0R9SMKRWQ1
created: 2026-09-10T12:51:47.65598Z
updated: 2026-09-10T13:40:08.456254Z
type: task
title: The contents list shows the heading number and page number — [contents] becomes a real Word table of contents
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 657
sprint: s9q4m6q
comments:
- id: 01M25RR4FCG6NFAJ100EH7P50Z
  author: Steve Vine
  at: 2026-09-10T13:40:07.788326Z
  text: |-
    Merged to main (PR #663), 2026-09-10.

    Spike outcome: `--convert-to` never refreshes the field and `w:updateFields` is ignored by the headless import; the Basic macro route works. One wrinkle: LibreOffice overwrites a Basic library seeded into a fresh profile, so the renderer initialises the profile first (well under a second) and drops the macro in afterwards.

    [contents] is now a real Word table-of-contents field (every heading level, hyperlinked) whose cached result is the linked entry list from COM-647, and the PDF renderer refreshes every index before saving. The PDF's contents list reads "1.0 Main contents", "1.1 Purpose" with dot leaders and page numbers, matching the numbered headings in the body. Proven in a container with the same LibreOffice as the image; the LibreOffice-gated test is skipped on the CI runner, which has no soffice. Spreadsheets and presentations keep the old conversion path. Renderer version bumped.

    Not on staging yet: deploys together with COM-656 and COM-658.
assignee: steve
label:
- improvement
priority: medium
task_status: review
---
Found reviewing the Content section on staging, 2026-09-10, after COM-647 landed. The contents list reads "Main contents" and "Purpose" while the headings in the body read "1.0 Main contents" and "1.1 Purpose".

## Cause

The heading number is not text. The template's Heading styles carry Word numbering, so Word (and LibreOffice at PDF time) prefixes each heading when it lays out the page. The `[contents]` list is plain text the merge writes itself (`_insert_toc` in `core/templating.py`): the heading's words as a link, styled `TOC n`. It never sees the number, and it has no page number for the same reason.

## Fix

`[contents]` becomes a **real Word table of contents field**, and the PDF renderer refreshes it before saving. The reader then gets exactly what Word would give them: the number, the wording, the template's own TOC styling, page numbers with dot leaders, and clickable entries. This supersedes COM-647's "still no page numbers" decision.

The merged Word file is only ever rendered to PDF (nothing downloads the `.docx`), so Word's "update fields on open" prompt is not a concern.

- **Spike first (half a day cap):** prove that LibreOffice headless can refresh a TOC field before export. Two known routes, try in order:
  1. `w:updateFields` in `settings.xml` plus the TOC field — check whether the headless import updates indexes on load.
  2. A Basic macro written into the throwaway profile that `render_docx_to_pdf` already creates (`user/basic/Standard/Module1.xba` + `script.xlb`), invoked as `soffice --headless -env:UserInstallation=… "macro:///Standard.Module1.Export(in, out)"`: open the document, `getDocumentIndexes()` → `update()` on each, `storeToURL` with `writer_pdf_Export`. Known to work; the `.xlsx` path keeps its existing `--convert-to`.
- Emit the field as `TOC \o "1-6" \h \z \u` in a complex field (`fldChar begin` / `instrText` / `fldChar separate` / cached result / `fldChar end`). **The cached result is today's generated entries**, so if the refresh is ever skipped the reader still sees a linked list rather than nothing.
- Heading bookmarks from COM-647 stay: harmless, and Word's own `\h` links use its own bookmarks.
- Bump `_RENDERER_VERSION` in `tasks/pdf.py`.

## Fallback if the spike fails

Compute the number ourselves: read the numbering definition the template's Heading styles reference (`abstractNum` levels, `lvlText` like `%1.0` / `%1.%2`, `numFmt`), count headings in document order across the template's own headings and the merged sections, and prefix the entry text. Fragile beyond plain decimal schemes and still without page numbers, so only if route 1 and 2 both fail.

## Tests

- Unit: the merge emits the TOC field with the switches above and the generated entries as cached content; a template without `[contents]` emits none.
- The renderer test that already needs LibreOffice (skipped where `soffice` is absent) gains a case: a template whose Heading 1 is numbered exports a PDF whose text contains "1.0 Main contents" twice — once in the contents list, once as the heading.

## Done when

The PDF's contents list reads "1.0 Main contents", "1.1 Purpose" with page numbers, matching the headings in the body, for the content in COM-648's screenshots.