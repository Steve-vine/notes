---
id: 01M0CPQBCM03GB90DT43SCGJM9
created: 2026-08-19T09:48:02.324762Z
updated: 2026-08-19T09:48:02.324762Z
type: task
title: JML execution starves behind the mirror crawl — one queue, two slots, minutes of latency
priority: high
assignee: steve
task_status: todo
label: bug
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 275
---
Smoke finding, Sprint 34 (2026-08-19), observed live. An approved `group_create` sat queued for minutes because both prefork slots (worker `concurrency: 2`, single default queue) were occupied by overlapping directory-mirror syncs; the execution ran within 0.6 s the moment a slot freed (`received 09:46:20 → 201 Created → executed`, after the sync completed 09:46:15). An interactive, seconds-long, human-visible write path (ADR 0045 §6) should never wait behind a tenant crawl.

Three compounding causes, each worth its own lever:

* **No queue separation.** `execute_access_request` / `execute_recert_removal` (latency-sensitive, seconds) share the default queue and pool with `sync_directory` (minutes) and the PDF/report tasks. Fix: route execution tasks to a dedicated queue with its own worker (or a second consumer on the same deployment) so a sync can never occupy every slot they need.
* **Syncs overlap.** The Beat tick (`*/15` wall-clock) fires regardless of a pass already running; a manual "Sync now" stacks a second full crawl (observed: two concurrent passes, both slots gone). Fix: an overlap guard — skip (or fast-exit) when `directory_sync_status.last_started_at` is recent and no completion followed, and make "Sync now" a no-op with feedback while a pass is in flight.
* **The crawl got heavy with COM-252.** Members + owners for *every* group is ~2 calls × ~1,000 groups ≈ several thousand Graph calls, 5–10 min per pass on this tenant (~10k calls observed in a 10-minute window with two passes). Levers if the cadence starts overlapping itself: Graph `$batch` (20 requests/call), delta queries, or restricting the member/owner crawl to kinds that need it.

Queue separation is the safety-critical piece — the other two are efficiency. Refs: ADR 0045 §6 (one write path, human latency), COM-252 (crawl widening), `core/celery_app.py` (routes/schedules), `tasks/directory_sync.py`, helm chart worker args.