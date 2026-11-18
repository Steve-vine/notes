---
id: 01M7NVWGKPG8VCS53VSXD35S43
created: 2026-11-17T23:01:17.046332Z
updated: 2026-11-18T11:07:13.988234Z
type: task
title: 'Library reading pane: a document''s preview, where it appears, and pick up where you left off'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1921
sprint: s2q1gxe
blocked_by:
- 01M7NVW444FY5D01TE1FXS0NKV
comments:
- id: 01M7Q5DPKBGKWT9HH8VDD1J0WB
  author: Steve Vine
  at: 2026-11-18T11:07:11.851012Z
  text: |-
    Done: merged as PR #1929 (f7392419). All PR checks passed. One database change: Compass now remembers each person's recently opened documents.

    What a person can now do:
    - **Opening a document:** a plain click on a card or search result, or Enter in the search box, opens the document in a pane on the right instead of leaving the Library. Ctrl/cmd-click still opens its own page in a new tab.
    - **The pane shows:**
      - "Policy · Published v7", then the title and summary.
      - Four facts: Reviewers, Last reviewed, Version and Controls. A decision shows Status, Decided, Decided by and Linked to ("2 controls · 1 risk") instead.
      - "Appears in N folders", with the current one marked You are here. Each path goes to that folder.
      - Add to another folder, for Content editors, using the same picker as COM-1919.
      - Contents: numbered headings from the published version. A file, link or SharePoint document says what it is instead.
      - Its tags.
    - **The pane's footer:**
      - Read document, which goes to Content for now; the reader (COM-1922) takes this over.
      - Copy link: the link opens the pane on arrival, keeping the folder, chip and search.
      - Download PDF, or Download file for an uploaded Word or Excel file.
    - **Closing:** clicking outside, the close button, Esc or Back closes the pane. Esc over the Add dialog closes only the dialog.
    - **Pick up where you left off:** sits above Browse on the home and shows the person's last three documents. It's kept on the server, so it follows them to any browser. It's hidden until they've opened something, and documents that are unpublished or deleted drop off.
    - **Phone width:** the pane is full width, with no sideways scroll. Checked in a browser at 1440px and 390px, light and dark.
    - **Browser smoke:** now opens a card's pane, checks it and closes it with Esc.

    Choices made, for Steve to overturn:
    1. A policy's Controls count includes its domain's controls as well as those linked directly. Policies cover their domain, so most would otherwise read "0 controls linked".
    2. The fact is called "Reviewers" (Content's word), not the design's "Owner".
    3. Contents shows top-level headings, or two levels when a document has a single top-level heading.
    4. An uploaded Word or Excel file gets a Download file button.

    Not done: page counts ("PDF · 12 pages"). Compass doesn't store a page count for uploaded files, so the labels read just "PDF" and "Word document".
assignee: steve
label:
- feature
priority: medium
task_status: review
---
Clicking a document in the Library opens a preview pane on the right, as in the design, instead of leaving the Library. Built on COM-1918.

**The pane**
- Header: type icon and "Policy · Published v7", and a close button. Clicking outside the pane or pressing Esc closes it.
- Title and summary.
- Four facts: **Reviewers** (the document's reviewers in Content; the design's "Owner"), **Last reviewed**, **Version** ("v7 · published"), **Controls** ("14 controls linked"). A decision shows **Status**, **Decided**, **Decided by** and **Linked to** instead.
- **Appears in 3 folders**: each folder path, with the one you're in marked **You are here**. Clicking a path goes to that folder.
- **Add to another folder** (only for people who can edit Content; same picker as COM-1919).
- **Contents**: the document's section headings, numbered. A file or link document shows what it is instead ("Word document · 2 pages", "Link to SharePoint").
- Its tags.
- Footer: **Read document** (COM-1922's reader; until then, Content), **Copy link** (a link to this document in the Library, which opens the pane on arrival) and **Download PDF** (the published version's PDF, as Content gives today).

**Pick up where you left off**
- On the Library's home, above Browse: the last three documents this person opened, as small cards with type, title and "Reviewed Mar 2026". It follows the person, not the browser. Hidden until they've opened one. A document that's been unpublished or deleted drops off.

**Done when**
- The pane shows every item above for a templated document, an uploaded file, a link, a SharePoint document and a decision.
- You are here, folder links, Copy link (opens the pane on arrival), Download PDF and Esc all work.
- Pick up where you left off shows the person's last three, on another browser too.
- Phone width: the pane is full width and nothing scrolls sideways.

On the chain: an API to record and read a person's recently opened documents.