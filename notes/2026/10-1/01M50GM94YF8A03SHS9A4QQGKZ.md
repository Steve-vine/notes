---
id: 01M50GM94YF8A03SHS9A4QQGKZ
created: 2026-10-15T19:29:06.206172Z
updated: 2026-10-15T19:30:28.876636Z
type: task
title: A templated document exports to Word and to plain text, as well as PDF — one at a time or in bulk
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 991
sprint: s2ufsxd
blocked_by:
- 01M50GKAQT4KHC9X4PZT2WMMKY
assignee: steve
label:
- feature
priority: medium
task_status: todo
---
Sprint 71, Improve templated content (ADR in COM-986). Builds on COM-989. Steve asked for both formats on 2026-10-15.

## What people see

- **Export menu on the document:** PDF, Word (.docx) and Plain text (.txt).
- **Bulk export on the content list:** choose the format, and get a zip as today.
- **Who can export:** anyone who can read the document, the same as PDF today.
- **Word:**
  - uses the house style: fonts, colours, cover page, header and footer, numbered headings, tables (merged cells included);
  - images and diagrams come through as pictures;
  - the review record is at the end;
  - the contents is a real Word table of contents, which Word fills in when the file is opened (Word asks to update fields).
  The file is fully editable, but it won't be pixel-identical to the PDF, because Word lays it out itself.
- **Plain text:**
  - the title and details, then numbered headings, and lists as `-` and `1.`;
  - tables as aligned columns;
  - each image as a line, `[Image: caption]`;
  - each drawn diagram as `[Diagram: caption]`, and a text diagram with its text underneath;
  - the review record at the end.

## My calls

- A Word file names its fonts but doesn't carry them (Word can't embed fonts in a generated file). If the reader doesn't have the house font, Word substitutes. The export menu says so in one line.
- Plain text wraps at 100 characters.

## Notes (technical)

- The `.docx` is built with python-docx from the ProseMirror JSON plus the house style:
  - styles defined in the generated file (Normal, Heading 1–6, a table style, callout);
  - headers and footers with the PAGE and NUMPAGES fields;
  - a different first page for the cover;
  - a TOC field, with `updateFields` set in settings.xml.
  Reuse the numbering helpers in `core/templating.py` before COM-995 removes that module (move them, don't copy them).
- Images and diagrams use their stored PNG. Word's SVG support isn't reachable from python-docx.
- Plain text is a serialiser over the same JSON. Diagram text comes from its source.
- Export runs on the worker, as PDF does. Cache by format, document version and style version.
- Tests: open the generated .docx with python-docx and check headings, tables and merges; give plain text a golden file.

**Done when:** on staging, a policy with a merged table and a callout exports to Word, opens cleanly in Word with the house fonts and a working contents, and exports to plain text that reads sensibly.