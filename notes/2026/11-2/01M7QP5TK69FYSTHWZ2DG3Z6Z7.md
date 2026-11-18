---
id: 01M7QP5TK69FYSTHWZ2DG3Z6Z7
created: 2026-11-18T15:59:59.590082Z
updated: 2026-11-18T16:00:03.03277Z
type: task
title: 'The Library reader''s bar offers a reading width: Original, Wide or Full width'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1962
sprint: s2q1gxe
blocked_by:
- 01M7QNWP87GSCPXA9XQWER62QJ
assignee: steve
label:
- improvement
priority: medium
task_status: todo
---
Steve, testing the Library on staging (18 Nov): add a choice of reading width to the reader's bar.

**What the reader sees:** the reader's top bar, beside Contents, Export and Colour scheme, gains a width control with three choices:
- **Original:** as it is in Content, the house style's text width (COM-1961). This is the default.
- **Wide:** 50% wider than Original.
- **Full width:** the text runs the whole width of the browser, keeping the usual side margin so it doesn't touch the edges.

**Done when**
- The three choices are in the reader's bar, with the current one marked, and work from the keyboard.
- Wide and Full width never cause sideways scroll. On a window narrower than the choice, the text fits the window, as Original does now.
- The choice is remembered for the person and applies to every document they open in the reader, on any browser, the way other personal preferences follow them. My call, for Steve to overturn: one setting for all documents, not one per document.
- Pictures, tables, flowcharts and diagrams follow the column. A picture is never stretched beyond its own size.
- The progress line, "Back to top" and the Contents menu work at every width.
- Uploaded PDFs keep their own viewer. The control doesn't show for them, or for documents held as a link or in SharePoint.
- Printing and Export are unchanged: they always use the house style's page.
- Tests cover the three widths and the remembered choice.

Builds on COM-1961 (Original is the house style's width). Frontend, plus one more personal preference saved with the person's others. If that store needs an API change, it joins the end of the chain.