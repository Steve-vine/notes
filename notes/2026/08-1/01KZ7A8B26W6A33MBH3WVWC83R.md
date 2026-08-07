---
id: 01KZ7A8B26W6A33MBH3WVWC83R
created: 2026-08-04T21:18:13.574808Z
updated: 2026-08-07T10:06:34.069597Z
type: task
title: 'Escalation engine: announce → wait → call → walk the chain'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 549
sprint: s4ncy73
blocked_by:
- 01KZ7A7DTKGHY5FMRK8XAMSST6
- 01KZ7A82FSXAT1FMB044A02TZG
assignee: steve
priority: medium
task_status: backlog
---
ADR 0080 §3. Per-incident escalation state machine driven by Beat cadence (the sweep pattern): announce (card) → wait configured window → call the on-call → wait → next in chain; halts immediately on acknowledgement (DTMF from ISE-548 or in-app ack) or resolution. Every step is a delivery row — the delivery log is the audit trail.

Config minimal v1: per-channel window + severity floor (ADR 0026 ladder). Anti-flap + payload-snapshot rules unchanged.

Screen: escalation timeline on the incident page (announced → called X, no answer → called Y, acknowledged) + in-app Acknowledge action that stops the chain.