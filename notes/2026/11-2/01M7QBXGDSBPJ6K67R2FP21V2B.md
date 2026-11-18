---
id: 01M7QBXGDSBPJ6K67R2FP21V2B
created: 2026-11-18T13:00:41.273514Z
updated: 2026-11-18T13:00:43.937127Z
type: task
title: The Library's "Try" suggestions come only from published documents' tags
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1948
sprint: s2q1gxe
assignee: steve
label:
- bug
priority: high
task_status: todo
---
Found in the Library pre-UAT pass on staging (c15afb4d, 2026-11-18, COM-1920).

**What happened:** an E2E draft document's tags ("backup testing, incident reporting, lost laptop, one hour") showed on the Library home as the **Try** suggestions under the search box, for Admin A and for the Viewer. They disappeared when the draft was deleted. The suggestions come from the tags in use across every document, drafts included. A draft must never surface in the Library (ADR 0161 §2), and a draft's tags can give away what is being written. Screenshots: ~/compass-uat/library/COM-1920/01, 02 and COM-1918/11.

**Done when**
- The Library's Try suggestions are taken only from the tags of documents the Library shows: published documents and accepted decisions.
- There's no Try row when no shown document has a tag.
- Content's own tag suggestions, offered while an author types tags, still include drafts' tags.
- A test pins that a draft's tag never reaches the Library.

On the chain: changes the API the Library reads its suggestions from.