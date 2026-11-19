---
id: 01M7TM1MKB51ESVG1W53R2NB2C
created: 2026-11-19T19:20:28.523789Z
updated: 2026-11-19T19:20:42.28695Z
type: task
title: Move a document to another folder, so it stops showing in the folder it was in
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1990
sprint: s2q1gxe
blocked_by:
- 01M7TKNHRGFXKMJHE4WQF796A8
assignee: steve
label:
- improvement
priority: medium
task_status: backlog
---
Steve, testing the Library on staging (19 Nov): add the ability to move documents, so they stop showing in the previous folder. This sits with Add items (COM-1989).

**Today:** putting a document in a folder always adds it there. It stays in every folder it was already in, by "Add to another folder…", a drag onto a folder card, ticking under "Not in a folder", or (with COM-1989) Add items. To take it out of the old folder you then use "Remove from this folder" as a second step.

**What a person sees**
- **A document card's menu, in a folder you made:** a new **Move to…** below "Add to another folder…". It opens the same folder picker. The document is filed in the folder you pick and leaves the folder you're in, in one step. Any other folders it's in are left alone.
- **Add items (COM-1989):** under the Documents list, a choice between:
  - **Add here.** This is the default. Documents stay in their other folders too, as COM-1989 says.
  - **Move here.** Ticked documents are taken out of every other folder you made that they're in, and show only here.
  - The button reads **Move 12 items** when Move here is chosen. Each ticked row that's in other folders shows them ("Also in: Access, Onboarding"), so you see what it'll leave.
  - Folders always move, as before.
- **Afterwards:** the folder it left no longer shows it, at once. A note says what happened ("Moved 'Access Control Policy' to Policies"), with **Undo** for a few seconds. Undo puts it back in every folder it left. Each change is in the activity log.
- **Its domain folder is never left.** A document always shows in its domain's folder (ADR 0162). Moving only ever takes it out of folders people made.

**Choices, for Steve to overturn**
- Dragging a document card onto a folder still adds rather than moves, as now. Only Move to… and Add items' Move here move.
- Move to… is offered only inside a folder you made: there's a "from" to leave. In a domain folder, "Not in a folder" or search results the card keeps "Add to another folder…" only. From "Not in a folder", adding and moving are the same thing.
- Move here in Add items takes a document out of **all** its other folders, not just one, so afterwards it shows only here (and in its domain).
- A viewer sees none of this, like the rest of arranging.

**Done when**
- In folder A, a document card's Move to… → folder B: the document shows in B and no longer in A. If it was also in C, it's still in C. It's still in its domain folder. Undo puts it back in A.
- In Add items with Move here, ticking 3 documents that are in other folders → Move 3 items: all 3 show only in this folder (plus their domain folders). Undo restores every folder they left.
- With Add here (the default), behaviour is exactly as COM-1989.
- The document's Folders field in Content and the reading pane show the new folders after a move.
- Tests: backend for a move (leaves the named folders, never the domain folder, all or nothing) and frontend for Move to… and the Add items choice. The e2e Library crawl still passes.

**On the chain:** this is expected to extend COM-1989's API change, adding several at once with "move" as an option. No migration. Builds on COM-1989.