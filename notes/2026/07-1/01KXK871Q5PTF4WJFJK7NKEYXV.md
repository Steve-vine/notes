---
id: 01KXK871Q5PTF4WJFJK7NKEYXV
created: 2026-07-15T16:02:03.621514071Z
updated: 2026-07-19T21:30:30.104090786Z
type: task
title: Vendor security certifications + expiry reminders
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 185
sprint: sjkp918
blocked_by:
- 01KXK8563Z64CMPVWK31Z0NZWF
comments:
- id: 01KXP5KSJQ4MJFR9Z8G4FGZXJK
  author: Steve Vine
  at: 2026-07-16T19:14:18.839333983Z
  text: |-
    Built on feature/com-185-certifications (stacked on com-184) — PR #176, merged to staging (b455240).

    - Migration 0047: vendor_certifications table + vendor_certification_expiring notification kind (promote-pattern downgrade).
    - CRUD at /api/v1/vendors/{id}/certifications (writes require_vendor_write); CertificationsCard on the Details tab with expiry-proximity pills and evidence links.
    - Reminders scan raises one owner notification per expiring certification (due_on = valid_until); skips unowned/dormant/offboarded vendors; idempotent.

    Gates: 88 unit + 20 integration (incl. migration round trip), 191 Vitest, mypy strict, ruff, build, Semgrep p/default — all green.
assignee: steve
task_status: done
priority: medium
---
Phase 4 (ADR 0039 §7): certifications as a child table with expiry-driven reminders.

- [x] `models/vendor_certification.py`: vendor FK, `name` (ISO 27001, SOC 2…), `issuer`, `valid_until`, evidence URL + migration.
- [x] Sub-resource CRUD [require_vendor_write]; certifications card on the detail page with expiry pills.
- [x] `NotificationKind.vendor_certification_expiring` + reminders-scan extension (the Phase-2 vendor scan pattern).
- [x] Tests.

Ref: ADR 0039 §7, ADR 0006.