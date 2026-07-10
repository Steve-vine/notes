---
id: 01KX6VXSDBE12B66M73JW8YX5Y
created: 2026-07-10T20:36:24.107840193Z
updated: 2026-07-10T21:28:51.181785173Z
type: task
title: Domain model v1 — core entities + migrations
task_status: review
assignee: steve
priority: high
project: 01KX671DATY39VW6GWK3M2T3DN
number: 10
sprint: sqtx330
---
SQLAlchemy models and Alembic migrations for System, StateSnapshot, Finding, Issue, ProposedChange, AgentRun, AuditEvent (architecture-overview brief; ADR 0002/0005). Postgres-native types (JSONB) welcome.