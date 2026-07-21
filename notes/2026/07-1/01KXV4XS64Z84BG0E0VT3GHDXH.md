---
id: 01KXV4XS64Z84BG0E0VT3GHDXH
created: 2026-07-18T17:38:29.70042481Z
updated: 2026-07-21T08:39:08.571564Z
type: task
title: Stable-key ingest correlation (N signals → 1 incident)
project: 01KX671DATY39VW6GWK3M2T3DN
number: 120
sprint: stgj737
blocked_by:
- 01KXV4XHT1TF92MARARTXZJKZK
assignee: steve
priority: high
task_status: done
---
**Sprint 11 (spine) — split from ISE-114.** Replace the 1:1 `finding_id` promotion (one signal → one incident) with true **ingest correlation** by stable key.

- A signal opens or attaches to **at most one *open* Incident** by a stable correlation key (e.g. `monitor/{id}/{group}`, or event+entity), rather than the current unique `finding_id`.
- Recovered-and-re-triggered signals **re-attach** to the same open incident rather than duplicating.
- Supersede `promotion.py`'s 1:1 mapping; keep it deterministic (no AI).
- Alembic migration; integration tests (a multi-group monitor splits per group; a flapping signal stays one incident).

Deferred from ISE-114 (which kept 1:1 finding_id). Depends on the Incident lifecycle vocabulary task.