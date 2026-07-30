---
id: 01KYS2TCRVRC5ZCHB1CQQK3TMS
created: 2026-07-30T08:38:54.491437Z
updated: 2026-07-30T09:12:18.907547Z
type: task
title: sync_one persist failures die silently — health never records the error
project: 01KX671DATY39VW6GWK3M2T3DN
number: 372
order: 2.0
sprint: s0d5f5q
assignee: steve
label:
- bug
priority: medium
task_status: todo
---
Found 2026-07-30 via the Azure source_key overflow: sync_one's try/except wraps only the connector READS (health_check/read_state/detect/discover_entities). When the PERSIST fails (e.g. the varchar(300) StringDataRightTruncation from the oversized alert key), the exception escapes the task: nothing writes health="error" or last_sync_error, last_synced_at stays NULL — so the System tile keeps showing its creation default ("disabled") while the sync dies and re-dispatches every beat minute. The operator sees a misleading DISABLED with zero diagnostic.

Scope: extend sync_one's containment so a _persist/promotion/estate-reconcile failure rolls back and records health="error" + last_sync_error (its own short transaction, since the failed one is poisoned), mirroring the connector-read failure path; audit the failure like sync_failed. Same review for obs_loop_system. Test: a connector whose findings violate a DB constraint leaves the system showing error + the message, not silence. UI already renders health/error — no new surface needed.