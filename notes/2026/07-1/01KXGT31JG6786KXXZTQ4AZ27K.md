---
id: 01KXGT31JG6786KXXZTQ4AZ27K
created: 2026-07-14T17:16:43.472281823Z
updated: 2026-07-14T17:16:43.472281823Z
type: task
title: Activity log model + capture + API
task_status: done
label: brief
priority: medium
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 69
---
Backend foundation for the audit trail (M14). An append-only activity log capturing who-did-what-when across mutating actions.

- [ ] **Draft an ADR** for the audit-log design: capture mechanism (FastAPI dependency/middleware that records on successful mutations vs explicit per-endpoint calls), what to record (actor user, action verb, entity_type, entity_id, human summary + optional structured diff, company_id, created_at, optional IP/user-agent), append-only/tamper-evidence stance, retention, and read RBAC.
- [ ] `ActivityLog` SQLAlchemy model + **Alembic migration** (append-only; no update/delete in app code; indexed on company_id, entity_type+entity_id, actor, created_at).
- [ ] Capture mechanism wired across the mutating v1 endpoints (assessments, gaps, risks, treatments, content, decisions, mappings, users, companies, rubric, tokens). Prefer a central hook over per-endpoint duplication.
- [ ] Read API: `GET /api/v1/activity` with filters (actor, entity_type, entity_id, company, date range) + pagination; admin (and any future auditor role) read only.
- [ ] Tests (integration): mutations record entries with correct actor/action/entity; the log is append-only; filters + pagination work; reads are RBAC-gated.

New subsystem (beyond ADR 0014). Refs: ADR 0001 (append-only ADR discipline parallels the append-only log intent), the GRC controls this satisfies (ISO A.8.15, HIPAA 164.308(a)(1)(ii)(D), PCI Req 10, CIS 8.x).

---
*Migrated from Linear [DEV-498](https://linear.app/stevevine/issue/DEV-498/activity-log-model-capture-api) · created 2026-06-19 · completed 2026-06-19*