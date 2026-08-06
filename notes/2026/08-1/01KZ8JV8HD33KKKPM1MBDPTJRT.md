---
id: 01KZ8JV8HD33KKKPM1MBDPTJRT
created: 2026-08-05T09:07:36.621805Z
updated: 2026-08-06T08:34:52.938441Z
type: task
title: Platform Log rows don't name the originating integration — inject system context into the logging pipeline
project: 01KX671DATY39VW6GWK3M2T3DN
number: 552
sprint: skxht3g
comments:
- id: 01KZ90QV8JK75VZB8FCKF4R9B2
  author: Steve Vine
  at: 2026-08-05T13:10:24.786208Z
  text: |-
    Built on feature/ise-552-log-system-context — PR #471 (full CI green: backend, frontend, lint, api-types), merged to staging.

    **Structural, as specified — no 60-call-site edit.** `log_context.py` holds a ContextVar-backed `system_log_context(system_id, system_name)`; `sync_one`, `run_obs_loop` and the action executor open it around the connector call, and `SystemContextFilter` stamps every record produced inside. Every existing connector call site is covered at once, and a future connector gets it free.

    Attached to the HANDLERS, not the root logger — a logger-level filter never sees records propagating up from `ISE_api.connectors.*`, which is every record this exists for. A call site that names its own system still wins.

    **Schema (migration 0098):** `platform_log.system_id` + `system_name`, both nullable. Deliberately NOT a foreign key — a log row must outlive the system it was written about, and an FK violation inside a handler that swallows its own failures would lose the row silently. A `system_id` that isn't a UUID is dropped to NULL rather than allowed to fail the insert, for the same reason: losing the warning to protect a label is the wrong trade. `system_name` denormalised so the row survives a rename.

    **The screen (DoD):** Integration column on every group; Integration filter (multi-select, including "Not system-specific"); and the system is part of the GROUP KEY — seven clusters emitting one identical warning now read as seven answerable rows rather than one saying "×7". Expanding a group carries its system, so one cluster's row lists only that cluster's records.

    `system` moved out of `extra` into its own column: one home per field, so a row and its detail panel can't disagree.

    Tests: filter stamps inside/not outside the context, no leak past a raising block, explicit call-site value wins, non-UUID id costs the row nothing; a connector warning arrives named; one warning from three clusters is three rows; filter narrows (incl. unattributed, and ORed); expansion is scoped; malformed id is 422; `test_sync` proves the connector call really runs inside the context; three frontend tests.
assignee: steve
label: null
priority: medium
task_status: done
---
A Platform Log warning from inside a connector cannot be attributed to a system. Today's case: `kubernetes discovery: secrets unavailable` — with 7 Kubernetes clusters configured, working out that only **g5** was 403ing took a `state_snapshot` timeline correlation plus a live `kubectl auth can-i` probe, instead of one glance at the row.

The gap is structural:
- `platform_log` has no `system_id`/system-name column — the UI can't filter "warnings from mgnt-production-uk-pri" even in principle (`component` is the ISE process, not the integration).
- All 60 `logger.warning`/`logger.error` call sites across `ISE_api/connectors/` include no system in their extras (best is a scope hint like Cloudflare's `zone`). Connectors are system-agnostic and mostly don't hold the System object at the failure point.
- The context exists one frame up: `sync_one` (`sync.py:273-277`) already passes `system_id`/`system_name` into the connector context and names the system in its own messages.

Fix structurally, not with 60 edits: set a contextvar (system id + name) in `sync_one` around the connector call — and equally around obs runs and action execution — and inject it into every log record in the logging pipeline (`JsonFormatter` for stdout, `DatabaseLogHandler` for the DB sink), so every call site is covered at once and future connectors get it for free. Add a nullable `system_id` column (or at minimum a well-known `extra.system` key) and a per-integration filter on the Platform Log screen, fitting the grouped view from ISE-543.

Design note: `DatabaseLogHandler` is deliberately paranoid (never raises, never recurses) — inject via a logging filter or the record factory, not by having the handler resolve names from the database.

UI slice (definition of done): the Platform Log screen shows the system on each row/group and can filter by it.