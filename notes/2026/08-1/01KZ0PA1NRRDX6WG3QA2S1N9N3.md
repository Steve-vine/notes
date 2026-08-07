---
id: 01KZ0PA1NRRDX6WG3QA2S1N9N3
created: 2026-08-02T07:34:11.384189Z
updated: 2026-08-07T12:15:41.512627Z
type: task
title: Integration State toggle is not enforced on three paths (status pages, Teams notifications, change executor)
project: 01KX671DATY39VW6GWK3M2T3DN
number: 461
sprint: sfv5yw0
assignee: steve
label: null
priority: high
task_status: done
---
The **State** toggle on Settings → Integrations (`System.enabled`) is meant to be the whole-integration switch — nothing runs when it is off. The code says so at `app/frontend/src/pages/SystemDetailPage.tsx:337` ("`enabled` is the whole-integration switch — the toggle governs the schedule only").

Found live: a **disabled status page integration is still populating the estate**. An audit of every background entry point (Celery beat schedule, `worker.py:72-193`) found two more paths with the same gap.

## 1. Status pages — reads, estate writes, alerts and AI spend (the reported one)

`status_pages.due_for_check()` (`app/backend/src/ISE_api/status_pages.py:636-642`) selects **every** `StatusPage` row on cadence alone — no join to `System`, no `enabled` check — and nothing downstream re-checks. A disabled statuspage integration still:

- fetches the provider's page every tick (`check_page`, sweep runs every 60s)
- **creates and re-stamps `third-party` estate entities** — `_record` → `reconcile_entities` at `status_pages.py:811` sets `last_seen_at`, so they never retire either (ADR 0039 window never opens)
- spends AI on the comprehension fallback (`tasks/status_pages.py:56`)
- writes and promotes Alert findings (`reconcile_signals`, `tasks/status_pages.py:59`)

`enabled` is consulted only in `status_page_systems()` (`status_pages.py:61-70`), which filters the "which integration" dropdown at registration time and has no effect once a page is registered.

## 2. Teams notifications — a disabled integration keeps posting

ISE-459 / ADR 0071 made Teams a System and gave `NotificationChannel` a mandatory `system_id`. Routing still gates on the channel only: `notifications.py:56` (`channel_matches`) and `notifications.py:74` (`channels_for_event`) check `channel.enabled`. The delivery path `_send` loads the System at `notifications.py:493` purely to resolve the bot credential and never checks `enabled`.

Switching the Teams integration off in Settings → Integrations does not stop cards going out.

## 3. Change executor — WRITES against a switched-off integration

`tasks/actions/execute.py:63-74` pre-flights that the System exists and has a `write_credential_ref`, but never checks `enabled`. An approved change therefore executes a mutation against an integration the operator has switched off. A human approved it, so it is not silent — but "disabled" should mean ISE does not touch the system, and this is the write path.

## Verified clean

State sync (`sync.py:41,192,322`), Obs Loop (`obs_loop.py:48,62,80`), document sweep (`documents.py:208`), repo sweep (`repos.py:401`), Freshservice poll (`freshservice.py:310`), AI tool listing (`ai/tools.py:390`), MCP discover (`mcp_server/tools_discover.py:42`), sync-now / obs-now endpoints (`api/v1/systems.py:161,176`). Dashboards and webhook ingest are not System-backed — `WebhookSource` is deliberately its own thing (ADR 0047 §1) with its own `enabled`, which is honoured at `webhooks.py:103`.

## Fix

Adopt the document/repo shape everywhere — a guard that degrades rather than throws, plus a query filter so disabled work is never picked up:

1. **Status pages** — join `System` in `due_for_check` so disabled (and orphaned, `system_id IS NULL`) pages are not fetched, matching how an orphaned document is skipped. Also add the guard inside `check_page` returning `detail="source disabled"` so the register screen can say *why* a page has gone quiet instead of just looking stale. Refuse `POST /status-pages/{id}/check` when disabled, as `sync-now` already does at `api/v1/systems.py:161`.
2. **Notifications** — extend `channels_for_event` to join `System` on `System.enabled`, and re-check in `_send` so an already-queued delivery does not go out after the toggle flips.
3. **Change executor** — add an `enabled` check to the `execute.py` pre-flight, failing the change with a clear operator message in the same shape as the no-write-credential path.

Add a regression test per path; the shared assertion is "integration disabled → no external call, no estate/signal write".

## Cleanup

Third-party entities minted by disabled status page integrations exist in the prod estate today. Once the gate lands they stop being stamped and retire on the ADR 0039 window — confirm that is acceptable rather than needing an explicit sweep.
