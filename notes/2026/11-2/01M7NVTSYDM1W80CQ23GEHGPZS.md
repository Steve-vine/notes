---
id: 01M7NVTSYDM1W80CQ23GEHGPZS
created: 2026-11-17T23:00:21.069518Z
updated: 2026-11-18T07:44:29.504588Z
type: task
title: 'A document''s summary and tags: written by the author or drafted by Polaris'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1917
sprint: s2q1gxe
blocked_by:
- 01M7NVTFQK1D8GQT8YYW64EJ5B
assignee: steve
label:
- feature
priority: medium
task_status: active
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