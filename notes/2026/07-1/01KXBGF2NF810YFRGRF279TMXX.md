---
id: 01KXBGF2NF810YFRGRF279TMXX
created: 2026-07-12T15:52:19.887654005Z
updated: 2026-07-21T17:44:32.131843Z
type: task
title: Sync wedges on duplicate finding source_keys in one batch
project: 01KX671DATY39VW6GWK3M2T3DN
number: 45
sprint: syv1q8m
assignee: steve
label: null
priority: high
task_status: done
---
BUG found by the Phase 3 exit test (ISE-43), against a real broken workload on g5 rather than a fixture. Fixed in PR #41, on main.

SYMPTOM: sync_system raised IntegrityError — duplicate key on uq_finding_system_id, source_key=event/ise-acceptance/Pod/payments-api-.../Failed. g5 recorded NO state and NO findings for ~25 minutes. One broken pod blinded ISE to the entire cluster.

CAUSE: Kubernetes emits TWO distinct `Failed` events for a single image-pull failure ("Failed to pull image ..." and "Error: ErrImagePull"). Both collapse to the same source_key (event/{ns}/{kind}/{name}/{reason}). In sync._upsert_findings the first was db.add()-ed but never registered in the `existing` map, so the second did not find it and inserted a SECOND row. Because state snapshots and findings share one transaction, the UniqueViolation aborted the whole sync — not just that finding.

FIX: register the newly-added Finding in `existing` so an in-batch duplicate updates it (later event wins) instead of inserting again. Central in sync.py, so it protects every connector rather than special-casing Kubernetes.

Regression test uses the exact production shape and asserts the sync completes, the finding collapses to one row, AND the state still lands (the real damage was the collateral loss of everything else). Verified to fail with the production UniqueViolation without the fix.

Severity: high — this is the availability of monitoring itself. Latent since Phase 2; only a specific real-world event pattern triggers it, which is why nothing synthetic caught it. Phase 2's exit test used a crash-loop, which does not produce two events sharing one key.