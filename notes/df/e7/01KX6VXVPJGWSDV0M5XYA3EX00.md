---
id: 01KX6VXVPJGWSDV0M5XYA3EX00
created: 2026-07-10T20:36:26.450042548Z
updated: 2026-07-10T21:52:49.554935Z
type: task
title: Audit event pipeline — same-transaction writes
priority: high
task_status: review
assignee: steve
project: 01KX671DATY39VW6GWK3M2T3DN
number: 11
blocked_by:
- 01KX6VXSDBE12B66M73JW8YX5Y
comments:
- id: 01KX706HWGZFTN6HGFRSRJQG5Z
  author: Steve Vine
  at: 2026-07-10T21:51:05.616206609Z
  text: 'Development complete on feature/ise-011-audit-pipeline. PR #14: https://github.com/Steve-vine/ise/pull/14. audit.record(session, ...) makes change + audit atomic by construction (same session, caller''s transaction); details pass through the ADR 0010 redaction before storage; migration 0003 adds a DB trigger rejecting UPDATE/DELETE on audit_event — append-only enforced by Postgres, not convention. Heavy test battery on real PG: commit-together, rollback-together, orphan prevention on constraint failure, redaction, tamper rejection (33/33). Staging deployed, alembic at 0003, and the trigger verified LIVE on the staging database: superuser DELETE and UPDATE both rejected with ''audit_event is append-only'' (row-level, confirmed against a real row — an empty-table check is vacuous). Awaiting smoke test and merge clearance.'
sprint: sqtx330
---
AuditEvent writes committed in the same transaction as the change they record (roadmap Phase 1). Helper API for services; heavy test investment — this is a Phase 4 trust anchor.