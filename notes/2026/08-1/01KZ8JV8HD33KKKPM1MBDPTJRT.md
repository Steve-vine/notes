---
id: 01KZ8JV8HD33KKKPM1MBDPTJRT
created: 2026-08-05T09:07:36.621805Z
updated: 2026-08-05T12:29:32.086838Z
type: task
title: Platform Log rows don't name the originating integration — inject system context into the logging pipeline
project: 01KX671DATY39VW6GWK3M2T3DN
number: 552
sprint: skxht3g
assignee: steve
label: null
priority: medium
task_status: todo
---
A Platform Log warning from inside a connector cannot be attributed to a system. Today's case: `kubernetes discovery: secrets unavailable` — with 7 Kubernetes clusters configured, working out that only **g5** was 403ing took a `state_snapshot` timeline correlation plus a live `kubectl auth can-i` probe, instead of one glance at the row.

The gap is structural:
- `platform_log` has no `system_id`/system-name column — the UI can't filter "warnings from mgnt-production-uk-pri" even in principle (`component` is the ISE process, not the integration).
- All 60 `logger.warning`/`logger.error` call sites across `ISE_api/connectors/` include no system in their extras (best is a scope hint like Cloudflare's `zone`). Connectors are system-agnostic and mostly don't hold the System object at the failure point.
- The context exists one frame up: `sync_one` (`sync.py:273-277`) already passes `system_id`/`system_name` into the connector context and names the system in its own messages.

Fix structurally, not with 60 edits: set a contextvar (system id + name) in `sync_one` around the connector call — and equally around obs runs and action execution — and inject it into every log record in the logging pipeline (`JsonFormatter` for stdout, `DatabaseLogHandler` for the DB sink), so every call site is covered at once and future connectors get it for free. Add a nullable `system_id` column (or at minimum a well-known `extra.system` key) and a per-integration filter on the Platform Log screen, fitting the grouped view from ISE-543.

Design note: `DatabaseLogHandler` is deliberately paranoid (never raises, never recurses) — inject via a logging filter or the record factory, not by having the handler resolve names from the database.

UI slice (definition of done): the Platform Log screen shows the system on each row/group and can filter by it.