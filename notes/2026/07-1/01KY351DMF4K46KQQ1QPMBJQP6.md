---
id: 01KY351DMF4K46KQQ1QPMBJQP6
created: 2026-07-21T20:14:24.399434Z
updated: 2026-07-24T14:48:55.454393Z
type: task
title: DataDog entity tags flap — tag set differs on every sync
project: 01KX671DATY39VW6GWK3M2T3DN
number: 204
sprint: sbeam3b
comments:
- id: 01KY4FZ5EJTPRRQJYER5986TNX
  author: Steve Vine
  at: 2026-07-22T08:44:39.250158Z
  text: |-
    Done — PR #186 (feature/ise-204-datadog-tag-flap). Both scenarios fixed as separate defects, per the diagnosis in the task.

    **Scenario B — pagination (`connectors/datadog.py`).** `_reporting_hosts` now walks `list_hosts` with `count=1000`, `start`, and a pinned `sort_field="name"` / `sort_dir="asc"`, looping to `total_matching`. The pinned sort is what stops pages overlapping as the server's default ordering churns. Termination: empty page always ends the walk (covers a fleet shrinking mid-pagination, which would otherwise chase a `total_matching` it can never reach), plus a `_HOST_PAGE_LIMIT` runaway guard that logs the stop rather than truncating silently. Deliberately does NOT stop on a short page — `count` is a request, not a promise, and stopping on one would quietly reintroduce the truncation.

    **Scenario A — tag-blind sources (`connectors/base.py`, `connectors/datadog.py`, `discovery.py`).** Added `EntityData.tags_known` (default `True`). It distinguishes "this source sees no tags here" from "this source cannot see tags at all" — set-replacement (ADR 0037 §2) could not tell those apart, and read the second as the first. DataDog marks monitor-scope-derived entities `tags_known=False`; the service catalogue and host list mark theirs `True`. `reconcile_discovered` now skips tag-blind reports when building `tags_by_entity`, so their silence changes nothing (excluded means untouched, not emptied). Visibility ORs across sources in the connector's `add()` helper, so a host seen by both a monitor scope and the host list is reconciled on the strength of the source that can see. Chose fix direction 2 from the task over per-source reconcile knowledge — same outcome, no schema change.

    **Bonus fix found in review.** The same defect fired on source *failure*: `_contained` degrades a failed source to `[]`, which was indistinguishable from an entity legitimately losing every tag. A 403 on the service catalogue used to wipe every service's `team:`/`tier:` tags for that sync. Excluding blind reports closes that too, since those entities then arrive only via monitor scopes.

    `MAX_TAGS=50` confirmed uninvolved and untouched (task had already eliminated it).

    **Agreement with ISE-206** (task point 3): "seen" means reported by discovery this batch, *including* tag-blind sources — retirement will key off that. "Tags asserted" requires a source that can actually see them. The two do not conflict.

    **Tests** — `tests/test_connector_discovery.py` (5 new), `tests/integration/test_tag_pool.py` (2 new). The DataDog fake in `test_datadog_connector.py` now pages the way the real API does (honours `count`/`start`, reports `total_matching`, caps at a settable server page size) and records its calls, so a caller that ignores paging is visibly wrong. Covers: 250 hosts over 100-host pages all discovered and all tagged with `start=[0,100,200]`; shrinking fleet terminates; monitor-scope-only host is tag-blind while the host-list host is not; a host seen by both is sighted; a catalogued service with zero tags is still sighted (only blindness is exempt, not absence); tag-blind report retains tags (0 added / 0 removed) and a sighted bare report then clears them; exclusion applies per report, not per entity, within one batch.

    Full backend suite green (846 passed), ruff + ruff format + mypy strict clean.

    Note for whoever runs mypy locally: the incremental cache was reporting 5 phantom `has no attribute` errors on untouched files. `uv run mypy --no-incremental` is clean — CI is unaffected.
assignee: steve
priority: medium
task_status: done
---
Found on staging (`staging-20260721-1951`, first image carrying ISE-180): consecutive DataDog syncs report oscillating `tags_added/removed` (+1291 initial, then +19/−9, +59/−39, +59/−15…). Tagged-host count observed moving 109 → 102 → 106 across ~45 min — tags are stripped and re-added live. **There are at least two distinct scenarios feeding the same symptom; they need separating during diagnosis and may need separate fixes.**

**Scenario A — dead transient instances (confirmed by Steve, 2026-07-21):** hosts that genuinely no longer exist in DataDog (ephemeral autoscale instances — GitLab runners, GKE nodes). While dying, a host drops out of the reporting list but can linger in monitor scopes/group-states, so `discover_entities` still mints it via a tag-blind source and the set-replace reconcile (`reconcile_entity_tags`, ADR 0037 §2) strips its tags. Once it vanishes from discovery entirely it keeps whatever it last had (reconcile only touches the current batch) — hence tagless ghost entities accumulating (ISE-206 owns retirement).

**Scenario B — live hosts truncated by pagination (found 2026-07-21, `staging-b.madesimplegroup-151616`):** `_reporting_hosts` calls `apis.hosts.list_hosts()` bare (`datadog.py`) — no `count`/`start`, `total_matching` ignored. The API returns **100 hosts per page by default** and the account has far more, so only ~100 hosts per sync get tag data; a live, tag-rich host outside the page (staging-b — 0 tags in ISE, tags visible in DataDog; its sibling staging-a inside the page has 15) is discovered only via monitor scopes and stays tagless. Page membership also drifts between syncs (server default sort over a runner-churned list), so live hosts fall in and out of the tagged set — flapping without any instance dying. The steady ~100-109 tagged-host count matches one page + not-yet-stripped stragglers.

Per-host tag counts are avg ~13 / max 31 — the `MAX_TAGS=50` cap is NOT involved (early suspect, eliminated).

**Impact:** tag links flap; Tag Cloud heat jitters; live hosts silently miss tags entirely (B is a correctness gap, not just churn); estate fills with dead tagless hosts that confuse operators (A).

**Fix directions:**
1. (B) Paginate `list_hosts` — `count=1000`, loop `start` until `total_returned` accumulates to `total_matching`; pin a stable `sort_field` so pages don't drift mid-pagination. Likely the primary fix for both missing tags on live hosts and much of the churn.
2. (A) Don't let a tag-blind source blank a tag-bearing one: only include an entity in the reconcile input when a source that *can* carry tags reported it (or reconcile per-source knowledge).
3. (A) Entity retirement for vanished hosts is ISE-206 (Sprint 19) — out of scope here, but the two must agree on what a source's silence means.
4. Tests: (B) >100 mocked hosts → all get tags; (A) host with tags in sync N, named only by a monitor scope in sync N+1 → tags retained; truly absent → untouched.

Related: ISE-205 (host naming/merge), ISE-206 (entity lifecycle/retirement).