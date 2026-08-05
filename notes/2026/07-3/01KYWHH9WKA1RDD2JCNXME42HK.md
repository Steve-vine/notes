---
id: 01KYWHH9WKA1RDD2JCNXME42HK
created: 2026-07-31T16:53:48.563745Z
updated: 2026-08-05T19:02:30.524978Z
type: task
title: Bot poster + card lifecycle — one card per incident, updated in place
project: 01KX671DATY39VW6GWK3M2T3DN
number: 448
order: 2.0
sprint: s8rg5n9
blocked_by:
- 01KYWHGSSFCX76Z95F88PEXPEX
assignee: steve
label: null
priority: medium
task_status: done
---
The poster, plus the capability the Power Automate path never had.

- **Send**: `POST {serviceUrl}/v3/conversations/{conversationId}/activities` with a message Activity carrying the existing Adaptive Card as an attachment. `render_message` (ISE-420) is reused — the card is the same, only the envelope differs.

**CARD LIFECYCLE — decided with Steve 2026-07-31: BOTH edit and post, per event.**

Editing a message is SILENT (Teams does not re-notify on an edit) and posting a new one leaves the old message permanently stale. Doing both fixes each flaw:

- `incident_opened` → post; store the returned `activityId` as the incident's LIVE card on that channel.
- `incident_escalated` → EDIT the live card so it visibly steps aside ("escalated to critical — see below", accent dropped so it recedes), THEN post a fresh card that actually notifies, and store the new activity id as live. Escalation is exactly when someone must be re-alerted, so silence is the wrong failure.
- `incident_resolved` → EDIT the live card in place to show resolved. No new message: good news need not interrupt.

Result: exactly one message shows current state, the chat history reads correctly, and every escalation pings.

**Load-bearing rule**: the edit is BEST-EFFORT. If it fails (message deleted, Teams declines an edit) it must NOT block the new post — the notification is the point, tidying history is a nicety. Log and carry on.

VERIFY AT BUILD: whether Teams limits how old a bot message may be before refusing an edit. Unknown; find out now rather than during an incident.

Needs: a lookup from (channel, issue) → live activity id, and a status line on the card.

- **@mention on high/critical**: `<at>Name</at>` in the card text plus a matching entity in `msteams.entities`. Mentions cut through muting and land in the Activity feed — the real attention primitive. Validate the user resolves first; an unmatched `<at>` renders as broken text.
- **NOT AVAILABLE — do not design around it**: bots CANNOT send "urgent" priority messages (the 2-min-for-20-min repeat). `ActivityImportance.High` does not trigger it.
- Failure mapping: 403 `MessageWritesBlocked` means the user blocked or uninstalled the bot — record distinctly; not transient, should not burn retries.

Everything else in the pipeline (routing rules, in-transaction delivery rows, sweep, bounded retries, anti-flap) is unchanged from ADR 0067.