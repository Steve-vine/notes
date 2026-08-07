---
id: 01KZC6DBRBH9CXTSQ4CQNZGRFN
created: 2026-08-06T18:47:15.979385Z
updated: 2026-08-07T10:57:20.802784Z
type: task
title: Teams outbound "System event" notification type — platform-level events, breakglass is the first producer
project: 01KX671DATY39VW6GWK3M2T3DN
number: 591
sprint: snk16ew
comments:
- id: 01KZDV0ETQXFSTSEAWD97QKWYQ
  author: Steve Vine
  at: 2026-08-07T10:06:27.67146Z
  text: |-
    Done — PR #509 (branch feature/ise-591-teams-system-event).

    What shipped:
    - `system_event` added to NOTIFICATION_EVENT_TYPES as ONE general type carrying a `kind` in its payload (breakglass_armed, breakglass_expired, …), not a type per happening. Rationale: a type per happening makes every future producer a schema change + migration + a new unticked checkbox, so its first notification reliably reaches nobody — the exact failure this layer exists to prevent. Subscribers opt into "system events" once and inherit deploy notices / credential-expiry escalations for free.
    - `notifications.emit_system_event()` composes the card ADR 0089 asks for: event kind, actor, incident ref (when bound), reason, duration/remaining. Everything below the title is optional.
    - Routing/config is identical to the existing types — channel `events` toggle; a "System event" checkbox in Settings → Teams → Destinations, with a description naming the producer since "System event" alone is opaque.
    - Migration 0100 (CHECK swap, the 0077 pattern).

    Two design points worth recording:

    1. **Severity-less events need a per-emit accent.** A system event carries no severity, so it is toggle-only like action_pending — but that also means it has no title colour. The per-event override table is keyed on event_type alone, so a single `system_event` type could not read as bad news on arm and all-clear on end. Added an optional `accent` to the payload that beats both the per-type override and the severity colour.

    2. **Real trap found and fixed: the live-card lifecycle.** ADR 0069 §5 keeps one card per incident — a resolution edits it, an escalation supersedes it. `live_card()` keyed purely on `issue_id`. A system event bound to an incident (breakglass armed during IN-0042) would therefore have become that incident's live card simply by being newest, and the incident's own resolution would then have edited the *breakglass announcement* instead of the incident card. The lifecycle now keys on the three incident events (`INCIDENT_CARD_EVENTS`); a system event can reference an incident and deep-link to it without joining its lifecycle. Covered by `test_a_system_event_on_an_incident_does_not_join_its_card_lifecycle`.

    Also note: system events never match an `assignee`-kind channel (no incident owner to borrow) — falls out of the existing rule, tested explicitly.

    Migration downgrade has a data path: it deletes system_event deliveries (CHECK-constrained) AND strips the subscription from notification_channel.events, which is unconstrained JSONB and would otherwise survive a downgrade and then 422 the next edit of that channel. Tested in both directions.

    ADR 0067 gains an amendment block. Full backend suite 2480 passed, frontend 645 passed, ruff/mypy/eslint/prettier/build clean, no api-types drift.
assignee: steve
label: null
priority: medium
task_status: review
---
New outbound notification type in the Teams layer (ADR 0067): **System event** — platform-level happenings that are not incident/signal notifications. First producer is breakglass (ADR 0089 draft): armed / disarmed / expired transitions post to the configured channels, on arm AND on end so the channel shows the window closed, not just opened.

Scope:
- Add the `system_event` type to the outbound Teams notification layer alongside the existing types; card shows event kind, actor, incident ref (when bound to one), reason, and duration/remaining where applicable.
- Routing/config: which chats receive System events is configurable the same way as existing notification types.
- Keep the type general — future producers (deploy notices, credential-expiry escalations) should need no notification-layer change.
- Tests alongside the existing Teams notification suite.

Dependency: none — buildable ahead of breakglass (ISE-NNN breakglass task consumes it).