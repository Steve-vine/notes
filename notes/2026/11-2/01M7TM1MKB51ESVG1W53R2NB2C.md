---
id: 01M7TM1MKB51ESVG1W53R2NB2C
created: 2026-11-19T19:20:28.523789Z
updated: 2026-11-19T22:14:44.841511Z
type: task
title: Move a document to another folder, so it stops showing in the folder it was in
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1990
sprint: s2q1gxe
blocked_by:
- 01M7TKNHRGFXKMJHE4WQF796A8
comments:
- id: 01M7TY0NZ378VFBM1NY9H69AZB
  author: Steve Vine
  at: 2026-11-19T22:14:42.915171Z
  text: |-
    Merged: PR #1985, e9c644cf.

    What changed:
    - Move to… on a document card. Inside a folder people made, the card's menu now has Move to… under "Add to another folder…". It opens the folder picker, with the note "It leaves <this folder>. Any other folders it's in keep it." The current folder shows as "Where it is now" and folders the document is already in show as "Already in it". The move is one step: the document goes into the folder you pick and leaves the one you're in. Its other folders and its domain's folder stay as they were. A note then says "Moved 'Access Control Policy' to People", with Undo, which puts it back.
    - Add here or Move here in Add items. Under the lists, "Documents you add" offers Add here (the default, as in COM-1989) or Move here.
      - Move here takes each ticked document out of every other folder people made. It then shows only here and in its domain's folder.
      - A ticked row says where else the document is ("Also in: …"), and the button reads "Move N items".
      - Folders always move.
      - A note then says "Moved 3 documents and 2 folders here", with Undo, which puts every folder back.
    - Every change goes in the activity log. The document's Folders field in Content and the reading pane show the new folders straight away.

    Assumptions for Steve:
    - Dragging a card onto a folder still adds rather than moves, as the task's choices say.
    - Move to… appears only inside a folder people made, and only on a document filed there. A domain folder, Not in a folder and search results keep only "Add to another folder…".
    - The Add/Move choice sits under the lists, so it's always in view.

    API: POST /library/folders/{id}/items gains move_documents and from_folder_id, and the response adds documents_left. A document never leaves its domain's folder. No migration.
assignee: steve
label:
- improvement
priority: medium
task_status: review
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