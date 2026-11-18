---
id: 01M7NVTFQK1D8GQT8YYW64EJ5B
created: 2026-11-17T23:00:10.611455Z
updated: 2026-11-18T12:59:37.2147Z
type: task
title: 'Library folders: nest to any depth, a document in several at once, one folder per domain to start'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1916
sprint: s2q1gxe
blocked_by:
- 01M7NVT18A9XKSN7SVA7W6RFDR
comments:
- id: 01M7PXDZ44A855E6EQAA0SJN3W
  author: Steve Vine
  at: 2026-11-18T08:47:31.972692Z
  text: |-
    Done: merged as PR #1915 (c9153ba5). All nine PR checks passed first time.

    What a person can do now:
    - People who can edit Content can create, nest, rename, re-describe, change the icon and colour of, move, reorder and delete folders. For now this is through the API; the Library page comes in COM-1918 and its arranging controls in COM-1919.
    - Names must be unique among siblings, ignoring case.
    - Moving a folder inside itself or one of its own folders is refused with "A folder can't go inside itself or one of its own folders".
    - Deleting a folder takes its subfolders but never a document. Before deleting, Compass reports how many folders go, how many documents stay in their other folders, and how many will be Not in a folder.
    - A document's page in Content and a decision's page have a new Folders field. It shows each folder's full path ("Information security › Access & identity"). People who can edit Content add folders with a searchable list of the whole tree and remove them with ×.
    - Deleting a document in Content takes it out of every folder.
    - Every folder change and every filing is in the activity log. Polaris changes will show "via Polaris" automatically.

    Day one: the migration makes one top-level folder per domain, in the domains' order, named and described after it. It files every document that has a domain under that domain's folder.
    - Each folder's icon comes from its domain (Access is a lock, Incident management a siren, and so on).
    - Each folder's colour comes from the domain's function (govern violet, identify blue, protect teal, detect amber, respond orange, recover pink).
    - Disabled domains get a folder too. Only deleted domains are skipped.
    - Decisions, and documents with no domain, start in Not in a folder.

    Choices made, for Steve to overturn:
    - Folder paths show as plain lines with a remove ×, not pills. A pill can't cut a long path short, and it would overflow the side column.
    - Drafts and proposed decisions can be filed. The Library won't show them until they're published or accepted.
    - Folder counts and the delete wording count only what the Library shows.
    - There are 26 folder icons (Phosphor, Compass's icon set), so every domain gets a fitting one.

    Checks: unit suite, integration tests for folders and their migration, content and decisions, a migration up/down test, type checks, lint, vitest and the OpenAPI drift check all pass.
- id: 01M7QBVHVY80MCKSNVP2EN87ND
  author: Steve Vine
  at: 2026-11-18T12:59:37.214518Z
  text: |-
    Pre-UAT (staging build c15afb4d, E2E Test Company, E2E Admin A and E2E Viewer): **Passed**

    Steps and what was seen:
    - **Day one:** the Library has 24 top-level folders, one per domain, with the same names in the same order as the domains. Each folder's document count matches the published documents filed in it. 16 documents are Not in a folder: the decisions, and the test documents from other sprints. People Security is empty.
    - **On the Library page, as Admin A:**
      - Made E2E folders at the top and inside each other, renamed one, moved one into another (three levels deep), reordered with Move up/down, and deleted a folder with everything in it.
      - A second folder with the same name in the same place is refused ("There's already a folder called … in …").
      - Moving a folder into itself or its own subfolder is refused ("A folder can't go inside itself or one of its own folders").
    - **Filing from Content:**
      - A document was filed in two folders from its page; the Folders field shows full paths ("E2E pre-UAT Beta › E2E pre-UAT Alpha › …").
      - A decision (DEC-10) was filed in two folders from its own page, and each path has a remove button.
    - **Deleting a folder:**
      - Before deleting, the preview counts were right: a document filed twice counted once, documents staying in other folders counted, and documents becoming Not in a folder counted.
      - Afterwards, documents are back in their other folders or Not in a folder; none was deleted.
    - **Viewer:** every folder and filing change is refused (403).
    - **Activity log:** each change is recorded with before and after:
      - folder created with its path;
      - renamed (Name: old → new);
      - moved (Parent: — → …);
      - reordered;
      - deleted ("…and the 3 folders inside it — 3 documents are now Not in a folder");
      - filed ("filed … in …") and removed ("took … out of …").

    Screenshots: ~/compass-uat/library/COM-1916/01–06.

    Everything made for the test was deleted. Staging is back to 57 documents in 24 folders, with 16 Not in a folder.
assignee: steve
label:
- feature
priority: medium
task_status: review
---
The foundation of the Library: folders, and which documents sit in them. Built to COM-1915 (ADR 0161). No Library page yet (COM-1918 adds it). This task makes folders exist and lets people file documents from Content.

**A folder**
- Has a name, a short description, an icon and a colour (picked from a small set, as in the design: violet, blue, teal, orange, pink, amber). It can sit inside another folder, to any depth. Folders at the same level have an order that people choose.
- Names are unique among siblings ("Access & identity" can appear under two different parents, but not twice under one).
- Shared by every company, like Content.

**Filing**
- A published document (any Content type) or an accepted decision record can be in any number of folders. It's one document shown in each, never a copy.
- A document's page in Content gets a **Folders** field listing where it sits, with each folder's full path ("Information security › Access & identity"), so an author can add or remove folders from there.
- A decision record's page gets the same field.
- A document in no folder is **Not in a folder**.
- Deleting a document in Content takes it out of every folder. A document that's withdrawn or goes back to draft stays filed but isn't shown until it's published again.

**Who can do what**
- Anyone who can edit Content can create, rename, describe, recolour, move, reorder and delete folders, and file or unfile documents. Everyone who can see Content can see folders.
- Deleting a folder asks first and says what goes with it: "Delete Information security? Its 3 folders go too. 12 documents stay in their other folders. 4 will be Not in a folder." No document is ever deleted.
- Moving a folder into one of its own subfolders is refused, with the reason.
- Every change (folder created, renamed, moved, deleted; document filed or unfiled) is in the activity log, with who did it.

**Day one**
- When this ships, Compass makes one folder per domain, named and described after it, in the domains' order, and files every document under its domain's folder. Documents with no domain are Not in a folder. This happens once: later domain changes don't touch folders.

**Done when**
- Folders can be created, nested, renamed, moved, reordered and deleted, with the rules above.
- A document and a decision can be filed in several folders from their page in Content, and the field shows full paths.
- After deploy, staging has one folder per domain with documents filed by domain.
- Activity log shows each change.

On the chain: adds a migration (folders, filing, day-one folders) and API for folders and filing.