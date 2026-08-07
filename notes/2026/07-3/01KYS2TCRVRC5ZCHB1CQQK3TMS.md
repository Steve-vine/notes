---
id: 01KYS2TCRVRC5ZCHB1CQQK3TMS
created: 2026-07-30T08:38:54.491437Z
updated: 2026-08-07T10:55:56.85932Z
type: task
title: sync_one persist failures die silently — health never records the error
project: 01KX671DATY39VW6GWK3M2T3DN
number: 372
order: 2.0
sprint: s0d5f5q
comments:
- id: 01KYS5K3FN6FGYFD8PQ7B7MGWJ
  author: Steve Vine
  at: 2026-07-30T09:27:21.333654Z
  text: |-
    Built and in review — PR #344 (feature/ise-372-sync-persist-containment), merged to staging.

    Both loops' write phases are now inside the per-system containment. sync_one: reconcile → promotion → estate discovery → tag rules → stamp/audit/commit wrapped; on failure the poisoned transaction rolls back and health=error + last_sync_error are recorded in a fresh short transaction, audited as sync_failed with phase=persist — the exact mirror of the connector-read failure path. run_obs_loop: same shape; last_obs_run_error recorded and last_obs_run_at still advances so a broken write path is not re-hammered every dispatch (matching the read-failure stance). One subtlety pinned in a comment + test: rollback must precede even the log line, because a session mid-failed-flush refuses attribute refreshes (PendingRollbackError).

    Tests reproduce the exact live failure (source_key > varchar(300)) against real Postgres: failure records the error, the next clean run recovers to connected, and the obs variant records last_obs_run_error. No UI work — the Systems screen already renders health=error + detail; this makes those fields tell the truth. Full backend suite green locally (1571 passed).
assignee: steve
priority: medium
task_status: done
---
Found 2026-07-30 via the Azure source_key overflow: sync_one's try/except wraps only the connector READS (health_check/read_state/detect/discover_entities). When the PERSIST fails (e.g. the varchar(300) StringDataRightTruncation from the oversized alert key), the exception escapes the task: nothing writes health="error" or last_sync_error, last_synced_at stays NULL — so the System tile keeps showing its creation default ("disabled") while the sync dies and re-dispatches every beat minute. The operator sees a misleading DISABLED with zero diagnostic.

Scope: extend sync_one's containment so a _persist/promotion/estate-reconcile failure rolls back and records health="error" + last_sync_error (its own short transaction, since the failed one is poisoned), mirroring the connector-read failure path; audit the failure like sync_failed. Same review for obs_loop_system. Test: a connector whose findings violate a DB constraint leaves the system showing error + the message, not silence. UI already renders health/error — no new surface needed.