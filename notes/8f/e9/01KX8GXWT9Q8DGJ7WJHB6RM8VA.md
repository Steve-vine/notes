---
id: 01KX8GXWT9Q8DGJ7WJHB6RM8VA
created: 2026-07-11T12:02:42.121765884Z
updated: 2026-07-11T12:02:42.121765884Z
type: task
title: Sync engine — Beat schedule, snapshot/finding persistence, staleness
assignee: steve
priority: high
task_status: backlog
project: 01KX671DATY39VW6GWK3M2T3DN
number: 22
---
Beat fires per-system sync tasks (ADR 0006) → connector read-state/detect → StateSnapshot and Finding persisted atomically (no partial state), findings upserted by source_key. Per-system staleness tracking and last-sync times. Connector errors contained: one system's outage degrades only its card, never others' sync or the UI (connectors brief failure semantics).