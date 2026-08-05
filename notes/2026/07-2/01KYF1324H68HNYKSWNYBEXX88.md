---
id: 01KYF1324H68HNYKSWNYBEXX88
created: 2026-07-26T10:56:17.041501Z
updated: 2026-08-05T19:29:35.930744Z
type: task
title: 'GitHub events: pushes + releases on the Events screen (managed WebhookSource)'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 311
sprint: siyfhjg
blocked_by:
- 01KYF119J3JTFDKGWTQRSY9RXD
comments:
- id: 01KYHCKTES7A4K6BW3P7T5446W
  author: Steve Vine
  at: 2026-07-27T08:56:09.433277Z
  text: |-
    Built 2026-07-27 → Review. PR #294 (stacked on #293, base feature/ise-310 branch), branch feature/ise-311-github-events. Migration is 0063 (renumbered from planned 0062).

    Migration 0063: webhook_source.owner_system_id FK→system CASCADE. GOTCHA: FK/index names MUST follow db.py NAMING_CONVENTION or models_match fails — used fk_webhook_source_owner_system_id_system + ix_webhook_source_owner_system_id (set index=True on the mapped_column to auto-derive). webhooks.ensure_managed_source(db, system): find-or-create by owner_system_id, enabled=False (token minted but resolve_source is enabled-only → never ingests), suffix-on-clash name, created_by=managed:{connector_type}. Deliberate inverse of ADR 0048 (system_id = source→mints→synthetic System; owner_system_id = System→mints→source).

    Sweep tasks/repos.py _emit_events (best-effort, own try/commit): SyncResult gained commits_added + head_message (threaded via _append_commits returning (count, head msg)). Push event alert_key=push:{head_sha}, detail "N new commits; head: …". Releases via connector.repo_releases (new base model RepoReleaseData + github impl), deduped by existing WebhookEvent alert_key=release:{ext_id} (the since-cursor without a new column). webhook_sources_api: _reject_if_managed guard on update/rotate/delete (409); WebhookSourceRead +managed +owner_system; list resolves owner names. WebhookSourcesCard: managed rows read-only ("managed by {system}", "polled", "read-only", no switch/rotate/delete).

    Tests test_github_events.py: managed disabled + token-doesn't-resolve + idempotent; _emit_events push+release + release-dedup-on-rerun; api rotate/delete 409 + list labels managed. Green: mypy 350, ruff, frontend build+eslint, migration models_match + worker registration. OpenAPI regen.
assignee: steve
priority: medium
task_status: done
---
Polled push/release visibility on the existing Events screen — context, not signals.

**Migration 0062** (⚠ renumbered 2026-07-27 — Sprint 25 took 0056–0058): `webhook_source.owner_system_id` (nullable FK → system, ON DELETE CASCADE). A GitHub System gets a lazily-created **managed** WebhookSource (`webhooks.ensure_managed_source(db, system)`), `enabled=False` so its token is never a live ingest URL — external POSTs die at `resolve_source` (enabled-only); server code writes via `store_event` directly. Name-collision with operator sources handled by the `webhook_signals.py` suffix-on-clash trick. This is the deliberate inverse of ADR 0048 (System→from→Source; here Source→from→System) and avoids any change to `webhook_event`, the events API, or `EventsPage.tsx`.

**Sweep integration** (`tasks/repos.py`): on each sync delta write one `push` event (`level: info`, commit count + head message in detail) and `release` events from the releases API (since-cursor). Events show under the GitHub integration's name with `event_type: push|release` filters working.

**Settings**: the webhook-sources card renders managed sources read-only (no rotate/delete/token reveal) with a "managed by {system}" label.

**Acceptance:** after a push and a release, the Events screen shows both under the GitHub source with working type filters; POSTing to the managed source's ingest URL returns the generic 404.

**Files:** new `migrations/*_0062_managed_webhook_source.py`, `tests/integration/test_github_events.py`; mod `models.py`, `webhooks.py`, `tasks/repos.py`, `connectors/github.py` (releases fetch), `api/v1/webhook_sources_api.py` (read-only guard for managed), `SettingsPage.tsx` (webhook sources card), OpenAPI regen.

**Migration chain:** 0062 is last — stacks after 0061; coordinate revision ids with the retrieval branch.