---
id: 01KZ7A7V2EQJNZ9M3EJE9NXGJB
created: 2026-08-04T21:17:57.198882Z
updated: 2026-08-05T13:39:31.461153Z
type: task
title: ACS connector + channel-kind dispatch registry
project: 01KX671DATY39VW6GWK3M2T3DN
number: 547
sprint: s4ncy73
assignee: steve
priority: medium
task_status: backlog
---
ADR 0079 §2. Two pieces:

1. Refactor `post_to_channel` from the hard-coded `msteams-bot` branch into a kind → poster registry (the abstraction ADR 0067 §1 promised); `NOTIFICATION_CHANNEL_KINDS` gains `acs-voice` (CHECK migration).
2. New `acs` connector on the surface-owning shape (ADR 0057/0071): connection string in the credential store, `health_check` acquires and discards a token, empty action catalogue, `notifications` capability. Integration page card.

Prerequisite for ISE-548; no user-visible calling yet (integration card is the screen).