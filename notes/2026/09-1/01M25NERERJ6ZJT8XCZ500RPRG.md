---
id: 01M25NERERJ6ZJT8XCZ500RPRG
created: 2026-09-10T12:42:34.840085Z
updated: 2026-09-10T13:03:39.558296Z
type: task
title: Bullets and numbering show in the PDF whatever the template contains — lists stop depending on the template's styles
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 656
sprint: s9q4m6q
assignee: steve
label:
- bug
priority: medium
task_status: active
---
Found reviewing the Content section on staging, 2026-09-10, after COM-646/647/648 landed. Paragraphs now render correctly; list items still come out as plain paragraphs with no bullet or number. The earlier PDF screenshot on COM-648 shows the same, so this predates the renderer rewrite.

## Cause

The Word merge styles a list item with Word's built-in `List Bullet` / `List Number` styles (and `List Bullet 2`, `List Continue`, … for nesting and continuation). If the template does not define a style, `_paragraph_after` in `core/templating.py` silently keeps the body style. Word only writes a style into a document when the document has used it, so a template that was never given a bulleted list has no `List Bullet` style at all — and every list in every export from that template renders as body text. Reproduced locally: delete the list styles from a template and every item comes out `Normal`; leave them in and they come out `List Bullet` / `List Number`.

The tests use python-docx's stock template, which carries the styles, so they cannot see this.

## Fix

Lists stop depending on what the template happens to contain. The merge supplies its own numbering:

- Add a **numbering part** to the document at merge time if the document lacks one (or append to it if it has one): one abstract definition for bullets (levels 0–8, `•` / `◦` / `▪` cycling, Symbol/Courier New as Word does) and one for decimal numbering (`%1.`, `%2.`, … indented per level), each level with a hanging indent so wrapped lines align under the text.
- Every list paragraph gets direct paragraph numbering — `w:numPr` with the level as `w:ilvl` and a `w:numId`. **Each list gets its own `w:num` instance** referencing the shared abstract, with a level-0 start override, so two numbered lists in a section both start at 1 rather than continuing.
- Keep applying the `List Bullet` / `List Number` style when the template has it, for the template's font and spacing; direct numbering takes precedence over the style's own, so the outcome is the same either way.
- `List Continue` paragraphs (a second paragraph inside an item) keep the item's indent but no glyph: indent from the abstract level, no `numPr`.
- Fallback rule: none needed. Bullets and numbers always appear.
- Bump `_RENDERER_VERSION` in `tasks/pdf.py` so cached PDFs re-render.

## Tests

- A template with the list styles removed: bullet and numbered items carry `numPr` with the right `ilvl`, nested items one level deeper, and the document has a numbering part with both abstracts.
- Two separate numbered lists get distinct `numId`s.
- A template that has the styles: items carry both the style and `numPr`.
- The existing `test_bullet_continuation_joins_and_nesting_indents` case still passes.

## Done when

Exporting the content from COM-648's screenshots with the same template shows the objective list as bullets, and a numbered list as 1., 2., 3., with wrapped lines aligned under the text, in both the Word file and the PDF.