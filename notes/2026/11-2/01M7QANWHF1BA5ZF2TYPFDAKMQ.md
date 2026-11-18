---
id: 01M7QANWHF1BA5ZF2TYPFDAKMQ
created: 2026-11-18T12:39:02.959333Z
updated: 2026-11-18T20:53:25.593249Z
type: task
title: Colour a flowchart shape's fill and border, and a connection's line
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1942
sprint: s6y6p7g
comments:
- id: 01M7QQEYPQ13W9MH96YSCAHAG8
  author: Steve Vine
  at: 2026-11-18T16:22:27.286873Z
  text: |-
    Done — PR #1938, merged 886f4fc3.
    With shapes selected, the panel beside the canvas now has a Style section with Fill and Border; with connections selected, Line (its arrowhead follows). Each picker offers Transparent (fill and border only, a chequered swatch), the house style's colours, any colour (picker or hex code) and Default.
    It applies to everything selected, one undo step per change, and copy/paste keeps it. A shape's words turn light or dark to read on its fill; on a transparent fill, on what's behind it.
    A shape with no fill and no border keeps a faint dashed outline on the canvas so it can be found. The picture, reading view, PDF, Word and downloads show the colours.
    Compare versions says it in words, e.g. Step “Approve” fill and border colour changed.
    Polaris redrafting a flowchart keeps the colours of the steps, connections and lanes it keeps.
    Assumptions: a chosen house colour is kept as its colour code, so a later change to the house style doesn't recolour flowcharts already drawn. Lanes and words can't be Transparent.
    To check on staging: colour a few shapes and a line, including Transparent, then Done, publish, and check the reading view (light and dark), the PDF and the Word download.
- id: 01M7R6Z3YS2ZJXT77A7GB0G8XG
  author: Steve Vine
  at: 2026-11-18T20:53:25.593075Z
  text: |-
    Pre-UAT on staging cbacf0c2 — Failed (one point: words on a Transparent shape can't be read on the dark canvas when the lane behind has a pale colour of its own; everything else passed)
    Test flowchart: "E2E pre-UAT COM-1942 COM-1951 COM-1944 COM-1957 styles" (standalone, two lanes), as E2E Admin A in E2E Test Company. v2 is the plain layout, v3 the styled one.
    - Fill, Border and Line on one or several shapes and connections, Transparent, Default, kept after Done, publishing and reopening: Passed. Each picker lists, in order, Transparent (chequered swatch), the eight house colours, "any colour" (picker plus Hex code) and Default. Line has no Transparent. I gave "Raise the request" a Primary fill and an Accent border. I gave "Record the approval" #ffe066 by hex code. I made "Approved?" and "Send the reply" (selected together) Transparent for both fill and border. I gave "Hand off to change" a Text fill, then pressed Default, and the fill went back. Two connections took Accent together, and a third took #e03131. One Undo took a fill change back, and Redo put it back. A copy and paste of a styled shape kept its fill and border. The stored chart after publishing had exactly these values, and Default left no colour stored.
    - Shape words always readable on their fill, including Transparent: Failed in one case. On the light canvas, the reading view and every export, the words turn white on Primary and dark on yellow, and a Transparent shape reads against the lane behind it. In the dark canvas, a Transparent "Log the call" in a lane given a pale yellow background (#fff3bf, COM-1952) shows light words on pale yellow and is almost invisible (COM-1952/r2-01-canvas-lane-colours.png). The words should go dark there, as they do in the picture. Steve: switch the canvas to dark and look at a Transparent step in a pale-coloured lane.
    - A fully transparent shape can still be seen and selected on the canvas: Passed. It has a faint dashed outline and clicks select it. The picture has no outline (r2-04-canvas-colours.png, r2-dl-…png).
    - Colours in the reading view (light and dark), PDF, Word and downloads: Passed (r2-05-read-light.png, r2-08-read-dark.png, r2-styles-v3.pdf/.docx, r2-dl-….png/.svg). In dark mode the reading view still shows the picture on white paper, and the chosen colours are unchanged. On the dark canvas, chosen colours keep their colour (r2-09-canvas-dark.png).
    - Compare versions in words: Passed. v2→v3 reads e.g. Step "Raise the request" fill, border colour and text style changed, and Connection "Record the approval" → "Send the reply" line colour and line style changed (r2-07-compare-v2-v3.png).
    Screenshots: ~/compass-uat/s6y6p7g/COM-1942/
assignee: steve
label:
- improvement
priority: medium
task_status: review
---
Steve, testing on staging, 2026-11-18: a colour picker for a shape's background and border, and for a connection's line, would be a useful addition. Steve, same day: the picker also needs a Transparent option, so a shape can have no fill or no border (the new Text shape, COM-1956, starts that way).

**What the author sees**
- With one or more shapes selected, the side panel has **Fill** and **Border** colour pickers. With connections selected, it has **Line** (and its arrowhead).
- Each picker offers, in order:
  - **Transparent**, for no fill or no border, shown as a chequered swatch (Fill and Border only, since a line must be seen);
  - the house style's colours;
  - any colour, by picker or hex code;
  - **Default**, which puts it back to the house style.
- A shape's text automatically turns light or dark so it stays readable on whatever fill is chosen. On a Transparent fill, it's readable on whatever lies behind (canvas or lane).
- A shape with a transparent fill and border still shows a faint outline while selected on the canvas, so it can be found and grabbed. The picture and exports don't show that outline.
- Colours apply to everything selected at once, and each change is one undoable step.
- Copy/paste keeps colours.

**What a reader sees**
- The reading view, PDF, Word and downloads show the chosen colours, including transparent fills and borders.
- In dark mode on screen, a chosen colour stays the same colour, and text stays readable on it. House-style defaults still follow the theme as now.

**Done when**
- Fill, Border and Line colours can be set on any shape or connection (one or several), including Transparent for Fill and Border, reset to Default, and are kept after Done, publishing and reopening.
- Shape text is always readable on its fill, including Transparent.
- A fully transparent shape can still be seen and selected on the canvas.
- Colours show in the reading view (light and dark), PDF, Word and downloads.
- Compare versions mentions a colour change in words (e.g. "Step 'Approve' fill changed").
- Tests cover setting, resetting, Transparent, multi-select and text contrast.

Independent unless the stored chart needs a new field the server must accept (then on the chain).