---
id: 01M7TNHX1MJP9DSWY8DZN3RKQX
created: 2026-11-19T19:46:50.036726Z
updated: 2026-11-19T19:46:56.743595Z
type: task
title: Remove the "How to build it" section from the flowchart editor's side panel
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1995
sprint: s6y6p7g
assignee: steve
label:
- improvement
priority: medium
task_status: todo
---
Steve's smoke test of round 2: remove the "How to build it" section and its instructions completely.

It sits in the right-hand panel under Lanes when nothing is selected. It holds:
- the "Add shapes from the bar above…" paragraph;
- the list of keys (Tab, Enter, A–Z, arrows, Alt+↑, Alt+drag, Shift+click, Ctrl C, Ctrl Z, Delete);
- the closing note about Groups.

**Done when**
- The heading, the paragraph, the list of keys and the Group note are all gone. Nothing replaces them in the panel.
- With nothing selected, the panel shows the rest as before (title, Lanes, Style), with no stray divider or gap where the section was.
- The keys themselves still work exactly as before; only the instructions go.
- Every flowchart editor is changed: a document's flowchart, a standalone flowchart and full screen.
- Tests and the Browser smoke no longer look for the section, and anything left unused once it's gone (such as the Hint helper) is removed.

Independent: frontend editor only.