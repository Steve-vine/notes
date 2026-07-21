---
id: 01KY05DH2C1XPG8XY43SSQTVQZ
created: 2026-07-20T16:23:17.836303Z
updated: 2026-07-21T16:23:19.911515Z
type: task
title: Improve the format of audit log entries on the incident timeline
project: 01KX671DATY39VW6GWK3M2T3DN
number: 160
order: 2.0
sprint: skj7tft
assignee: steve
label: null
priority: medium
task_status: done
---
Audit lifecycle lines on the incident timeline are terse and machine-flavoured. Currently:

> `Steve.Vine@moneypenny.co.uk marked resolved · 7m ago`

Change to:

> `Mon 20 Jul 17:21 - Steve Vine - Resolved incident`

Three changes:

1. **Absolute timestamp** instead of relative "time ago" (`Mon 20 Jul 17:21` format).
2. **User's full name** instead of email address. The audit record stores `actor=user.email` (`api/v1/issues.py:565`) — either resolve email → full name at render time or include a display name in the timeline payload.
3. **Improved wording**: action-first phrasing, e.g. "Resolved incident" rather than "marked resolved".

Rendering lives in `describeAudit()` / `AuditEventItem` in `app/frontend/src/pages/issue/IssueTimeline.tsx` (~565). Applies to all audit lines on the timeline (status transitions, assignments, diagnosis/remediation requests, and system actors like `sync`), not just resolve — system actors need a sensible name too.