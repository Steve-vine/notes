---
id: 01M7TQAW38G2CXB9E4RHH6DK12
created: 2026-11-19T20:17:56.840704Z
updated: 2026-11-19T21:46:27.703454Z
type: task
title: A picture's or diagram's settings open in a fixed floating panel on the right, readable with "Show as on paper"
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1999
sprint: s6y6p7g
comments:
- id: 01M7TWCYFQS3R0BYN2V59K59RT
  author: Steve Vine
  at: 2026-11-19T21:46:27.703226Z
  text: |-
    Done — PR #1991, merged 0a3d9bcf.
    Selecting a picture now opens its settings in a floating panel of one size at the right-hand edge of the window, headed Picture, Drawing, Diagram or Flowchart, with a close button. The box under the picture is gone, so nothing in the document moves when the panel opens or closes.
    It holds what the box did: alignment, caption, and alt text (a picture), Change the drawing (a drawing), or the diagram's text, alignment, caption and Turn into a flowchart (a text diagram). A flowchart's panel has Edit flowchart, Make it a standalone flowchart and Remove; its alignment and caption join them with COM-1998/2004.
    The panel always uses the app's own colours, so it reads well with "Show as on paper" on or off, light or dark. It sits at the top right, or the bottom right when the top would cover the picture; on a narrow window it runs along the bottom and the page scrolls the picture clear of it.
    It follows the selection. The close button, Escape or a click outside the document close it. Tab from a selected picture moves into the panel. Each change applies at once and is one Undo step, even when made quickly one after another.
    Assumption: "far right of the editor" is the window's right-hand edge, under the top bar.
    To check on staging: select an image, a drawing, a text diagram and a flowchart, with "Show as on paper" on in dark mode; check the text doesn't move, and try a narrow window.
assignee: steve
label:
- improvement
priority: high
task_status: active
---
Steve's smoke test of round 2: in the document editor, clicking an image or diagram opens a box under it. The box holds the alignment, the caption, and either the alt text or "Change the drawing".

It has three problems:
- With "Show as on paper" on, the box keeps the app's colours on the paper's background, so it's unreadable.
- Opening it pushes everything below the picture down the page.
- It doesn't display well under a small picture.

Move these settings into a fixed-size floating panel on the far right instead.

**Done when**
- Selecting a picture opens its settings in a floating panel of a fixed size, docked to the far right of the editor. That covers an uploaded image, a drawing (Excalidraw), a text diagram (DiagramView) and a flowchart in the document.
- The panel holds what the box under the picture holds today:
  - alignment;
  - caption;
  - alt text, "Change the drawing", or the diagram's own settings, depending on the kind.
  For a flowchart it holds alignment and caption once COM-1998 adds them.
- Nothing in the document moves when the panel opens or closes. The box under the picture is gone.
- The panel looks the same whatever the picture's size or alignment. It doesn't cover the selected picture or the text being typed in, and on a narrow window it still fits without hiding the picture.
- The panel is readable with "Show as on paper" on and off, in light and dark mode. It uses the app's own panel colours and never inherits the paper's.
- It follows the selection: selecting another picture shows that one's settings. Clicking away or pressing Escape closes it. Typing in the caption or alt text never moves the cursor into the document.
- Changes apply to the picture at once and are one Undo step each, as now.
- It works from the keyboard. The panel has a heading saying which picture it's for (e.g. "Picture" / "Drawing" / "Diagram" / "Flowchart") and a close button.
- Tests cover the panel opening for each kind, the document not moving, and readable colours with "Show as on paper" on in dark mode.

Relates to COM-1997, the corner resize handle, which stays on the picture.

Independent: frontend document editor only.