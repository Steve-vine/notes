---
id: 01KYC4YWCCZM0GHY37VMHWDTER
created: 2026-07-25T08:06:11.084658Z
updated: 2026-08-07T10:09:25.77913Z
type: task
title: 'Webhook event ingestion: schema, storage and tokened endpoint'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 274
sprint: s6pc5xk
comments:
- id: 01KYCBJGXPC9ADHN5S486E97H0
  author: Steve Vine
  at: 2026-07-25T10:01:46.166103Z
  text: |-
    Done. Foundation for the Events integration.

    - ADR 0047 (docs/decisions/0047-webhook-events.md): webhook events as a fifth information source — per-source secret token (Slack-style, the URL is the credential), ISE-defined payload schema, untrusted-data posture (§3, same rule as pulled evidence/documents), retention (§5, built in ISE-278), and the alert-signal semantics (§4, built in ISE-279). Records that ISE-279 owns the Finding↔webhook_source linkage, keeping this schema independent of `system`.
    - Migration 0051: `webhook_source` (name, description, token, enabled, alert_ttl_seconds, last_received_at, created_by) + `webhook_event` (source FK ON DELETE CASCADE, received_at/event_at, level, title, event_type, outcome, status, alert_key, entity_hint, detail, raw payload JSONB). Passes the models-match-migrations autogenerate check.
    - Public ingest: POST /api/v1/webhooks/{token}, mounted like break-glass (no session auth — deliberate public exception documented in main.py). Body-size ceiling checked before parse (413), generic 404 for unknown OR disabled token (reveals neither), ISE-schema validation (422), non-object/invalid-JSON → 400, extra fields preserved verbatim in the raw payload, structured logging that never logs the token or body.
    - webhooks.py: token generation (secrets.token_urlsafe), resolve_source (enabled-only), WebhookPayload schema, store_event (alert_key defaults to event_type per §4). New setting webhook_max_payload_bytes (64KB).

    Acceptance met: a curl with a valid token stores an event; a bad/disabled token is rejected. 8 integration tests green; mypy (293 files) + ruff clean.

    Explicitly headless — screens land in ISE-275 (Settings) and ISE-276 (Events). Committed to feature/ise-274-webhook-ingestion.
assignee: steve
label: null
priority: medium
task_status: done
---
Foundation for the Events integration: external systems (release pipelines, CI, change tooling) can POST a webhook at ISE and have it stored as an event.

- **ADR** (new `docs/decisions/NNNN-webhook-events.md`): webhook events as a first-class information source — per-source secret-token auth (Slack-style unique endpoint per source), ISE-defined payload schema, untrusted-data posture (events are data, never instructions — same rule as pulled evidence), retention, and the **signal semantics**: events carry a `level`; alert-level events additionally raise Alert signals (built in ISE-279), recovering via an explicit `status: recovered` webhook or a per-source TTL fallback.
- **Migration 0051**: `webhook_source` (name, description, token, enabled, alert TTL, created_at, last_received_at) and `webhook_event` (source FK, received_at, event timestamp, level, title, event_type, outcome, status, alert_key, entity hint, detail, raw payload JSONB).
- **Public ingest endpoint** — `POST` outside session auth (own router, mounted like break-glass, exposed through the existing ingress). The token in the URL identifies the source; unknown or disabled sources are rejected. Validates the ISE schema: required `title`; optional `level` (info | warn | alert, default info), `event_type`, `outcome`, `status` (firing | recovered), `alert_key`, `entity` (name/alias hint), `timestamp`, `detail` (markdown); any extra fields kept in the raw payload. Payload size limit, structured logging, no secrets logged.
- All schema fields are stored in this task; the signal-raising *behaviour* for alert-level events is ISE-279 — senders never see a v1 schema without the signal fields.

**Explicitly headless** — the screens land in the follow-on tasks (Settings source management, Events screen). Acceptance here: a curl with a valid token stores an event; a bad/disabled token is rejected.