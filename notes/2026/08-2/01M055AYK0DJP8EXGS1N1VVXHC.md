---
id: 01M055AYK0DJP8EXGS1N1VVXHC
created: 2026-08-16T11:29:29.184233Z
updated: 2026-08-16T14:10:01.152406Z
type: task
title: ADR 0103 + the email transport contract, and SendGrid end to end
project: 01KX671DATY39VW6GWK3M2T3DN
number: 743
sprint: s50x901
assignee: steve
label:
- feature
- brief
priority: high
task_status: active
tech: null
---
The foundation slice, and a complete one: an admin configures SendGrid in **Settings ▸ Email** and receives a test message. Everything else in the sprint stacks on this.

## ADR 0103 — "Email is a transport, chosen once"

Next free number (0102 is the last on origin/main — re-check before writing, a mid-flight release takes the next one). States:

- **Each transport is a connector-backed System**, declaring a new `email` capability. The `MSTeamsConnector` precedent (ADR 0071): a connector with no sync slices and an empty action catalogue whose job is to own a surface. What that inherits rather than rebuilds — encrypted secret storage + rotate (ADR 0018), the per-provider config form drawn from the connector's own `CredentialSpec` (ADR 0031), `health_check` on the normal cadence so a rotated-out key goes degraded on its tile and in the Platform Log (ADR 0027/0077), the enabled toggle, the status pill, the audit trail.
- **Exactly one active sender, and it is a database fact.**
- **Consumers ask the platform, never a mechanism.** Nothing downstream may name SendGrid.
- **SMTP is outside ADR 0092's bounds** and says so here, because the next reader will assume otherwise (see ISE-744).

## Scope

- `email` added to `CONNECTOR_CAPABILITIES` (`connectors/base.py`, near line 58) plus the `send_email` contract on `Connector`.
- **Migration 0140** — `email_sender`, a singleton table: boolean PK with `CHECK (singleton)`, one `system_id` FK `ON DELETE CASCADE`. Choosing a transport upserts the row. Deliberately **not** an `is_active` column on `System`: "only one active sending mechanism" is then enforced by Postgres rather than by a UI convention, and `System` gains no email-specific column.
- `ISE_api/mail/` — the send service. `send(db, *, to, subject, html, text, attachments=())` resolves the active sender, reveals the credential (ADR 0018), delegates to that connector. When there is no active sender, or it is disabled, it refuses with **which** reason — never a bare emptiness (the ISE-631 rule).
- Non-secret identity (`from_email`, `from_name`, `reply_to`) lives in the existing `System.config` JSONB (ADR 0044). No new columns.
- `connectors/sendgrid.py` — `POST /v3/mail/send`, Bearer API key, client built through `http_bounds.client()`. `health_check` = `GET /v3/scopes`, so a key with the wrong scopes is visible *before* a send fails.
- API: `GET`/`PUT /api/v1/email/sender`, `POST /api/v1/email/test` (admin, audited).

## The screen

New **Email** tab in `pages/SettingsPage.tsx` (tab list ~line 485) + `components/EmailCard.tsx`. Sub-section list on the left, the selected transport on the right: **Active** radio, health pill (`components/StatusPill.tsx`), `CredentialFields` (which draws itself from the connector spec — no per-provider UI), from/reply-to, and **Send test email** surfacing the real provider error on failure.

## Watch for

- A new connector type in the registry appears in the general Add-integration picker too. Decide deliberately whether the email types are `hidden` there (they are created from this tab) — `Connector.hidden` already exists for exactly this.
- `dump_openapi` + `npm run generate:api` after the API lands.

---
Sprint 67 order: this task, then ISE-744 (SMTP), ISE-745 (M365), ISE-746 (SES), ISE-747 (notification channels), ISE-748 (report delivery). All five stack on this one.
