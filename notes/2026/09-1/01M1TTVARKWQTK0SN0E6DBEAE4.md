---
id: 01M1TTVARKWQTK0SN0E6DBEAE4
created: 2026-09-06T07:45:10.931008Z
updated: 2026-09-06T09:39:35.318395Z
type: task
title: evidence links can be typed but never opened
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 570
sprint: s2fcksg
comments:
- id: 01M1V1CSK42C29G07FG6RDE91N
  author: Steve Vine
  at: 2026-09-06T09:39:34.628438Z
  text: |-
    Done — PR #582, merged to main.

    The links now read like the file list below them: openable items, each with a remove, and a box to add another. The tag input was the wrong shape for exactly the reason you gave — its value is a pill, and a pill is not somewhere a link can live.

    Both details landed as specified. Validation is on the way **in** only: a new entry has to parse as http/https, and what is already stored renders as it is — as plain text where it will not parse, and still removable. Refusing to show somebody their own evidence would be worse than refusing to open it. And they open in a new tab with `rel="noopener noreferrer"`, since they point off-site at whatever was pasted from a panel that sits behind the session.

    **One judgement call worth flagging.** The links are *not* gated on `posture.record_assessments`, unlike the files beside them. The rest of the panel is not gated either — the save is what refuses — so gating this one field would have been a new inconsistency rather than a fix. If you would rather the whole panel went read-only for viewers, that is a real question but a different task.

    Left alone as you asked: evidence links still appear nowhere in the coverage CSV or PDF, pending the audit-pack conversation.

    Five tests; frontend suite green at 1000.
assignee: steve
label:
- bug
priority: medium
task_status: review
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
