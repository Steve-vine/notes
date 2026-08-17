---
id: 01M055C17DZ15RT1MDPRCT2NCY
created: 2026-08-16T11:30:04.653605Z
updated: 2026-08-17T11:00:20.668994Z
type: task
title: Incident notifications by email — the second channel kind the poster was written for
project: 01KX671DATY39VW6GWK3M2T3DN
number: 747
sprint: s50x901
comments:
- id: 01M05NDG2PVE8E0R22JRZPH97G
  author: Steve Vine
  at: 2026-08-16T16:10:29.84603Z
  text: |-
    Built and pushed as PR #696 — move to Review. Migration **0143** (the chain is 0142 ISE-743 → 0143 this → 0144 ISE-748).

    **The claim in `notifications.py` held.** No emit point learned that email exists: the same `emit_event` writes the same pending row in the causing transaction, the same sweep picks it up, the same retry cap, test send and delivery history apply. What was added is a second poster and a second gate — which is exactly what "kind-generic so a second kind is a new poster, not a new schema" promised.

    **The bug you flagged is closed, and verified by flipping the gate off.** `channels_for_event` now asks the mechanism question per kind: for Teams "is this integration on", for email "is there an active sender, and is it usable" — answered by `mail.unavailable_reason`, so the sentence on a failed delivery is the *same string* Settings ▸ Email shows. `test_switching_the_mechanism_off_stops_email_arriving` fails without the gate, across all three ways the mechanism can be off (transport disabled / no sender chosen / re-activated).

    One addition beyond the task: **a skipped email channel logs a warning naming which channels and why.** Refusing to route is right — retrying cannot change the answer — but doing it silently is how "we stopped getting the alerts" becomes an investigation instead of a glance at the Platform Log.

    Judgement calls:

    1. **A system_id on an email channel is refused, not ignored.** A caller that sent one believes the channel is bound to it; silently dropping that belief is how "we switched transport and it kept using the old one" becomes a bug report. The DB CHECK is the backstop; the 422 is the message.
    2. **`group_chat` is refused for email.** Destination kinds are otherwise reused exactly as the task said — `user` is already an address, `assignee` is already the owner's, a distribution list is how one channel reaches many. But a Teams thread id is not something you can post a letter to, and accepting one would store a destination that can only fail.
    3. **An email delivery records no `activity_id`.** Email has no message to edit, so the ADR 0069 §5 card lifecycle simply does not apply. `live_card` only ever selects deliveries carrying one, so leaving it NULL is what keeps a resolution mailing a fresh notice instead of trying to edit something already delivered.

    **One thing worth flagging that the task did not mention: escaping.** An incident title is estate-derived — a Kubernetes object name, an alert subject — and reaches the renderer unfiltered. Left raw in the HTML body, a title containing `<` breaks the message and a crafted one injects markup into every recipient's inbox. `render_email` escapes it; there is a test.

    Also moved the event vocabulary to `lib/notificationEvents.ts`. Two editors rendering the same toggles from two copied lists is how a new event type reaches one screen and not the other.
assignee: steve
label:
- feature
priority: high
task_status: done
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
