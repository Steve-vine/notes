---
id: 01KYF1324H68HNYKSWNYBEXX88
created: 2026-07-26T10:56:17.041501Z
updated: 2026-07-27T08:45:46.540946Z
type: task
title: 'GitHub events: pushes + releases on the Events screen (managed WebhookSource)'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 311
sprint: siyfhjg
blocked_by:
- 01KYF119J3JTFDKGWTQRSY9RXD
assignee: steve
label:
- feature
priority: medium
task_status: active
---
Polled push/release visibility on the existing Events screen — context, not signals.

**Migration 0062** (⚠ renumbered 2026-07-27 — Sprint 25 took 0056–0058): `webhook_source.owner_system_id` (nullable FK → system, ON DELETE CASCADE). A GitHub System gets a lazily-created **managed** WebhookSource (`webhooks.ensure_managed_source(db, system)`), `enabled=False` so its token is never a live ingest URL — external POSTs die at `resolve_source` (enabled-only); server code writes via `store_event` directly. Name-collision with operator sources handled by the `webhook_signals.py` suffix-on-clash trick. This is the deliberate inverse of ADR 0048 (System→from→Source; here Source→from→System) and avoids any change to `webhook_event`, the events API, or `EventsPage.tsx`.

**Sweep integration** (`tasks/repos.py`): on each sync delta write one `push` event (`level: info`, commit count + head message in detail) and `release` events from the releases API (since-cursor). Events show under the GitHub integration's name with `event_type: push|release` filters working.

**Settings**: the webhook-sources card renders managed sources read-only (no rotate/delete/token reveal) with a "managed by {system}" label.

**Acceptance:** after a push and a release, the Events screen shows both under the GitHub source with working type filters; POSTing to the managed source's ingest URL returns the generic 404.

**Files:** new `migrations/*_0062_managed_webhook_source.py`, `tests/integration/test_github_events.py`; mod `models.py`, `webhooks.py`, `tasks/repos.py`, `connectors/github.py` (releases fetch), `api/v1/webhook_sources_api.py` (read-only guard for managed), `SettingsPage.tsx` (webhook sources card), OpenAPI regen.

**Migration chain:** 0062 is last — stacks after 0061; coordinate revision ids with the retrieval branch.