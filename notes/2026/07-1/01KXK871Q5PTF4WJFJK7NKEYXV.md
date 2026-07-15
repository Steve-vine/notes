---
id: 01KXK871Q5PTF4WJFJK7NKEYXV
created: 2026-07-15T16:02:03.621514071Z
updated: 2026-07-15T16:02:46.036919538Z
type: task
title: Vendor security certifications + expiry reminders
label: brief
task_status: backlog
assignee: steve
priority: medium
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 185
blocked_by:
- 01KXK8563Z64CMPVWK31Z0NZWF
---
Phase 4 (ADR 0039 §7): certifications as a child table with expiry-driven reminders.

- [ ] `models/vendor_certification.py`: vendor FK, `name` (ISO 27001, SOC 2…), `issuer`, `valid_until`, evidence URL + migration.
- [ ] Sub-resource CRUD [require_vendor_write]; certifications card on the detail page with expiry pills.
- [ ] `NotificationKind.vendor_certification_expiring` + reminders-scan extension (the Phase-2 vendor scan pattern).
- [ ] Tests.

Ref: ADR 0039 §7, ADR 0006.