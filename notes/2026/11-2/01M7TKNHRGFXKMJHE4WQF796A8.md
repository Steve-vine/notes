---
id: 01M7TKNHRGFXKMJHE4WQF796A8
created: 2026-11-19T19:13:52.40018Z
updated: 2026-11-19T20:31:43.223398Z
type: task
title: 'A folder''s "Add items" button: pick several existing folders and documents and add them to this folder in one go'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1989
sprint: s2q1gxe
blocked_by:
- 01M7TJT0NV5ZX7ACR938EPSGYV
assignee: steve
label:
- improvement
priority: medium
task_status: active
---
Steve, testing the Library on staging (19 Nov): in the folder view, add a new button to the right of New folder called Add items. Clicking it lets you add existing folders and documents into this folder, picking several at once.

**Today:** to put things into a folder you go to each item. A document's "Add to another folder…" (or a drag onto a folder card) files one document. A folder's "Move to…" (or a drag) moves one folder. Under "Not in a folder" you can tick several documents and file them together, but only from there and only documents.

**What a person sees**
- **The button:** in a folder you made, the header shows New folder, then **Add items** to its right. It's shown to the same people who see New folder (anyone who can arrange the Library). A viewer doesn't see it.
- **The dialog, "Add items to <folder name>":**
  - A search box at the top filters as you type, by name and, for documents, reference.
  - Below it, two lists. **Folders** shows every folder you made, with where it sits (e.g. "Policies ▸ Access"). **Documents** shows every published document and decision record, with its type chip and its domain.
  - Each row has a tick box. Tick as many as you like, across both lists and across searches; the ticks are kept as you search.
  - A line at the foot says what's ticked ("3 folders and 12 documents"). The button reads **Add 15 items**, and it's disabled while nothing is ticked.
  - Rows that can't be added show why, untickable:
    - "Already here": a document already in this folder, or a folder already directly inside it.
    - "This folder": the folder itself.
    - "Holds this folder": a folder this one sits inside, which can't go into its own subfolder.
  - Domain folders aren't listed. They stay in Domains and follow their domain (ADR 0162).
- **What adding does:**
  - **A document is filed here too.** It stays in every folder it was already in, and in its domain folder, the same as "Add to another folder…".
  - **A folder moves here,** with everything in it. A folder lives in one place, so it leaves where it was, the same as "Move to…". It goes after this folder's existing subfolders, in the order ticked.
- **Afterwards:** the dialog closes and the folder shows the new items at once. A note says what happened ("Added 12 documents and moved 3 folders here"), with **Undo** for a few seconds. Undo puts every item back where it was, the same as the Library's other arranging. Every change is in the activity log.
- **Not offered** on the home, in a domain folder, in "Not in a folder" or in search results. Those have no New folder, and the button belongs with it.

**Choices, for Steve to overturn**
- Adding a folder **moves** it (it can't be in two places). The dialog says so under the Folders list: "A folder you add moves here, with everything in it."
- One dialog with Folders and Documents lists and a search box, rather than a folder-tree browser. A tree is slower for picking many documents from different places.
- Decision records can be added like any document.
- On a phone the dialog fills the screen, and the button sits beside New folder as an icon with the "Add items" tooltip if the header is too narrow for both labels.

**Done when**
- As an editor in a folder you made: Add items is right of New folder. Ticking 2 folders and 5 documents, including some ticked under one search and some under another, then Add 7 items, puts all 7 in the folder. The 5 documents are still in their other folders. The 2 folders have left their old place and kept their contents.
- The folder itself, folders it sits inside, and things already in it can't be ticked, and each says why. Domain folders aren't offered.
- Undo puts every item back exactly. The activity log shows each change.
- A viewer sees no Add items. It's not on the home, a domain folder, Not in a folder or search results.
- Keyboard: the dialog can be worked without a mouse (search, tick, Add), and Esc cancels. No sideways scroll on a phone.
- Tests: backend for adding several at once (all or nothing, including the refusals above) and frontend for the dialog. The e2e Library crawl still passes.

**On the chain:** this is expected to need one API change, to add several items to a folder in one go so it succeeds or fails as a whole. No migration.