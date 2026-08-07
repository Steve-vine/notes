---
id: 01KYWBDKMHGT3KM4TK3H6Q8KWF
created: 2026-07-31T15:06:56.017422Z
updated: 2026-08-07T10:55:44.223623Z
type: task
title: Freshservice ticket ingest onto the Events screen + scope config
project: 01KX671DATY39VW6GWK3M2T3DN
number: 440
order: 1.125
sprint: s5pft6a
blocked_by:
- 01KYWBD140W250K7BY89WVRB2Z
comments:
- id: 01KYX4KR4KW4DXR9NZ2GKS6VDA
  author: Steve Vine
  at: 2026-07-31T22:27:11.635114Z
  text: |-
    Done — PR #387 (stacked on #386).

    Beat sweep `tasks/freshservice.py` + service module `freshservice.py`. Tickets land on the existing Events screen via `ensure_managed_source` + `store_event`. **No migration.**

    **The three rules the module exists to enforce:**
    1. **One gate.** `in_scope()` carries the scope allow-list and the `ise-generated` exclusion *together*. Two gates in two places is how one of them ends up forgotten on a new code path — and the path that forgets is exactly the one that lets ISE's own ticket feed a burst count.
    2. **One event per ticket, first sighting only.** Updates are not re-emitted, so current ticket state is an Evidence question answered live, never a stale local copy.
    3. **Storing a ticket decides nothing.** Confirmed `raise_signal_for_event` has exactly one caller — the inbound HTTP endpoint, never a poller. There's a test asserting no `Finding` appears after ingesting five tickets.

    **Two choices worth knowing about later:**
    - Fetching uses `updated_since` rather than a created-at filter. That's what makes the sweep self-healing — a ticket created before the window but touched inside it is still seen, so a worker outage costs nothing on the next tick and there's no cursor column to corrupt.
    - The dedupe read is bounded to 7 days so it rides `ix_webhook_event_source_received`. The equivalent releases-dedupe in `tasks/repos.py` scans *all* alert_keys for the source unbounded — fine for releases, wrong at ticket volume. Worth considering for that code too.

    Scope config lives on `System.config` (ADR 0044): `ticket_types` (default `["Incident"]`), `ticket_group_ids`, `exclude_categories`, `ticket_priority_floor`, `ticket_lookback_hours`. Malformed operator config degrades rather than failing a sweep — a non-numeric group id is logged and skipped, a bad priority floor falls back to admitting everything rather than silently discarding the whole stream.

    Verification: 23 scope-gate unit tests + 11 integration tests on real Postgres, including the feedback-loop guard end to end. 140 related tests pass; ruff/format/mypy (465 files) clean.

    **Test-isolation gotcha, same family as the ISE-422 one:** these integration tests share one Postgres for the module, so ten of eleven passed alone and failed together until system names were uniquified per call and every assertion scoped to its own system's managed source.
assignee: steve
priority: medium
task_status: done
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