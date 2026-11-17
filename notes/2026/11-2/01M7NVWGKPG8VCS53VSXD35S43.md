---
id: 01M7NVWGKPG8VCS53VSXD35S43
created: 2026-11-17T23:01:17.046332Z
updated: 2026-11-17T23:01:17.046332Z
type: task
title: 'Library reading pane: a document''s preview, where it appears, and pick up where you left off'
assignee: steve
priority: medium
task_status: todo
label: feature
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1921
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