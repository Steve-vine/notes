---
id: 01M7NQG15P65NANWJSAX8C4R8F
created: 2026-11-17T21:44:33.718083Z
updated: 2026-11-19T18:45:28.620685Z
type: task
title: Turn a text diagram into a flowchart
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1913
sprint: s6y6p7g
blocked_by:
- 01M7NQC2KVK2HH9J55CGGSJ26F
comments:
- id: 01M7PGK6FPWE83XRVJ0D52QWAH
  author: Steve Vine
  at: 2026-11-18T05:03:11.862075Z
  text: |-
    Done — PR #1909, merged 92c0142.
    In a document's editor, select a text diagram that is a flowchart and its panel now has Turn into a flowchart. Sequence, timeline and other kinds of text diagram don't offer it.
    It shows the flowchart it will become with the same summary as the imports: "N shapes, N connections, N lanes will come across", what needs a look, and what doesn't come across (styling, click actions, comments; unusual shapes come in as Steps and are listed).
    Groups become lanes; a step in no group goes into "Not in a lane". Decisions, labelled connections and the way arrows point come across. The text has no positions, so Tidy up lays it out.
    Convert puts the flowchart in the text diagram's place in the draft (keeping its caption); Undo in the editor brings the text diagram back. Cancel leaves it as it was.
    Assumption: diagrams drawn right to left or bottom to top come in left to right / top to bottom, and the summary says so.
    To check on staging: insert a Text diagram, select it, Turn into a flowchart, Convert, then Undo.
- id: 01M7PVF2G0BVJMS76AH4QD34C3
  author: Steve Vine
  at: 2026-11-18T08:13:11.040696Z
  text: |-
    Pre-UAT on staging faf46f33 — Passed
    As E2E Admin A in E2E Test Company, on "E2E pre-UAT COM-1913 Text diagram".
    - The text flowchart I used: flowchart TB, with subgraphs Service Desk (Ticket raised([ ]) → Triage → Known fix?{ }) and Engineering (Investigate → Fix record[/ /]), C -->|Yes| Apply the fix, C -->|No| Investigate, two edges into Closed(( )), plus a %% comment, a click action and a style line.
    - Same steps, branches and lanes: Turn into a flowchart showed "7 shapes, 7 connections, 2 lanes will come across". Under "Came in, but check": "Apply the fix" and "Closed" put in "Not in a lane" (they're outside both groups). Under "What didn't come across": the comment, the click action on B, and colours and styling. After Convert, the plain text reads: Service Desk: Ticket raised → Triage the ticket → Known fix? No → 4; Yes → 7; Engineering: Investigate → Fix record → Closed; Not in a lane: Apply the fix → Closed. Shapes: stadium → Start/End, rhombus → Decision, parallelogram → Input/Output, circle → Start/End. The caption was kept. Passed.
    - A sequence diagram, selected, has no Turn into a flowchart. Passed.
    - Cancel and Undo: Cancel left the text diagram. After Convert, the editor's Undo brought the text diagram back with its text exactly as written. Passed.
    Observation (worth a look): in the preview and on the canvas, the Yes connection (Known fix? → Apply the fix) runs underneath the Investigate step and its "Yes" label can't be seen. The picture reads as if Investigate leads to Apply the fix; the steps in words are right. See 03b-convert-preview-zoom.png and 08-converted-canvas.png.
    Screenshots: ~/compass-uat/s6y6p7g/COM-1913/
assignee: steve
label:
- feature
priority: medium
task_status: done
---
Builds on COM-1905 (needs lanes). Steve, 2026-11-17: today's text diagrams can be brought onto the canvas. Text diagrams themselves stay (ADR 0160).

**What the author sees**
- In a document's editor, a text diagram that is a flowchart has **Turn into a flowchart** on its menu. Other kinds of text diagram (sequence, timeline, etc.) don't offer it.
- Compass shows what the flowchart will look like and the summary used by the imports (COM-1911/1912): its steps, decisions, connections and labels. Groups (subgraphs) become lanes. Anything that can't come across is listed (styling, click actions, unusual shapes come in as Steps). **Convert** replaces the text diagram with a flowchart in the draft, and **Cancel** leaves it.
- Undo in the editor brings the text diagram back until the draft is saved. After that, Compare versions and Revert work as for any change.
- Shape mapping: rectangle → Step, rhombus → Decision, stadium/circle → Start/End, document/parallelogram shapes → Document/Input/Output, comments are dropped and listed.

**Done when**
- A text flowchart with decisions, labelled connections and groups converts into a flowchart with the same steps, branches and lanes.
- A non-flowchart text diagram has no Turn into a flowchart.
- Cancel and editor undo leave the text diagram as it was.

Independent: done in the browser, so no API change. Branch from main after COM-1905 lands.