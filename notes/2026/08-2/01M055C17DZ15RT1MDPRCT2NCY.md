---
id: 01M055C17DZ15RT1MDPRCT2NCY
created: 2026-08-16T11:30:04.653605Z
updated: 2026-08-16T14:13:17.487113Z
type: task
title: Incident notifications by email — the second channel kind the poster was written for
project: 01KX671DATY39VW6GWK3M2T3DN
number: 747
sprint: s50x901
assignee: steve
label:
- feature
priority: high
task_status: backlog
tech: null
---
`notifications.py` says of its poster: *"kind-generic so a second kind is a new poster, not a new schema"*. `NOTIFICATION_CHANNEL_KINDS` has nonetheless been `("msteams-bot",)` since ADR 0069. This adds `email` and finds out whether that claim was true.

Stacks on [ISE-743]. The whole delivery pipeline — the pending row written in the transaction that caused it, the Beat sweep, the retry cap, test send, delivery history — is reused unchanged.

## Scope

- `"email"` added to `NOTIFICATION_CHANNEL_KINDS` (`models.py` ~line 522).
- **Migration — next free** (the sprint's migrations stack in one chain behind [ISE-743]; re-check `origin/main`, the head has moved twice). `NotificationChannel.system_id` becomes nullable, with `CHECK (kind = 'email' OR system_id IS NOT NULL)`. A widening, so the existing rows are fine; still needs a populated-data migration test.
  An email channel is bound to **no transport, by design**: it is delivered by whichever sender is active, so switching SendGrid → SMTP re-routes every existing channel with no edits. That is the whole point of the one-active-sender model.
- `render_message` gains an email rendering beside the Adaptive Card — subject, HTML body, plain-text alternative, and a link back to the incident. `post_to_channel` dispatches on `kind`.
- Destination kinds are **reused as-is**: `user` (an address — already what it means for Teams) and `assignee` (the incident owner's address). A distribution-list address is how one channel reaches many; no new kind.
- UI: the channel editor for email lives in the **Settings ▸ Email** tab, not on a System page — an email channel belongs to no one integration. Configurable per channel: enabled, recipient, which events, min severity. `components/NotificationsCard.tsx` is the shape to follow (or extend).

## The bug to not re-ship

`channels_for_event` currently ANDs the channel's own `enabled` with **the Teams System's** `enabled` — that gate was added by ISE-461 because switching the integration off left every destination still posting. Email channels need the equivalent gate: **an active sender exists and is enabled**. Miss it and the identical bug ships again, in a new place, and the symptom is mail still arriving after the mechanism was switched off.
