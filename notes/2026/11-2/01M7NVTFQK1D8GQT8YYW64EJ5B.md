---
id: 01M7NVTFQK1D8GQT8YYW64EJ5B
created: 2026-11-17T23:00:10.611455Z
updated: 2026-11-17T23:02:09.754853Z
type: task
title: 'Library folders: nest to any depth, a document in several at once, one folder per domain to start'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1916
sprint: s2q1gxe
assignee: steve
label:
- feature
priority: medium
task_status: todo
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