---
id: 01M7TR2XBZ9N12RDK7CS7FQE5Q
created: 2026-11-19T20:31:04.575288Z
updated: 2026-11-20T14:05:05.149663Z
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
- id: 01M7V39RZ9SEACD4JS1JBWDPCM
  author: Steve Vine
  at: 2026-11-19T23:47:03.785527Z
  text: |-
    Pre-UAT on staging 7ea67f64 — Failed
    Tested as E2E Admin A, in "E2E pre-UAT COM-2001 select a flowchart" (a document's own 3-box flowchart), "E2E pre-UAT COM-1998 flowchart sizes" and "E2E pre-UAT COM-2003 zoom small and large" (both have a standalone shown in them).
    - One click selects: outline, corner handle and settings panel, and the flowchart editor doesn't open: Passed. A blue outline appears, the handle sits on the bottom-right corner, and the floating "Flowchart" panel shows (Edit flowchart, Left/Centre/Right/Full width, Caption, Alt text, Make it a standalone flowchart, Remove). The flowchart editor didn't open.
    - Double-click, Enter while selected, or "Edit flowchart" in the panel opens the flowchart editor: Passed, all three. Cancel closed it with the document unchanged.
    - Delete or Backspace removes it as one Undo step: Passed. Delete removed it and one Ctrl+Z brought it back; the same for Backspace.
    - Ctrl C / Ctrl X / Ctrl V copy, cut and paste it: FAILED. Copy, then paste: the pasted copy is a plain picture, not a flowchart. Clicking it opens the "Picture" panel (no Edit flowchart), and double-clicking it doesn't open the flowchart editor. Cut, then paste: the flowchart goes, and comes back as a picture too, so cut and paste loses the flowchart for good. The picture keeps the alt text "Flowchart: Select me, 3 steps" and the caption.
    - The arrow keys move the cursor past it: Passed. Selected, then ArrowDown or ArrowRight puts the cursor at the start of the next paragraph; ArrowUp or ArrowLeft puts it at the end of the one before. From the end of the paragraph before, ArrowRight selects the flowchart and a second ArrowRight goes past it.
    - Clicking a Link under a flowchart, or its caption, does what it does today and doesn't open the editor: Passed. Clicking the caption selects the flowchart (double-clicking the caption doesn't open the editor either). A step's link spot shows its links ("1. Large flow step 3 · E2E Starter"). A standalone's "…, version 1" link opens the standalone's page.
    - A standalone shown in a document: Passed for someone who can edit. One click selects it (Flowchart panel); double-click opens the standalone's own page on its Edit tab, the PR's stated assumption. "Only selects, and the panel offers Open flowchart" for someone who can't edit it: Couldn't check. Editing a document and editing a flowchart need the same permission, so no E2E account can edit the document but not the flowchart.
    - The Read tab is unchanged: Passed. Clicking and double-clicking a flowchart there opened nothing, with no panel or handle.
    - Tests: in the PR; not re-run here.
    Steve: select a flowchart in the editor, press Ctrl+C, then Ctrl+V somewhere else. The copy is a picture, not a flowchart. Seen in headless Chromium using the browser's own clipboard; worth repeating on your Mac.
    Screenshots: ~/compass-uat/s6y6p7g/COM-2001/ (r3-08-pasted-is-an-image.png for the defect)
- id: 01M7VAVEFYF6E1TC3KZXFWD61C
  author: Steve Vine
  at: 2026-11-20T01:59:02.910033Z
  text: |-
    Re-check on staging 0ed475e8 (after COM-2006): Ctrl C / Ctrl X / Ctrl V on a selected flowchart now Passed, within a document. A copied or cut flowchart pastes as a flowchart: the Flowchart panel shows, double-click opens it in the flowchart editor, and the lanes, size, alignment, caption and alt text are kept. Undo works.
    One gap remains, recorded on COM-2006: a flowchart pasted into another document has no saved picture until that document's Edit tab is opened again. Published straight away, its PDF says "Not yet drawn".
    Screenshots: ~/compass-uat/s6y6p7g/COM-2006/r3re-*
assignee: steve
label:
- improvement
priority: high
task_status: done
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