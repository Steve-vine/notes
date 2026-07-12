---
id: 01KXBGF2NF810YFRGRF279TMXX
created: 2026-07-12T15:52:19.887654005Z
updated: 2026-07-12T15:52:19.887654005Z
type: task
title: Sync wedges on duplicate finding source_keys in one batch
priority: medium
task_status: backlog
assignee: steve
project: 01KX671DATY39VW6GWK3M2T3DN
number: 45
---
BUG, found by the Phase 3 exit test (ISE-43) against a real broken workload on g5.

Symptom: sync_system raised IntegrityError — duplicate key on uq_finding_system_id, source_key=event/ise-acceptance/Pod/payments-api-.../Failed — and g5 recorded NO state and NO findings for ~25 minutes. One broken pod blinded ISE to the entire cluster.

Cause: Kubernetes emits TWO distinct `Failed` events for a single image-pull failure ("Failed to pull image ..." and "Error: ErrImagePull"). Both collapse to the same source_key (event/{ns}/{kind}/{name}/{reason}). In sync._upsert_findings the first is db.add()-ed but never registered in the `existing` map, so the second doesn't find it and inserts a SECOND row → UniqueViolation. Because state snapshots and findings share one transaction, the whole sync aborts.

Fix: register the newly-added Finding in `existing` so an in-batch duplicate updates it (later event wins) instead of inserting again. Central in sync.py, so it protects every connector, not just Kubernetes.

Regression test asserts the sync completes, the finding collapses to one row (later event wins), AND the state still lands — verified to fail with the exact production UniqueViolation before the fix.

Severity: high — availability of monitoring itself. Latent since Phase 2; only a specific real-world event pattern triggers it, which is why no earlier test caught it.</body>
<parameter name="values">{"assignee": ["steve"], "priority": ["high"], "task_status": ["active"]}