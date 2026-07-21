---
id: 01KY37W4MY2HDQ7NTP70KYWP0K
created: 2026-07-21T21:03:57.086115Z
updated: 2026-07-21T21:23:54.818127Z
type: task
title: 'Entity lifecycle: last-seen tracking, retirement, and pruning of stale entities'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 206
sprint: sbeam3b
assignee: steve
label:
- feature
priority: medium
task_status: backlog
---
Estate entities have no last-seen and no housekeeping (confirmed 2026-07-21): `entity` carries only `created_at`/`updated_at`, and `updated_at` moves only when a discovered fact *changes* — the idempotent reconcile doesn't touch an unchanged entity, so a host discovered every sync and one dead for a week look identical. The only deletion path is a merge folding a duplicate. Result: 92 of 202 staging hosts no longer exist in DataDog and will linger forever (see ISE-204/ISE-205 for how they got there).

**Work — a two-stage lifecycle:**

*Stage 1 — last-seen + retirement:*
- Add `last_seen_at` to `entity`, stamped for every entity in a discovery batch — same pattern as `entity_edge.last_confirmed_at` (`_upsert_edge` in `discovery.py`), the established freshness precedent (consumed by `drift.py`).
- A housekeeping beat task (alongside `close_quiet_incidents`) retires entities unseen past a window (`retired_at`). Per-type windows (transient hosts vs durable namespaces). A returning entity un-retires on next discovery.
- "Seen" must mean *reported by discovery this batch* — including tag-blind sources — so retirement and ISE-204's tag-strip fix agree about what a source's silence means.

*Stage 2 — prune (hard delete of long-retired entities):*
- The same housekeeping task deletes entities retired past a second, longer window — this is what actually keeps the DB from growing forever on a churning fleet (hundreds of ephemeral runners/nodes per week).
- Deletion must handle what hangs off `entity.id`: entity_tag/alias/edge/annotation rows go with it (cascade), but decide explicitly what happens to `finding.entity_id` links and any incident evidence referencing the entity — likely null the link and keep the signal/incident record (history must survive the entity; mirrors the citations-resolve-as-of-now precedent, ISE-64). An entity referenced by a still-open incident should be exempt from pruning.
- Tag pool follow-on: pruning entity_tag links can leave orphan `tag` rows with no links anywhere — sweep those too or the pool grows unbounded.

*UI (DoD — the screen is part of the slice):* retired entities hidden by default in the estate list with a "show retired" toggle; retired badge + last-seen on the entity detail page. Pruned entities are simply gone.

- Needs a short ADR (estate entity lifecycle: last-seen → retired → pruned, and the survival rules for history) extending ADR 0028, plus a migration for `last_seen_at`/`retired_at`.

Sized as the opening task of the Estate Lifecycle sprint; may split (stage 1 / stage 2) during planning.