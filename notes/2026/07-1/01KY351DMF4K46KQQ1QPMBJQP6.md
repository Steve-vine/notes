---
id: 01KY351DMF4K46KQQ1QPMBJQP6
created: 2026-07-21T20:14:24.399434Z
updated: 2026-07-21T21:20:49.25767Z
type: task
title: DataDog entity tags flap — tag set differs on every sync
project: 01KX671DATY39VW6GWK3M2T3DN
number: 204
sprint: sth83hw
assignee: steve
label:
- bug
priority: medium
task_status: backlog
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