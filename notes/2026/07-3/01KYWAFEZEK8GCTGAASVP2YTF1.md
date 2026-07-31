---
id: 01KYWAFEZEK8GCTGAASVP2YTF1
created: 2026-07-31T14:50:28.206287Z
updated: 2026-07-31T15:02:17.941487Z
type: task
title: 'Docs: Concepts — signals &amp; incidents'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 427
order: 0.5
sprint: sp3en5k
assignee: steve
label:
- feature
priority: medium
task_status: active
---
Replace the stub at `src/content/docs/concepts/signals-and-incidents.md` with real content: alerts vs observations; why signals are transient and incidents durable and human-owned; the canonical severity ladder; the auto-incident threshold and confidence bar; escalate-but-never-de-escalate; implicit acknowledgement; silencing vs ignoring vs downgrading (and ingest-time ignore rules, which live on the integration); master/child incidents and merge candidates; recovery and auto-resolution.

Ground in ADRs 0025, 0026, 0032, 0034, 0035, 0036, 0038, 0040, 0044. Operator audience, released capability only.