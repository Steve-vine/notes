---
id: 01KY37W4MY2HDQ7NTP70KYWP0K
created: 2026-07-21T21:03:57.086115Z
updated: 2026-07-24T14:48:58.164365Z
type: task
title: 'Entity lifecycle: last-seen tracking, retirement, and pruning of stale entities'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 206
sprint: sbeam3b
comments:
- id: 01KY4HRWBKV0290MK9RX8TJWA7
  author: Steve Vine
  at: 2026-07-22T09:16:10.48293Z
  text: |-
    Done — PR #188 (feature/ise-206-entity-lifecycle), stacked on #187/ISE-205 (which is stacked on #186/ISE-204); all three touch `discovery.py`. Built as one slice rather than splitting stage 1 / stage 2 — the two stages share the sweep, the ADR and the migration, and stage 1 alone leaves the DB still growing forever.

    **ADR 0039** (estate entity lifecycle) written and accepted, extending ADR 0028. **Migration 0042** adds `entity.last_seen_at` + `entity.retired_at` with an index on `retired_at`.

    **Stage 1 — last-seen + retirement.** `reconcile_discovered` stamps `last_seen_at` for every entity in a batch (mirroring `_upsert_edge`'s `last_confirmed_at`) and clears `retired_at` in place if set, reporting an `unretired` count. New `estate_lifecycle.retire_unseen_entities(db, now, windows, default_days)` — pure, no commit, in the `close_quiet_incidents` shape. Per-type windows via settings: host 2d, workload 3d, 14d default; zero disables a type. Groups are never retired (materialised by a tag rule, never discovered — no connector will ever report one).

    **On the "seen" question you flagged (task bullet 3):** resolved explicitly and documented as ADR 0039 §2 with a table. "Seen" means reported by discovery this batch by **any** source including tag-blind ones; "tags asserted" requires a source that can see them. Existence is a low bar any sighting clears; classification is a claim only an observer may make. There's a test pinning both halves at once — a tag-blind report bumps `last_seen_at` without touching the tags.

    **Stage 2 — pruning.** `prune_retired_entities` hard-deletes entities retired past a second window (30d default). Exemptions as you specified plus one more: an entity on an **open** incident (statuses open/acknowledged/reactivated/resolved — closed and dismissed are terminal), and an entity carrying a **human annotation**. The second wasn't in the task, but annotations are ADR 0028's authored-and-sticky register and cascade-delete on entity removal, so pruning would silently destroy human knowledge. `finding.entity_id` and `playbook.entity_id` were already `ON DELETE SET NULL`, so history survives with the link nulled exactly as the task proposed — test asserts the finding and incident both remain with `entity_id` null. Orphan `tag` sweep included, and it correctly spares a tag still held by a finding (tags hang off signals too).

    **Deliberate design choice worth flagging:** retirement is a scheduled sweep over `last_seen_at`, not inferred at discovery time by diffing a batch against the graph. Batch-diffing makes every sync's correctness depend on that sync being complete — one truncated page (exactly ISE-204's bug) or one degraded source would retire a slice of the estate — and has no coherent answer for an entity several integrations know. Recorded in ADR 0039 §5 with the rejected alternative.

    **Migration detail:** `last_seen_at` is backfilled from `updated_at` rather than left NULL. NULL reads as "never seen", which the first sweep would have retired the entire estate on, live entities included.

    **UI (DoD).** Estate list: retired hidden by default behind a remembered "Show retired" switch, filtered **server-side** — the list endpoint has no LIMIT, so client-side filtering would ship the whole ghost fleet over the wire to discard it. Retired rows dim with a tooltipped "Retired" badge. Entity detail: a retired entity still opens (a link from an old incident must land somewhere, not 404) with a badge and an explanatory alert covering what retired means, that nothing is lost, and that it un-retires if it returns.

    **Housekeeping task** `ISE_api.tasks.estate.sweep_entity_lifecycle_task`, hourly beat alongside `close-quiet-incidents`, registered in both `worker.py` places (the include list is enforced by `test_worker_task_registration.py`). Retire-then-prune in one transaction — the prune window is measured from `retired_at`, so nothing retired by the same run is anywhere near due.

    **Tests** — 19 integration (`test_estate_lifecycle.py`), 2 API, 5 frontend (`EntityLifecycle.test.tsx`). Backend 877 passed, ruff + mypy strict clean; frontend 277 passed, lint/format/build clean; OpenAPI types regenerated.

    One thing the model-vs-migration check caught worth remembering: the migration's index has to be declared on the model too, or `test_migrate_zero_to_head_and_models_match` fails.

    **For the smoke test:** the sweep is hourly. On first deploy the backfill dates everything from `updated_at`, so the ~92 genuine ghosts retire on the first pass and live hosts are re-stamped by the next sync. Nothing prunes for 30 days, so the only visible change at first is the estate list getting shorter — and reversibly, since the toggle shows them and a returning host un-retires.
assignee: steve
priority: medium
task_status: done
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