---
id: 01KY351DMF4K46KQQ1QPMBJQP6
created: 2026-07-21T20:14:24.399434Z
updated: 2026-07-21T20:48:57.980795Z
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
Found on staging (`staging-20260721-1951`, first image carrying ISE-180): consecutive DataDog syncs report oscillating `tags_added/removed` (+1291 initial, then +19/−9, +59/−39, +59/−15…). Tagged-host count observed dropping 109 → 102 in ~25 min — tags are being stripped live.

**Root cause (confirmed 2026-07-21 with Steve):** EKS/Karpenter fleet churn interacting with the two DataDog discovery sources.
- A host reporting to DataDog is discovered via `_reporting_hosts`, which supplies its tags (avg ~13/host, max 31 — the `MAX_TAGS=50` cap is NOT involved).
- When a transient node (Karpenter) is terminated it drops out of the reporting list but **lingers in monitor scopes/group-states**, so `discover_entities` still mints it — via a source that carries no tags. The set-replace reconcile (`reconcile_entity_tags`, ADR 0037 §2) then strips every tag it had.
- A host that vanishes from discovery entirely keeps its rows (reconcile only touches the current batch) — so the estate accumulates tagless ghost hosts (92 of 202 hosts don't exist in DataDog any more; most predate tag ingestion).

**Impact:** tag links flap with fleet churn; Tag Cloud heat jitters; estate fills with dead UUID/instance-id hosts that confuse operators.

**Fix directions (decide in implementation):**
1. Don't let a tag-blind source blank a tag-bearing one: only include an entity in the reconcile input when a source that *can* carry tags reported it (or reconcile per-source knowledge).
2. Entity lifecycle: a host absent from the reporting list should age out / be retired (`last_seen`), not linger as a ghost — probably its own follow-up task.
3. Regression test: host present with tags in sync N, named only by a monitor scope in sync N+1 → tags retained; truly absent → entity marked stale, tags untouched.

Related (unlogged as of writing): DataDog canonical host names are EC2 instance ids/UUIDs — unrecognisable in the estate and the `k8s:node:<name>` cross-key is built from them so host↔node merges never fire; aliases + `kube_node:` tag are the fix there.