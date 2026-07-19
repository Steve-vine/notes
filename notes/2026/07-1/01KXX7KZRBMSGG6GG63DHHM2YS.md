---
id: 01KXX7KZRBMSGG6GG63DHHM2YS
created: 2026-07-19T13:04:03.33967298Z
updated: 2026-07-19T13:23:32.230682338Z
type: task
title: Baseline of record ("normal") on the entity
priority: medium
task_status: backlog
assignee: steve
label:
- feature
project: 01KX671DATY39VW6GWK3M2T3DN
number: 142
tech: null
sprint: srmqjcq
blocked_by:
- 01KXX7KDMJK1YACXH6N4JZYM7D
---
**Sprint 14 (vertical slice: backend + UI).** Give the Obs Loop a sense of "normal" so deviation is meaningful.

- **Backend**: the loop captures a per-entity **baseline of record** (what normal looks like) and computes current deviation from it.
- **UI**: the baseline + current deviation are shown on the **entity detail (Estate)** and on an observation ("normal is X; now Y") — so an operator sees not just a value but whether it is abnormal.

**DoD**: an entity shows its captured baseline and how far current state deviates from it. Not done until the baseline renders on the entity detail.

Depends on the scheduler.