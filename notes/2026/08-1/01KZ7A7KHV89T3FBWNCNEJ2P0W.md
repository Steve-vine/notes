---
id: 01KZ7A7KHV89T3FBWNCNEJ2P0W
created: 2026-08-04T21:17:49.499958Z
updated: 2026-08-04T21:17:49.499958Z
type: task
title: Rota destination for Teams notification channels
assignee: steve
label: feature
task_status: backlog
priority: medium
project: 01KX671DATY39VW6GWK3M2T3DN
number: 546
---
ADR 0080 §2. `NOTIFICATION_DESTINATION_KINDS` gains `rota`; resolution at delivery time (rota → current on-call → address) so a channel outlives every handoff. For `msteams-bot` channels: card posts to the current on-call's one-to-one chat with @mention. Conversation-id cache semantics: cache per resolved user, invalidated on handoff.

Channels UI (Settings) gains the rota destination option. This makes rotas useful before any calling exists.