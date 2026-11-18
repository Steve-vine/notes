---
id: 01M7QBXGDSBPJ6K67R2FP21V2B
created: 2026-11-18T13:00:41.273514Z
updated: 2026-11-18T14:25:18.138337Z
type: task
title: The Library's "Try" suggestions come only from published documents' tags
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1948
sprint: s2q1gxe
comments:
- id: 01M7QFAYREAW0EWGFWG25XS6Y9
  author: Steve Vine
  at: 2026-11-18T14:00:27.662194Z
  text: |-
    Done: PR #1934, merged as 0142c1a1.

    The Library home's "Try" suggestions now come only from tags on published documents and accepted decisions. A draft's tags and a proposed decision's tags never appear there. With no such tags there is no Try row at all. Content's own tag field still suggests every tag, drafts' included, so authors keep a consistent vocabulary.

    Technical:
    - New GET /api/v1/library/tags, built from document_details.tags_in_use(db, shown_only=True). It uses the same status rule as the Library tree and search.
    - useLibraryTags() hook. TrySuggestions uses it.
    - Tests: an integration test covers a published doc, a draft, a proposed decision and an accepted decision; Vitest covers the empty list and checks /content/tags is never asked.

    Re-check on staging after the next deploy.
- id: 01M7QGRE9T9R34BZR13XWZ0SY7
  author: Steve Vine
  at: 2026-11-18T14:25:18.138176Z
  text: |-
    Pre-UAT: Passed. Checked on staging a3e70502 (deploy and Browser smoke green), in E2E Test Company, 18 Nov 14:22–14:25 GMT.

    Steps and what was seen:
    1. As E2E Admin A, made a draft "E2E pre-UAT COM-1948 draft with tags" and tagged it "secret draft tag" and "unreleased plan". Content's own tag suggestions offered both. The Library's tag list was empty, and the Library home had no Try row. (01)
    2. Tagged the published "E2E pre-UAT COM-1907 Service request handling" with "e2e service desk". The Library home's Try row then showed only "e2e service desk", with neither draft tag. Clicking it searched the Library and found that document. (02)
    3. As E2E Viewer, the Library home's Try row showed only "e2e service desk". (03)
    4. Clean-up: removed the tag and deleted the draft. Both tag lists are empty again.

    Screenshots: ~/compass-uat/library/COM-1948/
assignee: steve
label:
- bug
priority: high
task_status: review
---
Found in the Library pre-UAT pass on staging (c15afb4d, 2026-11-18, COM-1920).

**What happened:** an E2E draft document's tags ("backup testing, incident reporting, lost laptop, one hour") showed on the Library home as the **Try** suggestions under the search box, for Admin A and for the Viewer. They disappeared when the draft was deleted. The suggestions come from the tags in use across every document, drafts included. A draft must never surface in the Library (ADR 0161 §2), and a draft's tags can give away what is being written. Screenshots: ~/compass-uat/library/COM-1920/01, 02 and COM-1918/11.

**Done when**
- The Library's Try suggestions are taken only from the tags of documents the Library shows: published documents and accepted decisions.
- There's no Try row when no shown document has a tag.
- Content's own tag suggestions, offered while an author types tags, still include drafts' tags.
- A test pins that a draft's tag never reaches the Library.

On the chain: changes the API the Library reads its suggestions from.