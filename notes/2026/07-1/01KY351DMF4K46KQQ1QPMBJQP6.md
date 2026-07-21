---
id: 01KY351DMF4K46KQQ1QPMBJQP6
created: 2026-07-21T20:14:24.399434Z
updated: 2026-07-21T20:14:27.190623Z
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
Found on staging (`staging-20260721-1951`, first image carrying ISE-180) minutes after deploy: the first DataDog sync (19:53) reconciled 1,291 entity tags, then consecutive syncs on the DataDog system (`d2bfb8d2…`) reported `tags_added/removed` of 19/9, 59/39, 0/0, 59/15. `reconcile_entity_tags` is idempotent on identical input by design (see its docstring in `tags.py`), so the *reported set* is unstable, not the reconcile.

**Suspects, in likelihood order:**
1. `MAX_TAGS = 50` cap in `normalise_set` keeps the **first-seen** 50 — if the DataDog API returns host tags (the tag-richest source) in unstable order, the surviving 50 differ per sync.
2. Monitor group-states shifting the scope-derived sets as alerts fire/recover.
3. Union order across the three sources in `discover_entities` (`datadog.py`) feeding `tags_by_entity` in `discovery.py`.

**Impact:** provenance rows churn every sync (pointless deletes/inserts, audit noise), Tag Cloud heat jitters, tag `updated` timestamps meaningless.

**Fix shape:** capture two consecutive `discover_entities` outputs to confirm which source is unstable, then make the reported set deterministic before the cap (e.g. sort tags before `normalise_set`, or cap per source); regression test asserting two identical syncs produce added=0 / removed=0.