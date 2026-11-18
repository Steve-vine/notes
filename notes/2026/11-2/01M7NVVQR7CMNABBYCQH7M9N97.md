---
id: 01M7NVVQR7CMNABBYCQH7M9N97
created: 2026-11-17T23:00:51.591142Z
updated: 2026-11-18T10:26:29.770868Z
type: task
title: 'Arranging the Library: new folder, rename, move, reorder, delete, and filing documents from the page'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1919
sprint: s2q1gxe
blocked_by:
- 01M7NVVC1D5CRMTPGPX65THYMX
comments:
- id: 01M7Q333YZYXDR5BWBTPTWYBX5
  author: Steve Vine
  at: 2026-11-18T10:26:27.935508Z
  text: |-
    Done: merged as PR #1925 (4a3bcc0e). All PR checks passed. The change is screen-only and uses COM-1916's API.

    What a Content editor can now do on the Library page. Readers see none of these controls, and the API refuses them.
    - **New folder** (top right): name, description, icon, colour. It's made inside the folder you're in, or at the top level on the home.
    - **Folder card menu:**
      - **Edit…** changes the name, description, icon or colour.
      - **Move to…** shows the folder tree with a find box. The folder itself and its own folders are greyed out ("This folder" / "Inside it"), and "Top of the Library" is offered first.
      - **Move up / Move down** are disabled at the ends.
      - **Delete…** asks first, with COM-1916's wording, leaving out parts that are zero.
    - **Document card menu:**
      - **Add to another folder…** files it in several at once. Folders it's already in show ticked. It reads "Add to a folder…" when the document is in none.
      - **Remove from this folder** asks first when it's the document's last folder.
      - **Open in Content**, or Open in Decisions for a decision.
    - **Not in a folder:** tick documents (or Choose all), then **Add to folder…** files them in one go.
    - **Drag:**
      - Drop a folder card on the edge of another to reorder, or in its middle to move it inside.
      - Drop a document card on a folder to file it there too. It always means "also here", never "move".
      - Keyboard users get all of this through the menus.
    - **After a change:** the page updates with a short confirmation ("Added to People"). Filing, unfiling, moving and reordering have Undo for 6 seconds. Delete has none, because it asked first.
      - If the server refuses (a name already used, or a move into its own folder), its reason shows in the dialog and what was typed is kept.
    - **Phone width:** checked in a browser at 1440px and 390px, light and dark. No sideways scroll, and menus and dialogs fit.
    - **Activity log:** each change is recorded as in COM-1916.
    - **Browser smoke:** a new journey has Admin A make a Library folder, rename it and delete it. It clears up anything a failed run left behind.

    Choices made, for Steve to overturn:
    - Undo lasts 6 seconds. New folder and Edit have no Undo.
    - Dragging by touch doesn't work on phones (a browser limitation), so the menus do the job there.
    - Search results have no arranging controls.
assignee: steve
label:
- feature
priority: medium
task_status: review
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