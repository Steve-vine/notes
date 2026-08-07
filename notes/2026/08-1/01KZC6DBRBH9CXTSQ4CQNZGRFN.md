---
id: 01KZC6DBRBH9CXTSQ4CQNZGRFN
created: 2026-08-06T18:47:15.979385Z
updated: 2026-08-07T09:40:33.381467Z
type: task
title: Teams outbound "System event" notification type — platform-level events, breakglass is the first producer
project: 01KX671DATY39VW6GWK3M2T3DN
number: 591
sprint: snk16ew
assignee: steve
label: null
priority: medium
task_status: active
---
New outbound notification type in the Teams layer (ADR 0067): **System event** — platform-level happenings that are not incident/signal notifications. First producer is breakglass (ADR 0089 draft): armed / disarmed / expired transitions post to the configured channels, on arm AND on end so the channel shows the window closed, not just opened.

Scope:
- Add the `system_event` type to the outbound Teams notification layer alongside the existing types; card shows event kind, actor, incident ref (when bound to one), reason, and duration/remaining where applicable.
- Routing/config: which chats receive System events is configurable the same way as existing notification types.
- Keep the type general — future producers (deploy notices, credential-expiry escalations) should need no notification-layer change.
- Tests alongside the existing Teams notification suite.

Dependency: none — buildable ahead of breakglass (ISE-NNN breakglass task consumes it).