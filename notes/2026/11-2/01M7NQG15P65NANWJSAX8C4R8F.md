---
id: 01M7NQG15P65NANWJSAX8C4R8F
created: 2026-11-17T21:44:33.718083Z
updated: 2026-11-17T21:45:33.375291Z
type: task
title: Turn a text diagram into a flowchart
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1913
sprint: s6y6p7g
blocked_by:
- 01M7NQC2KVK2HH9J55CGGSJ26F
assignee: steve
label:
- feature
priority: medium
task_status: todo
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