---
id: 01M7TR2XBZ9N12RDK7CS7FQE5Q
created: 2026-11-19T20:31:04.575288Z
updated: 2026-11-19T22:42:34.578855Z
type: task
title: One click selects a flowchart in a document; double-click opens it for editing, as drawings do
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2001
sprint: s6y6p7g
comments:
- id: 01M7TZKK39FQKZGWBNRR94KSFQ
  author: Steve Vine
  at: 2026-11-19T22:42:31.145467Z
  text: |-
    Done — PR #1999, merged 5cd97971.
    One click on a flowchart in the document editor now only selects it, as a picture or drawing: an outline, the corner handle and its settings panel. The flowchart editor doesn't open.
    Double-click it, press Enter while it's selected, or press Edit flowchart in its panel to open it.
    Selected, the usual keys work on it: Delete or Backspace removes it (one Undo), copy, cut and paste, and the arrow keys move past it.
    A standalone flowchart shown in the document opens on its own page's Edit tab (the document's typing is saved first) for someone who can edit it; anyone else only selects it, and the panel offers Open flowchart.
    Links under a flowchart and its caption work as before; the Read tab is unchanged.
    Assumption: a standalone flowchart can't be edited inside the document, so double-click takes you to its own page in the same tab.
    To check on staging: click, double-click and press Enter on a document's own flowchart and on a standalone one; select one and press Delete, then Undo.
assignee: steve
label:
- improvement
priority: high
task_status: review
---
Steve's smoke test of round 2: in the document editor, clicking a flowchart opens it straight in the flowchart editor, so a flowchart can't be selected without editing it. It should work like drawings do today: one click selects, double-click edits.

**Done when**
- One click on a flowchart in the document editor selects it, the way a picture or drawing is selected:
  - an outline shows round it;
  - the corner resize handle appears (COM-1998);
  - its settings show in the floating panel (COM-1999).
  The flowchart editor doesn't open.
- Double-clicking the flowchart opens the flowchart editor. So does pressing Enter while it's selected, or an "Edit flowchart" button in its settings panel.
- With a flowchart selected, the usual document keys work on it as on a picture:
  - Delete or Backspace removes it from the document, as one Undo step;
  - Ctrl C / Ctrl X / Ctrl V copy, cut and paste it;
  - the arrow keys move the cursor past it.
- Clicking a Link under a flowchart, or its caption, does what it does today and doesn't open the editor.
- The same applies to a standalone flowchart shown in a document. Double-click opens it for editing if the person can edit it. Otherwise it only selects, and the panel offers "Open flowchart".
- The Read tab is unchanged: clicking a flowchart there doesn't edit it.
- Tests cover one click selecting without opening, double-click and Enter opening, and Delete removing a selected flowchart.

Relates to:
- COM-1997 (corner resize handle);
- COM-1998 (flowchart sizing);
- COM-1999 (settings panel).

Independent: frontend document editor only.