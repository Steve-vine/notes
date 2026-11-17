---
id: 01M7NVT18A9XKSN7SVA7W6RFDR
created: 2026-11-17T22:59:55.78624Z
updated: 2026-11-17T23:02:09.168451Z
type: task
title: 'Decision record: the Library — published documents in virtual folders (ADR 0161)'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1915
sprint: s2q1gxe
assignee: steve
label:
- feature
priority: medium
task_status: todo
---
Write the ADR the rest of the Library sprint is built to. Design: https://claude.ai/artifact/8BsVjexM7NQXS4qRX23XJ7 (Library page). ADR 0160 is taken by Content Flowcharts, so this is **0161**.

**What it records**
- **What the Library is:** a calm place to find and read any published document. It's a way of *presenting* the playbook, not a second place to author it: writing, reviewing and publishing stay in Content.
- **Where it lives:** a new **Library** page in the **Overview** group of the Compass menu (ADR 0152). Compass users only for now (Steve, 2026-11-17). Bringing it to the User Portal for every colleague is a later sprint.
- **What's in it:** every *published* policy, standard, procedure, runbook (every Content type) and every accepted decision record. A draft never shows. A document with unpublished changes shows its last published version.
- **Virtual folders:** folders nest to any depth. A document can sit in as many folders as it belongs to. It's one document shown in several places, never a copy. A document in no folder shows under **Not in a folder**.
- **Shared, like the playbook:** folders are the same for every company, as Content is.
- **Who arranges it:** anyone who can edit Content can create, rename, move, reorder and delete folders and file documents (Steve, 2026-11-17). Everyone who can see Content can read the Library.
- **Day one:** Compass makes one folder per domain (named and described after the domain) and files each document by its domain. After that, folders and domains are independent: renaming a domain doesn't rename its folder, and a new document isn't filed automatically (it shows under Not in a folder until someone files it).
- **Deleting a folder** never deletes a document. Its subfolders go with it. A document that's left in no folder goes to Not in a folder. Every folder change is in the activity log.
- **Summary and tags** become part of a document's details in Content (and a decision's). The author writes them, or Polaris drafts them for the author to accept (Steve, 2026-11-17). Search ranks title, then tags, type, summary, folder names and the document's own text.
- Brief updates: `brief/information-architecture.md` (Library page and menu entry) and the feature list.

**Done when**
- ADR 0161 is merged, accepted, and the briefs above say the same.

Independent: no migration and no API change.