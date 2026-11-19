---
id: 01M7QP5TK69FYSTHWZ2DG3Z6Z7
created: 2026-11-18T15:59:59.590082Z
updated: 2026-11-19T01:21:04.372318Z
type: task
title: 'The Library reader''s bar offers a reading width: Original, Wide or Full width'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1962
sprint: s2q1gxe
blocked_by:
- 01M7QNWP87GSCPXA9XQWER62QJ
comments:
- id: 01M7QVWM75GN5KPPRN1ZBSMD5D
  author: Steve Vine
  at: 2026-11-18T17:39:49.605151Z
  text: 'Change of name (18 Nov): Steve called the default "Normal" when asking for the same choice on the Library page (COM-1971). Use one set of names in both places: **Normal**, Wide and Full width. Normal replaces "Original" here, and still means the house style''s text width, as in Content. The two widths are separate choices, each remembered for the person.'
- id: 01M7RCXXA0QD6WNV2RRPP7JQV4
  author: Steve Vine
  at: 2026-11-18T22:37:37.471765Z
  text: |-
    Merged: PR #1966, merge 768c6867. Migration 0878_users_library_view: one new personal setting that holds a person's Library choices.

    What changed for a reader: the reader's top bar has a new Reading width button (a horizontal-arrows icon beside Contents and Export). It offers Normal, Wide and Full width, with the current choice ticked, and works from the keyboard. Normal is the house style's text width, as in Content, and is the default. Wide is half as wide again. Full width uses the whole window but keeps the usual side margin. On a phone the choice is in the More menu. If the window is narrower than the choice, the text fits the window, so there's never sideways scroll. Pictures never grow past their own size.

    The control doesn't show for uploaded files, links or SharePoint documents. Printing from the reader always uses the house style's width.

    The choice is remembered for the person and applies to every document they read, on any browser. As the task proposed, it's one setting for all documents, not one per document. The Library page's own width (COM-1971) and section sorts (COM-1970) will be saved alongside it.

    Assumption you may want to overturn: the icon has no text label in the bar. Its name, "Reading width", shows on hover.
- id: 01M7RP96BM9ZYX78FWWZ1SAAVX
  author: Steve Vine
  at: 2026-11-19T01:21:04.372071Z
  text: |-
    Pre-UAT (staging 25f02b9c, E2E Admin A): **Passed**.
    - Reading width offers Normal / Wide / Full width, with the current one ticked, and works by keyboard and mouse.
    - Widths: Normal 680 px, Wide 1020 px (exactly 1.5×), Full 1376 px with 32 px margins at a 1440 px window. No sideways scroll at any width.
    - The choice was kept after reload, in a fresh browser and across documents, and is separate from the Library page width.
    - The Contents menu and Back to top work at Full width. Flowchart pictures follow the column.
    - On a phone the control is under More.
    - Couldn't check: that the control is absent for uploaded PDF, link and SharePoint documents (none on staging), and that small pictures aren't stretched (none on staging).
    Screenshots: ~/compass-uat/library/COM-1962/.
assignee: steve
label:
- improvement
priority: medium
task_status: review
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