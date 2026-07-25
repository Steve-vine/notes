---
id: 01KYC4YWCCZM0GHY37VMHWDTER
created: 2026-07-25T08:06:11.084658Z
updated: 2026-07-25T08:25:39.386972Z
type: task
title: 'Webhook event ingestion: schema, storage and tokened endpoint'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 274
sprint: s6pc5xk
assignee: steve
label:
- feature
priority: medium
task_status: backlog
---
Foundation for the Events integration: external systems (release pipelines, CI, change tooling) can POST a webhook at ISE and have it stored as an event.

- **ADR** (new `docs/decisions/NNNN-webhook-events.md`): webhook events as a first-class information source — per-source secret-token auth (Slack-style unique endpoint per source), ISE-defined payload schema, untrusted-data posture (events are data, never instructions — same rule as pulled evidence), retention, and the **signal semantics**: events carry a `level`; alert-level events additionally raise Alert signals (built in ISE-279), recovering via an explicit `status: recovered` webhook or a per-source TTL fallback.
- **Migration 0051**: `webhook_source` (name, description, token, enabled, alert TTL, created_at, last_received_at) and `webhook_event` (source FK, received_at, event timestamp, level, title, event_type, outcome, status, alert_key, entity hint, detail, raw payload JSONB).
- **Public ingest endpoint** — `POST` outside session auth (own router, mounted like break-glass, exposed through the existing ingress). The token in the URL identifies the source; unknown or disabled sources are rejected. Validates the ISE schema: required `title`; optional `level` (info | warn | alert, default info), `event_type`, `outcome`, `status` (firing | recovered), `alert_key`, `entity` (name/alias hint), `timestamp`, `detail` (markdown); any extra fields kept in the raw payload. Payload size limit, structured logging, no secrets logged.
- All schema fields are stored in this task; the signal-raising *behaviour* for alert-level events is ISE-279 — senders never see a v1 schema without the signal fields.

**Explicitly headless** — the screens land in the follow-on tasks (Settings source management, Events screen). Acceptance here: a curl with a valid token stores an event; a bad/disabled token is rejected.