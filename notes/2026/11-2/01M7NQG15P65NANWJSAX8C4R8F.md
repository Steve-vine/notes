---
id: 01M7NQG15P65NANWJSAX8C4R8F
created: 2026-11-17T21:44:33.718083Z
updated: 2026-11-18T05:03:15.192068Z
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
assignee: steve
label:
- feature
priority: medium
task_status: review
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