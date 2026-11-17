---
id: 01M7NVVC1D5CRMTPGPX65THYMX
created: 2026-11-17T23:00:39.597853Z
updated: 2026-11-17T23:02:01.954233Z
type: task
title: 'The Library page: shelves of folders and document cards, in Overview'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1918
sprint: s2q1gxe
assignee: steve
label:
- feature
priority: medium
task_status: todo
---
The Library page people browse, as in the design (https://claude.ai/artifact/8BsVjexM7NQXS4qRX23XJ7, Library page, "4a"), built on COM-1916 folders and COM-1917 summaries. Search is COM-1920 and the reading pane COM-1921. Until they land, this page has no search box, and clicking a card opens the document in Content.

**Where it is**
- **Library** in the **Overview** group of the Compass menu (Steve, 2026-11-17), with a book icon. The trail reads Overview › Library, then the folder path. Find a page finds it. Anyone who can see Content sees it.

**The Library's home**
- A calm heading: book icon, **Library**, and "Every policy, standard, procedure, runbook and decision — 24 documents in 19 folders."
- **Type chips**: All, then one per Content type that has published documents (Policies, Standards, Procedures, Runbooks…) and Decisions, each with its count and its colour dot. Picking one shows **All policies** as cards. Picking it again goes back to All.
- **Browse**: the top-level folders as cards in a grid, each with its icon on its colour, name, description, and "12 documents · 3 folders". A document counts once, however many subfolders it's in.
- **Not in a folder** appears as the last card, only when there are documents in no folder.

**A folder**
- Folder path as links ("Library › Information security"), then the folder's icon, name, description and "9 documents, 3 folders".
- **Folders**: its subfolders as cards, then **Documents**: the documents filed directly in it, as cards. The type chips work here too, counting this folder's documents.
- A **document card** shows its type (icon and colour), title, summary (two lines at most), "Reviewed Mar 2026" and, when it's in more than one folder, **In 3 folders**, whose tooltip lists each path.
- An empty folder says "No documents in this folder." (or "No policies in this folder." with a chip picked).

**Feel**
- Esc goes up one level. The folder and the chip are in the address, so Back works and a link opens the same place.
- Light and dark, both themes from the design's colours mapped to Compass's own (no fixed shades for text).
- Phone width: cards stack one per row and nothing pushes the page sideways.
- Folders show in their chosen order. Documents show by title.

**Done when**
- The menu has Library in Overview, and the home, folders, chips, cards, In N folders, Not in a folder and empty folder all work as above.
- Drafts and unpublished documents never appear. A document with unpublished changes shows its published title and summary.
- Phone width has no sideways scroll; Browser smoke covers the page for each test account.

Independent (after COM-1916 and COM-1917): screen only, no migration or API change.