---
id: 01KYC50G4F0PBK4N38Z7G93AFS
created: 2026-07-25T08:07:04.079814Z
updated: 2026-08-07T10:55:42.911667Z
type: task
title: Webhook event retention
project: 01KX671DATY39VW6GWK3M2T3DN
number: 278
sprint: s6pc5xk
blocked_by:
- 01KYC4YWCCZM0GHY37VMHWDTER
comments:
- id: 01KYCD1FTZMYTEM7887N31R62E
  author: Steve Vine
  at: 2026-07-25T10:27:25.15106Z
  text: |-
    Done. Events no longer accumulate forever.

    - tasks/webhooks.py: purge_old_events(db, retention_days) deletes webhook_event rows older than the window; the @app.task purge_webhook_events Beat entrypoint drives it off the setting. Idempotent (count-then-delete in one transaction — new events are always newer than the cutoff, so a second sweep removes nothing), zero retention disables it entirely, structured-logged with the count. Source rows and their last-received/count bookkeeping survive — only the events age out.
    - New setting webhook_event_retention_days (default 90, ADR 0047 §5). Wired into the worker include list and a slow hourly Beat schedule ("purge-webhook-events"), matching the other housekeeping sweeps — cheap, normally deletes nothing.

    Headless by nature (stated DoD exception). 3 integration tests (removes old / keeps recent + source untouched, idempotent second sweep, zero-retention disables) plus the auto worker-task-registration check (which confirms the new @app.task module is in the include list). mypy (300 files) + ruff clean. Committed to feature/ise-278-webhook-retention (stacked on ise-277).
assignee: steve
priority: low
task_status: done
---
Events must not accumulate forever (the estate-lifecycle lesson: nothing that grows unbounded).

- A Celery Beat housekeeping task purges `webhook_event` rows older than a configurable retention window (default 90 days), idempotent, structured-logged.
- `webhook_source` rows and their last-received/count bookkeeping survive the purge.
- Retention window surfaced read-only wherever the ADR (ISE-274) decides it lives (settings value or config), consistent with how other thresholds are handled.

Small chore; headless by nature (stated per the DoD exception).