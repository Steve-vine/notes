---
id: 01KYC50G4F0PBK4N38Z7G93AFS
created: 2026-07-25T08:07:04.079814Z
updated: 2026-07-25T08:07:17.318174Z
type: task
title: Webhook event retention
project: 01KX671DATY39VW6GWK3M2T3DN
number: 278
sprint: s6pc5xk
blocked_by:
- 01KYC4YWCCZM0GHY37VMHWDTER
assignee: steve
label:
- chore
priority: low
task_status: backlog
---
Events must not accumulate forever (the estate-lifecycle lesson: nothing that grows unbounded).

- A Celery Beat housekeeping task purges `webhook_event` rows older than a configurable retention window (default 90 days), idempotent, structured-logged.
- `webhook_source` rows and their last-received/count bookkeeping survive the purge.
- Retention window surfaced read-only wherever the ADR (ISE-274) decides it lives (settings value or config), consistent with how other thresholds are handled.

Small chore; headless by nature (stated per the DoD exception).