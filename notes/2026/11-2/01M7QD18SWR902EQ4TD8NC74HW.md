---
id: 01M7QD18SWR902EQ4TD8NC74HW
created: 2026-11-18T13:20:13.1162Z
updated: 2026-11-18T23:50:41.658061Z
type: task
title: 'Font options for flowchart text: size, colour, bold, italic, underline and alignment'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1957
sprint: s6y6p7g
comments:
- id: 01M7QVKM9RSF7ED5M80A5539AG
  author: Steve Vine
  at: 2026-11-18T17:34:54.776341Z
  text: |-
    Done — PR #1949, merged 8c37e685.
    With shapes or connections selected, the Style panel now has a Text section: Size (S, M as today's, L, XL); Bold, Italic, Underline and Strikethrough buttons; Text colour (Automatic, which stays readable on the fill, or any colour); and, for shapes, Align (Left, Centre, Right) and Vertical (Top, Middle, Bottom).
    It applies to the whole label of every selected item, one undo step per change, and copy/paste keeps it. A button is on when every selected item has the style; pressing it turns it on for all, or off if all had it.
    Ctrl+B, Ctrl+I and Ctrl+U work on the selected shapes and connections, on the canvas and while typing in the Label box.
    A shape grows to hold bigger or bold words, so text is never cut short. The canvas, reading view, PDF, Word and downloads show the same; the font stays the house style's.
    The steps in words, search and Polaris are unchanged. Compare versions says "text style changed".
    Assumptions: lane names get these options in the lanes panel with COM-1952, since lanes can't be selected on the canvas. Group titles, Text and Line labels use this same section when lane D's shapes land. Underline and strikethrough are drawn as lines in the picture so the PDF shows them too.
    To check on staging: style a long label XL and bold (the shape should grow), left/top-align one and underline a connection label, then publish and check the PDF and Word download.
- id: 01M7R6ZZA3PM9QF75W7KKTCEAZ
  author: Steve Vine
  at: 2026-11-18T20:53:53.603521Z
  text: |-
    Pre-UAT on staging cbacf0c2 — Failed
    Flowcharts: "E2E pre-UAT COM-1942 COM-1951 COM-1944 COM-1957 styles" (shapes and connections), "E2E pre-UAT COM-1952 lane colours" (lane names) and "E2E pre-UAT COM-1954 COM-1955 COM-1956 group line text" (Group title, Text, Line labels). As E2E Admin A in E2E Test Company.
    - Shapes, Notes and connection labels: Passed. XL + Bold on the long step: the shape grew from 60 to 160 high and its words fit. Italic on "Raise the request" by Ctrl+I on the canvas. Underline on "Send the reply" by Ctrl+U. Strikethrough on "Record the approval" by its button. Bold on End by Ctrl+B while typing in the Label box. Colour #2f9e44 with Right/Bottom on "Hand off to change", and Left/Top on Start. Underline + L on the "Yes" connection label. Size S on a Note and a decision selected together. A copy and paste kept the styles. The stored chart, canvas, reading view, PDF, Word and PNG/SVG all matched (COM-1957/r2-03-canvas-all-styles-wide.png, COM-1942/r2-styles-v3.pdf).
    - Text shape: Passed. Size L, centre, Italic and Bold (the button and Ctrl+B) were kept and drawn in the PDF (COM-1954/r2-group-v3-p2.png).
    - Line labels: Failed. On a free Line, Size and Text colour work (L and red were kept and drawn), but Bold, Italic, Underline, Strikethrough and Ctrl+B do nothing: the buttons stay off and nothing is stored. Steps: select a Line, press Underline. The button doesn't light up, and after Done the Line has no underline. Technical: toggleFont doesn't look at chart.lines.
    - Group titles: Failed. I set the Group's title to Bold, Underline (Ctrl+U) and Size L, and all three were stored. The canvas and the picture (PDF, SVG) still draw the title at the normal 13px with no underline (COM-1957/r2-08-group-title-text-styled.png; the SVG text for "Repeat every hour" has font-size 13 with no decoration).
    - Lane names look the same everywhere: Failed. On "Engineer" I set Size L, Bold, Italic and Align Left. The PDF, Word and PNG show it large and left-aligned. The canvas shows it large but centred (COM-1952/r2-13-canvas-light-adminB.png). The reading view shows it at 11px and centred (r2-09-read-light-rows-tidied.png, r2-10-read-zoomed-panned-pinned.png). Colour, bold and italic do match everywhere.
    - Text never overflows its shape: Failed, minor. On the canvas, Top/Bottom alignment puts the words right against the edge with no padding. "Start" (Left/Top) runs over the rounded corner of its outline, and the "Hand off to change" words (Right/Bottom) run into the slanted edge of the Hand-off. The picture pads the top, but the Hand-off's last letter still touches the slanted edge (COM-1942/r2-crop-handoff.png, COM-1957/r2-03-canvas-all-styles-wide.png).
    - Kept after Done, publishing and reopening; Compare versions: Passed for shapes, connections, lanes, Text and Group (it reads "text style changed"). A change to a Line label's size or colour isn't mentioned in Compare versions (v2→v3 of the group flowchart).
    Screenshots: ~/compass-uat/s6y6p7g/COM-1957/ (and the COM-1942, 1952, 1954 folders)
- id: 01M7RCMQTTXZ3Z104HBRKAR6PS
  author: Steve Vine
  at: 2026-11-18T22:32:36.953779Z
  text: |-
    Re-check on staging d6c281fe:
    - Line labels: now Passed. B/I/U/S work by button and by Ctrl+B/I/U.
    - Group titles: now Passed. Bold, Underline, L and Align are drawn on the canvas and in the PDF.
    - Lane names the same everywhere: now Passed.
    - Text never touches the outline: now Passed, with aligned words kept in from the outline in every shape type.
    - Compare names Line label style changes: now Passed. "No changes to the text." appears under the style changes.
    New since round 2, still Failed for "look the same in the PDF": italic now prints upright in the PDF. The house style "A4-Policy-External" (now v19) uses a custom font, and the flowchart's words fall back to DejaVu Sans in the PDF, losing italic. Details under COM-1980.
    Screenshots: ~/compass-uat/s6y6p7g/COM-1980/
- id: 01M7RH3PQT5F6VX36CAX0GEYNJ
  author: Steve Vine
  at: 2026-11-18T23:50:41.657809Z
  text: 'Re-check on staging 5d1e1459: PDF italic now Passed. The flowchart words in the PDF and Word are in the house style''s own font (Outfit under "A4-Policy-External"). Italic and bold-italic are slanted, bold is bold, and the line breaks match the canvas. Every point of this task now passes. Details under COM-1982 (~/compass-uat/s6y6p7g/COM-1982/).'
assignee: steve
label:
- improvement
priority: medium
task_status: review
---
Steve, testing on staging, 2026-11-18: add font options (size, colour, bold, italic, etc.) for shapes and text.

**What the author sees**
- With one or more items selected, the side panel has a **Text** section. It covers every shape's label, Text (COM-1956), Notes, connection and Line labels (COM-1955), Group titles (COM-1954) and lane names.
- The options:
  - **Size:** Small, Normal (today's), Large and Extra large.
  - **Colour:** Automatic (today's: light or dark to stay readable on the fill, COM-1942), or any colour from the same picker.
  - **Bold**, **Italic**, **Underline** and **Strikethrough**, as toggle buttons. The usual keys (Ctrl+B, Ctrl+I, Ctrl+U) work while a shape is selected or its label is being edited.
  - **Alignment:** left, centre or right, and top, middle or bottom within the shape.
- The style applies to the whole label of each selected item. Styling single words inside one label isn't part of this task.
- The font itself stays the house-style font, so flowcharts match their documents.
- A shape grows to fit bigger text, so text is never hidden (COM-1940).
- Each change is one undoable step, and copy/paste keeps the style.

**What a reader sees**
- **Pictures:** the reading view, PDF, Word and downloads show each style exactly. Automatic colour stays readable in light and dark.
- **Meaning:** the plain-text steps, search and Polaris read the words. Styling doesn't change them.
- **Compare versions:** it mentions a text style change in words.

**Done when**
- Size, colour, bold, italic, underline, strikethrough and both alignments can be set on any shape, Text, Note, connection or Line label, Group title and lane name, one or several at once.
- They're kept after Done, publishing and reopening, and look the same on the canvas, in the reading view, PDF, Word and downloads.
- Text never overflows its shape.
- Tests cover each option, multi-select, keyboard shortcuts and growing to fit.

Independent unless the stored chart needs new fields the server must accept (then on the chain). Shares the style panel with COM-1942, 1944 and 1951. COM-1956's Text uses these options rather than its own.