---
id: 01M7QD18SWR902EQ4TD8NC74HW
created: 2026-11-18T13:20:13.1162Z
updated: 2026-11-18T17:34:57.644371Z
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