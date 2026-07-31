---
id: 01KYWBDKMHGT3KM4TK3H6Q8KWF
created: 2026-07-31T15:06:56.017422Z
updated: 2026-07-31T15:51:52.847988Z
type: task
title: Freshservice ticket ingest onto the Events screen + scope config
project: 01KX671DATY39VW6GWK3M2T3DN
number: 440
order: 1.125
sprint: s5pft6a
blocked_by:
- 01KYWBD140W250K7BY89WVRB2Z
assignee: steve
label: null
priority: medium
task_status: todo
---
Poll Freshservice tickets and surface them on the existing Events screen. **No new table, no migration** — reuse the events layer via `webhooks.ensure_managed_source(db, system)` + `webhooks.store_event(...)`, exactly the GitHub-poller shape (`tasks/repos.py:103 _emit_events`, ADR 0051 §4).

This buys, free: the FTS index `ix_webhook_event_fts`, the Events screen with facet filters, the `search_events` AI retrieval tool, 24h auto-context on investigations, and the 90-day retention purge. A dedicated `freshservice_ticket` table was considered and rejected — it duplicates all of that for typed columns alone. Revisit trigger for the ADR: if live ticket *state* tracking (reopen counts, open-vs-resolved rollups) becomes necessary.

**Verified safe:** `webhook_signals.raise_signal_for_event` has exactly one caller (`api/webhook_ingest.py:75`), so poller-written events never auto-raise a Finding. Ticket events stay context; signals are raised deliberately and separately in the detector task.

**Sweep** — `tasks/freshservice.py` Beat task (register in `worker.py` `include` **and** `beat_schedule`; the `tasks/status_pages.py` shape, which keeps connector methods side-effect free).

Per sweep:
- Fetch a trailing lookback window (configurable).
- One `_in_scope(ticket, config)` helper applied in **exactly one place**, carrying both the scope allow-list and the unconditional `ise-generated` tag exclusion — one gate, not three.
- `ensure_managed_source` + `store_event` per ticket, `alert_key = f"fs-ticket:{id}"`, `event_type="ticket"`, `level="info"`.
- **Emit once per ticket, on first sighting only** — updates are not re-emitted, keeping this to one row per ticket. Current ticket state is an Evidence pull, not a stored fact.
- **Bound the dedupe query** on `received_at >= now - 7d` so it rides `ix_webhook_event_source_received`. (The `_emit_events` releases idiom scans *all* alert_keys unbounded — fine for releases, wrong at ticket volume.)
- No cursor column: lookback + `alert_key` dedupe is idempotent and self-heals after downtime.

**Scope config** — flat keys on `System.config` (ADR 0044), matching the `ignore_rules` precedent: `ticket_types` (default `["Incident"]` — this is the "I need a mouse" cut), `ticket_group_ids`, `exclude_categories`, plus detector thresholds and `ticket_requester_email`. Push what the API can express (`type`, `priority`, `created_at`) server-side; the tag exclusion is necessarily client-side.

Scope editor on System detail (the ignore-rules editor is the precedent).

UI: desk tickets visible and full-text searchable on the Events screen; scope editable without a code change.