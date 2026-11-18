---
id: 01M7NVTSYDM1W80CQ23GEHGPZS
created: 2026-11-17T23:00:21.069518Z
updated: 2026-11-18T08:53:45.164336Z
type: task
title: 'A document''s summary and tags: written by the author or drafted by Polaris'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1917
sprint: s2q1gxe
blocked_by:
- 01M7NVTFQK1D8GQT8YYW64EJ5B
comments:
- id: 01M7PXS9AKVSN3BAPJ9TJ3C8NG
  author: Steve Vine
  at: 2026-11-18T08:53:42.867179Z
  text: |-
    Done: merged as PR #1918 (7afae512). All PR checks passed. The database change follows the folders change, so there's still one migration head.

    What a person can do now:
    - A document's details in Content and a decision's page have **Summary** (up to 300 characters) and **Tags** (lower case, offered from tags already in use as you type, up to 12).
    - Saving them needs no new version or review, doesn't count as an unpublished change, and is recorded in the activity log.
    - **Suggest with Polaris** drafts a summary and up to six tags from the latest published version, or the draft if the document was never published. It prefers tags already in use. You can edit the suggestion, then Accept or Discard, and nothing is saved until you accept. If Polaris is off, over its spending limit or fails, it says so in plain words. Each suggestion is recorded in Polaris usage under the person's name.
    - Content's list shows the summary as one muted line under each title. Its search box now matches summary and tags too ("Search content by name, summary or tag"). The decisions search and Compass's global search also match them, and global search shows the summary as the snippet.
    - The list of tags in use, with counts, is available to the Library's later tasks (autocomplete and the "Try" suggestions in search).
    - Polaris in chat (COM-1923) will save through the same path, with the same tidying and "via Polaris" in the activity log.

    Choices made, for Steve to overturn:
    1. Summary and tags aren't versioned. A document with unpublished changes shows its current summary, as the task asked ("saved like the title").
    2. Accept replaces both summary and tags; it doesn't merge with the existing tags.
    3. For uploaded, linked or SharePoint documents, Polaris reads only text Compass holds. When there isn't any, it says so and suggests nothing.
    4. A decision's summary and tags can be changed at any status, including accepted or superseded, because they describe the decision rather than change it.
    5. On a decision, summary and tags are edited by people who can record decisions. The Folders field beside them is edited by people who can edit Content.

    Checks: unit suite (2702 passed), new integration tests for summary and tags, the content, decision, search, flowchart and assistant tests, type checks, lint, vitest, the OpenAPI drift check, and the Browser smoke search placeholder updated to match.
assignee: steve
label:
- feature
priority: medium
task_status: review
---
The Library shows each document with a one- or two-sentence summary and a few tags, and search uses both (COM-1915, ADR 0161). Documents and decisions have neither today.

**What the author sees**
- A document's details in Content gain **Summary** (a sentence or two, up to about 300 characters) and **Tags** (short words or phrases: "mfa", "break glass", "72 hours"). Tags are lower case, typed freely, and suggested from tags already in use as you type, so the same idea isn't spelled three ways.
- A decision record's page gains the same two fields.
- **Suggest with Polaris** beside the fields reads the document's latest published version (or the draft, if it was never published) and drafts a summary and up to six tags. The author sees the suggestion, can edit it, and **Accept** or **Discard**. Nothing is saved until they accept. If Polaris can't be reached it says so, and the fields stay as they were.
- Summary and tags are saved like the document's title: they don't need a new version or a review, and the change is in the activity log.
- Polaris in chat can write them too, when a person who can edit Content asks (COM-1923).

**Where they show**
- In Content's document list, the summary appears under the title. In Content search, tags are matched.
- The Library (COM-1918 onward) shows both on cards, in the reading pane and in search.

**Done when**
- An author can write, change and clear a summary and tags on a document and on a decision.
- Suggest with Polaris drafts both, and nothing changes until Accept.
- Tags already in use are offered as you type.
- Activity log records the change.

On the chain: adds a migration (summary and tags on documents and decisions) and changes the API.