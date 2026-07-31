---
id: 01KYWHH9WKA1RDD2JCNXME42HK
created: 2026-07-31T16:53:48.563745Z
updated: 2026-07-31T16:53:48.563745Z
type: task
title: Bot poster + card lifecycle — one card per incident, updated in place
label: feature
priority: medium
assignee: steve
task_status: backlog
project: 01KX671DATY39VW6GWK3M2T3DN
number: 448
---
The poster, plus the capability the Power Automate path never had.

- **Send**: `POST {serviceUrl}/v3/conversations/{conversationId}/activities` with a message Activity carrying the existing Adaptive Card as an attachment. `render_message` (ISE-420) is reused unchanged — the card is the same, only the envelope differs.
- **Card lifecycle (the headline)**: record the returned `activityId` on the delivery row. A LATER event about the SAME incident on the SAME channel then UPDATES the original card via `PUT /v3/conversations/{conversationId}/activities/{activityId}` instead of posting a second card. So one card per incident tracks it from opened → escalated → resolved, always current, rather than a wall of cards. Needs the card to render a status line, and a lookup from (channel, issue) → prior activity id.
  - Decide in build: does an escalation update in place, or warrant a fresh card so it re-notifies? Updating silently may be TOO quiet for an escalation — an in-place update does not re-alert.
- **@mention on high/critical**: `<at>Name</at>` in the card text plus a matching entity in `msteams.entities`. Mentions cut through muting and land in the Activity feed, so this is the real attention primitive. Validate the user resolves before emitting the tag — an unmatched `<at>` renders as broken text.
- **NOT AVAILABLE — do not design around it**: bots CANNOT send "urgent" priority messages (the 2-min-for-20-min repeat). `ActivityImportance.High` does not trigger it. Attention comes from DM + mention + notification alert only.
- Failure mapping: 403 `MessageWritesBlocked` means the user blocked or uninstalled the bot — record it distinctly in the delivery log; it is not a transient error and should not burn retries.

Everything else in the pipeline (routing rules, in-transaction delivery rows, sweep, bounded retries, anti-flap) is unchanged from ADR 0067.