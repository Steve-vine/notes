---
id: 01M7NVVC1D5CRMTPGPX65THYMX
created: 2026-11-17T23:00:39.597853Z
updated: 2026-11-18T17:25:11.818447Z
type: task
title: 'The Library page: shelves of folders and document cards, in Overview'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1918
sprint: s2q1gxe
blocked_by:
- 01M7NVTFQK1D8GQT8YYW64EJ5B
- 01M7NVTSYDM1W80CQ23GEHGPZS
comments:
- id: 01M7Q0AF5DZPCSD8YQE9BDKAA4
  author: Steve Vine
  at: 2026-11-18T09:38:03.05359Z
  text: |-
    Done: merged as PR #1923 (1641fa8f). All required checks passed.

    What a person sees:
    - **Menu:** Library is in the Overview group after Reports, with a book icon, for anyone who can see Content. Find a page finds it.
    - **Home:** the heading with real counts ("… N documents in M folders").
      - Type chips: All, then each type that has published documents, plus Decisions, each with its count and colour dot. Picking one shows "All policies" as cards; picking it again goes back.
      - **Browse** shows the top-level folder cards ("12 documents · 3 folders"), with Not in a folder last, only when something is unfiled.
    - **A folder:** the path as links, then the folder's icon, name, description and counts.
      - Its subfolders appear as cards, then the documents filed directly in it.
      - The chips count this folder's documents.
      - Empty states read "No documents in this folder." or "No policies in this folder."
    - **Document cards:** type icon and colour, title, two lines of summary, "Reviewed Mar 2026", and "In 3 folders" with a tooltip listing each path. Clicking a card opens the document in Content (or the decision) until the reading pane lands (COM-1921).
    - **Published only:** drafts and proposed decisions never show. A document with unpublished changes shows its published title.
    - **Esc** goes up one level. The folder and chip are in the address, so links and Back work.
    - **Phone width:** one card per row, no sideways scroll. Checked in a browser at desktop and phone width, light and dark.
    - **Browser smoke:**
      - It now opens a folder, presses Esc, picks a chip and opens Not in a folder, for every account that sees Library.
      - The menu tests expect Library for Admin and Viewer.
      - The phone test checks the Library at 390px.
      - These steps run on the next staging deploy.

    Choices made, for Steve to overturn:
    1. Decisions are amber, as drawn in the design. Policy is violet, standard blue, procedure teal, runbook orange, and other types grey.
    2. Decision cards say "Decided Jan 2026". A document never reviewed says "Not reviewed yet".
    3. The trail reads "Library › Information security › …", without "Overview ›" in front. No other page shows its menu group in the trail, so this matches them.
    4. A folder card's "N folders" counts only the folders directly inside it, as the design does. Its document count covers everything inside.
    5. Changing a chip doesn't add a Back step, the same as other filters.

    Left for later tasks: Pick up where you left off and the reading pane (COM-1921), search (COM-1920), arranging (COM-1919). On a phone the home's chips wrap left-aligned rather than centred.
- id: 01M7QBVY0XDFV9DZMASZ04RHAQ
  author: Steve Vine
  at: 2026-11-18T12:59:49.660768Z
  text: |-
    Pre-UAT (staging build c15afb4d, E2E Test Company, E2E Admin A and E2E Viewer): **Passed**. One defect was found, raised as a new task: the home's "Try" suggestions came from a draft's tags, a COM-1920 fault.

    Steps and what was seen:
    - **Finding it:** Library is in the Overview group of the Compass menu, and Find a page ("libr") finds it. The Viewer sees it too.
    - **Home:** "Every policy, standard, procedure, runbook and decision — 57 documents in 24 folders." Type chips show their counts: Policies 36, Standards 2, Procedures 12, Runbooks 1, Decisions 6.
    - **Type chips:** picking Policies shows "All policies" (?type=policy). Picking it again goes back.
    - **Folder cards:** they show "N documents · N folders". Not in a folder (16) shows only when something is unfiled.
    - **Inside a folder:**
      - Path links work three levels deep.
      - Subfolders are listed under Folders, then the documents.
      - Document cards show type, title, summary, "Reviewed Mon YYYY" or "Not reviewed yet", and "In N folders" with a tooltip of paths.
      - An empty folder says "No documents in this folder."
    - **Drafts never show:** an E2E draft filed in two folders didn't appear in either and wasn't counted.
    - **Keys and navigation:** Esc goes up a level, and Back works. Dark mode looks right.
    - **Phone (390px):** one card per row, and the page is never wider than the screen (home, folders, search).
    - **Browser smoke** covers the page for every account (run 44303617632, 36/36).

    Notes for Steve:
    - Folder counts include documents in subfolders, so a folder can read "2 documents, 2 folders" while its own All chip reads 0.
    - Card headers use "·" and the folder heading uses ",".

    Screenshots: ~/compass-uat/library/COM-1918/01–14.
assignee: steve
label:
- feature
priority: medium
task_status: done
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