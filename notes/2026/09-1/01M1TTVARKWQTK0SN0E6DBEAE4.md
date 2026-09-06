---
id: 01M1TTVARKWQTK0SN0E6DBEAE4
created: 2026-09-06T07:45:10.931008Z
updated: 2026-09-06T09:22:23.173065Z
type: task
title: evidence links can be typed but never opened
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 570
sprint: s2fcksg
assignee: steve
label:
- bug
priority: medium
task_status: active
---
Found by Steve on staging, 2026-09-06.

Evidence links on the assessment panel are **write-only**. They are stored as URLs and rendered as tags in an input box — nothing in the app ever renders one as a link, so a URL recorded as evidence cannot be opened from Compass. To follow your own evidence you have to retype it or pick it out of a tag by hand.

The evidence **files** directly beneath them are openable — each one is a download link. Same section of the same panel, and the two halves behave differently for no reason a reader can see.

This is evidence in a governance record. Being able to get to it is most of its value: an assessment saying "implemented, see this" that will not show you the "this" is barely better than the claim on its own.

## What changes

The saved links read like the file list directly below them: a list of openable items, each with a remove, plus a box to add another. The tag input is the wrong shape here — its value is a pill, and a pill is not somewhere a link can live.

Two details worth getting right:

- **Nothing validates these today.** The field takes any string, so existing rows may hold things that are not URLs at all ("SharePoint > Policies > IAM.docx" is the shape to expect). Linkify what parses as `http`/`https` and render anything else as plain text — a broken link is worse than an honest line of text. New entries can be validated on the way in; do not retrospectively reject what is already stored.
- **These point off-site**, at whatever a person pasted. Open in a new tab, and carry `rel="noopener noreferrer"` — the assessment panel is behind the session, and a target page should not be handed a reference to it.

## Worth a decision, not a fix here

Evidence links appear nowhere in the coverage CSV or PDF report — only assessment status and posture travel. That may well be right, since the report answers "where do we stand" rather than "prove it". Flagging it as a question for whenever the audit-pack conversation comes round, not as part of this.

## Related

- COM-569 — attaching a file before the first save. The other half of the same block.
- COM-564 / COM-566 / COM-568 — the same panel.
