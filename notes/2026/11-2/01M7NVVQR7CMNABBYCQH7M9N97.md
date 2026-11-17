---
id: 01M7NVVQR7CMNABBYCQH7M9N97
created: 2026-11-17T23:00:51.591142Z
updated: 2026-11-17T23:02:22.046584Z
type: task
title: 'Arranging the Library: new folder, rename, move, reorder, delete, and filing documents from the page'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1919
sprint: s2q1gxe
blocked_by:
- 01M7NVVC1D5CRMTPGPX65THYMX
assignee: steve
label:
- feature
priority: medium
task_status: todo
---
People who can edit Content arrange the Library on the Library page itself, using the rules from COM-1916. Readers see none of these controls.

**On the home or in a folder**
- **New folder** (top right): name, description, icon, colour. It's made inside the folder you're in (or at the top level on the home).
- Each folder card has a menu: **Edit** (name, description, icon, colour), **Move to…** (a folder picker showing the tree, refusing the folder itself and its subfolders), **Move up / Move down** among its siblings, and **Delete**, which asks first and says what goes with it (COM-1916 wording).
- Folder cards can also be dragged to reorder them, or dropped on another folder card to move inside it. Keyboard users get the same through the menu.

**Filing documents**
- Each document card has a menu: **Add to another folder…** (folder picker, several at once), **Remove from this folder** and **Open in Content**.
- **Remove from this folder** on the document's last folder says it will be Not in a folder, and asks first.
- Inside **Not in a folder**, a writer can tick several documents and **Add to folder…** in one go, so filing a backlog is quick.
- A document card can be dragged onto a folder card to add it there too. Dragging a document always means "also here", never "move": it stays where it was.

**After a change**
- The page updates straight away, with a short confirmation ("Added to Incident response"), and Undo for a few seconds where the change can be undone (filing, unfiling, moving, reordering). Delete has no Undo: it asked first.

**Done when**
- A Content editor can do every action above from the Library page, by mouse and by keyboard.
- A reader (can see Content, can't edit it) sees no arranging controls, and the API refuses them.
- Activity log shows each change, as COM-1916.
- Phone width: menus and pickers fit, no sideways scroll.

Independent (after COM-1918): screen only, uses COM-1916's API.