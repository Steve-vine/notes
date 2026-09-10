---
id: 01M23ZN5JQFWM1MPZZYHT2DJD3
created: 2026-09-09T21:03:52.427128Z
updated: 2026-09-10T11:53:20.102137Z
type: task
title: 'The PDF breaks paragraphs at every source line: wrapped prose fragments, bullets split, backticks shown'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 648
sprint: s9q4m6q
blocked_by:
- 01M23ZADYM4KXAPK37TBF44SPT
comments:
- id: 01M25JMJXND7W4VRK0YE0PCS0Q
  author: Steve Vine
  at: 2026-09-10T11:53:20.052969Z
  text: |-
    Merged to main (PR #660), 2026-09-10.

    The Word merge now parses a section's text as CommonMark (markdown-it-py, the same dialect as the on-screen preview) and builds Word paragraphs from it: soft-wrapped lines join into one paragraph, a bullet keeps its continuation and nests (List Bullet 2 and so on, falling back to level 1 when the template lacks it), inline code is monospace with no backticks, links are clickable, hard breaks, block quotes and fenced code all render. Tables are left out: they are not CommonMark and the preview does not render them either. The renderer version is bumped so cached PDFs re-render on deploy.

    Not on staging yet: deploys together with COM-646 and COM-647.
assignee: steve
label:
- bug
priority: medium
task_status: review
---
Found reviewing the Content section, 2026-09-09.

Markdown in Compass
![CleanShot 2026-09-09 at 22.00.42@2x.png](attachments/2026/09/01M23ZN5JQFWM1MPZZYHT2DJD3/CleanShot-2026-09-09-at-22.00.42@2x.png)

Rendered text in browser (PDF)
![CleanShot 2026-09-09 at 22.02.47@2x.png](attachments/2026/09/01M23ZN5JQFWM1MPZZYHT2DJD3/CleanShot-2026-09-09-at-22.02.47@2x.png)

## What is wrong

The on-screen preview and the exported PDF disagree about the same text. In the PDF:

- A paragraph written with hard line wraps comes out as one short paragraph per source line, with a paragraph gap between each.
- A bullet whose text continues on an indented next line comes out as the bullet, then a separate indented paragraph.
- Inline code (`` `AIG.5` ``) is printed with its backticks.

The 1.0 / 1.1 numbering on headings is the template's heading style, not a defect.

## Cause

The preview uses a real Markdown renderer (`react-markdown`, CommonMark). The Word merge does not: `_insert_section` in `core/templating.py` walks the body **line by line** and emits one Word paragraph per non-blank line, recognising only `#` headings, `-`/`*` bullets, `1.` items, and `**bold**` / `*italic*`. It has no notion of a paragraph spanning lines, list-item continuation, nesting, inline code or links. It was written as "modest fidelity" (ADR 0030 §4) and the content has outgrown it.

## Fix

Replace the line walker with a proper Markdown parse and emit Word paragraphs from the block tree.

- Parse with **markdown-it-py** (pure Python, CommonMark, same dialect as the preview) into blocks; keep `python-docx` for the output.
- Paragraph: soft-wrapped lines join into one Word paragraph. Blank line ends it.
- Headings `#`–`######` → Heading 1–6.
- Lists: bullet and numbered, continuation lines joined into the item, nesting honoured (`List Bullet 2` / `List Number 2`, falling back to the level-1 style when the template lacks it — same fall-back as the existing `_paragraph_after`).
- Inline: bold, italic, **inline code as a monospace run**, links as hyperlinks (the `_add_internal_link` run shape already exists for internal ones; external needs a relationship), hard line breaks (`  ` or `\`) as `w:br`.
- Block quote: a plain paragraph in the `Quote` style if the template has it, otherwise indented.
- Fenced code block: one paragraph per line in a monospace run, no further parsing.
- Tables: out of scope unless trivial with the parser; note it in the PR if left.
- Bump `_RENDERER_VERSION` in `tasks/pdf.py` so cached PDFs re-render on deploy.

## Ordering

Stack on COM-646 (the heading field is gone by then, so the section renderer takes only a body). COM-647 (contents from every heading) then stacks on this, so it bookmarks headings in the new emitter rather than the old one.

## Done when

The content in the screenshots exports to a PDF whose paragraphs, bullets and inline code match the on-screen preview: one paragraph per Markdown paragraph, one bullet per item with its continuation joined, `AIG.5` in monospace with no backticks. The existing `test_templating.py` cases still pass, plus new ones for a soft-wrapped paragraph, a continued bullet, a nested list, inline code and a link.