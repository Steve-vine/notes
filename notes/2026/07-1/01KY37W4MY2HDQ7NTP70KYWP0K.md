---
id: 01KY37W4MY2HDQ7NTP70KYWP0K
created: 2026-07-21T21:03:57.086115Z
updated: 2026-07-21T21:04:00.009887Z
type: task
title: Entity last-seen tracking and retirement of vanished entities
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

**Work:**
- Add `last_seen_at` to `entity`, stamped for every entity in a discovery batch — same pattern as `entity_edge.last_confirmed_at` (`_upsert_edge` in `discovery.py`), which is the established freshness precedent (consumed by `drift.py`).
- Retirement: a housekeeping pass (new beat task alongside `close_quiet_incidents`, or folded into the Obs Loop drift check) retires entities unseen past a window. **Retire/archive, never delete** — signals, tags, edges, annotations and audit history hang off `entity.id`. Consider per-type windows (transient hosts vs durable namespaces).
- Reconcile nuance: "seen" must mean *reported by discovery this batch* — including tag-blind sources — so retirement and ISE-204's tag-strip fix stay consistent about what a source's silence means.
- UI (DoD — the screen is part of the slice): retired entities hidden by default in the estate list with a "show retired" toggle; retired badge + last-seen shown on the entity detail page; a returning entity un-retires on next discovery.
- Likely needs a short ADR (estate entity lifecycle) since it extends ADR 0028's model, plus a migration for `last_seen_at`/`retired_at`.

Sized as the opening task of the Estate Lifecycle sprint; may split (model+stamp / retire+UI) during planning.