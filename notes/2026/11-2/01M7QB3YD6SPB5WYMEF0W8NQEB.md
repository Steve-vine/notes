---
id: 01M7QB3YD6SPB5WYMEF0W8NQEB
created: 2026-11-18T12:46:43.622843Z
updated: 2026-11-18T20:53:39.61544Z
type: task
title: 'Flowchart line styles: right-angled, straight or curved; arrows at either, both or no end; solid, dashed or dotted; line weight'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1944
sprint: s6y6p7g
comments:
- id: 01M7QTQ5WM8VYV3KK28PGXGWMG
  author: Steve Vine
  at: 2026-11-18T17:19:22.516841Z
  text: |-
    Done — PR #1946, merged 66fbb27e.
    With connections selected, the Style panel now has Route (Right-angled, Straight, Curved), Arrows (End, Start, Both, None), Line pattern (Solid, Dashed, Dotted) and Line weight (Thin, Normal, Thick), under Line colour.
    They apply to every selected connection, one undo step per change, and copy/paste keeps them. Tidy up keeps them.
    Right-angled lines keep their routing round steps and stay where they are when other shapes move. Straight and Curved go directly between the two steps (a curve leaves and arrives square to the sides), may cross a step if the shapes are placed that way, and their labels still sit clear of steps.
    The canvas, reading view, PDF, Word and downloads draw the same; arrowheads at either end are the same size on the canvas as in the picture.
    The steps in words, search and Polaris still follow who leads to whom. Arrows are drawing only. Compare versions says "line style changed".
    Assumptions: the weights are 1, 1.5 (today's) and 2.5 px, shared with borders. A line to or from a Note stays dashed with no arrow unless chosen otherwise.
    To check on staging: make one line Straight and one Curved with a label, try Both and None arrows and a dotted thick line, then publish and check the PDF and Word download.
- id: 01M7R6ZHMZD2A2MNYW05E07MMY
  author: Steve Vine
  at: 2026-11-18T20:53:39.615267Z
  text: |-
    Pre-UAT on staging cbacf0c2 — Passed
    Same flowchart as COM-1942: "E2E pre-UAT COM-1942 COM-1951 COM-1944 COM-1957 styles", as E2E Admin A in E2E Test Company.
    - Route, Arrows, pattern and weight on one or several connections, kept after Done, publishing and reopening: Passed. I made "Yes" Straight and "No" Curved, both labelled. "Record the approval → Send the reply" got Both arrows, Dotted, Thick and red. "Long step → End" got no arrows. "Start → Raise" and "Hand off → End", selected together, got a Start arrow, Dashed and Thin. One Undo took back only the weight, and Redo put it back. A copy and paste of two connected shapes kept the connection's colour, arrows, pattern and weight. The stored chart after publishing had exactly these values. A line to a Note defaults to dashed with no arrow.
    - The same on the canvas, reading view, PDF, Word and downloads: Passed (COM-1944/r2-01-canvas-lines.png, COM-1942/r2-05-read-light.png, r2-styles-v3.pdf, Word image, r2-dl-…png/.svg). Every arrow end, pattern and weight came out as set.
    - Right-angled lines keep their routing, and every label is visible on all three routes: Passed. The "Yes" (Straight) and "No" (Curved) labels sit clear of the steps. Tidy up kept every connection's route, arrows, pattern and weight (r2-02-after-tidy-up.png).
    - Meaning unchanged: Passed. The steps in words (reading view, plain-text export, compare) are the same as before styling. For example "Start → 2" stays as it was, even with the arrow drawn at the Start end.
    - Compare versions: Passed. It reads "line style changed" and "line colour and line style changed".
    Screenshots: ~/compass-uat/s6y6p7g/COM-1944/ and ~/compass-uat/s6y6p7g/COM-1942/
assignee: steve
label:
- improvement
priority: medium
task_status: review
---
Steve, testing on staging, 2026-11-18: more line styles are needed.

**What the author sees**
With one or more connections selected, the side panel offers:
- **Route:** Right-angled (today's, routed around steps), Straight, or Curved.
- **Arrows:** at the end (today's default), at the start, at both ends, or none.
- **Pattern:** Solid, Dashed or Dotted.
- **Weight:** Thin, Normal (today's) or Thick, about 1, 2 and 3.5 pt.
These sit with the Line colour from COM-1942. They apply to everything selected, each change is one undoable step, and copy/paste keeps them.

**How the routes behave**
- Right-angled keeps COM-1931/1935's rules: never through a step, never sharing a line or arrowhead.
- Straight and Curved go directly between the two shapes. They may cross a step if the author places shapes so. Their labels still sit clear of steps.
- Tidy up keeps each connection's chosen style.

**What a reader sees**
- The reading view, PDF, Word and downloads show every style, arrow, pattern and weight.

**Meaning**
- The flow's direction for plain text, search and Polaris still follows the connection's from → to.
- Arrows are drawing only: an arrow at both ends or none doesn't change the steps in words.
- Compare versions mentions a style change in words.

**Done when**
- Each option above can be set on one or several connections, is kept after Done, publishing and reopening, and shows identically on the canvas, in the reading view, PDF, Word and downloads.
- Right-angled lines keep their routing guarantees, and every label stays visible for all three routes.
- Tests cover each option and the plain-text steps staying the same.

Independent unless the stored chart needs new fields the server must accept (then on the chain). Shares the side panel with COM-1942.