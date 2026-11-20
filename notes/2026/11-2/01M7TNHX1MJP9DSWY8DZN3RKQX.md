---
id: 01M7TNHX1MJP9DSWY8DZN3RKQX
created: 2026-11-19T19:46:50.036726Z
updated: 2026-11-20T14:05:05.10172Z
type: task
title: Remove the "How to build it" section from the flowchart editor's side panel
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1995
sprint: s6y6p7g
comments:
- id: 01M7TTXD44N04A2WW2M34E3SYS
  author: Steve Vine
  at: 2026-11-19T21:20:29.828702Z
  text: |-
    Done — PR #1986, merged b8733382.
    The flowchart editor's right-hand panel no longer has a "How to build it" section: the heading, the "Add shapes from the bar above…" paragraph, the list of keys and the note about Groups are gone.
    With nothing selected the panel now shows the caption (in a document) and Lanes, with no divider or gap left behind.
    Every key still works as before; only the instructions went. There is one editor, so a document's flowchart, a standalone flowchart and full screen all change together.
    To check on staging: open any flowchart with nothing selected and look at the right-hand panel.
- id: 01M7V3RTC2K3BMVN7V2NGF674X
  author: Steve Vine
  at: 2026-11-19T23:55:16.738344Z
  text: |-
    Pre-UAT on staging 7ea67f64 — Passed
    - Heading, paragraph, key list and Group note gone, nothing in their place: Passed. As E2E Admin A I opened the editor with nothing selected, on a standalone flowchart (E2E pre-UAT COM-1992 all shapes standalone) and on a document's own flowchart (E2E pre-UAT COM-1991 document flowchart). No "How to build it" anywhere.
    - Rest of the panel as before, no stray divider or gap: Passed. Standalone: Lanes only, starting at the top. Document: Caption, one divider, then Lanes. No gap at the bottom.
    - Keys still work: Passed. Tab added a connected step; typing straight after named it; Enter opened the label for editing; arrow keys moved the shape; Shift+click selected two; Ctrl+C then Ctrl+V pasted a copy; Delete removed it; Alt+↑ moved the selection to another shape; Ctrl+Z and Ctrl+Y undid and redid.
    - Every editor changed: Passed. A document's flowchart and a standalone flowchart both checked. There's only one editor and it fills the window; full screen in the reading view has no editor in it, so there's nothing separate to check there.
    - Tests and Browser smoke no longer look for the section; Hint helper removed: Passed. Nothing in the app or app/e2e at 7ea67f64 mentions "How to build it", and the flowchart Hint helper is gone. The only "Hint" left is the search box's own, which isn't related.
    Screenshots: ~/compass-uat/s6y6p7g/COM-1995/
assignee: steve
label:
- improvement
priority: medium
task_status: done
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