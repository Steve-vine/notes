---
id: 01M055AYK0DJP8EXGS1N1VVXHC
created: 2026-08-16T11:29:29.184233Z
updated: 2026-08-17T10:59:58.934998Z
type: task
title: The email transport contract + ADR, and SendGrid end to end
project: 01KX671DATY39VW6GWK3M2T3DN
number: 743
sprint: s50x901
comments:
- id: 01M05GR6DD4NT6JHT91FQ9SCM6
  author: Steve Vine
  at: 2026-08-16T14:48:57.516865Z
  text: |-
    Built and pushed as PR #692 — move to Review.

    ADR **0106** and migration **0142**, not the 0103/0140 the task proposed: Sprint 64 merged earlier today and took ADRs 0103-0105 and migrations 0140/0141. Re-checked origin/main before writing, per the parallel-numbering trap.

    What landed:
    - ADR 0106 "Email is a transport, chosen once" — each transport a connector-backed System declaring a new `email` capability (the MSTeamsConnector shape); exactly one active, as a singleton table; consumers ask the platform, never a mechanism; and SMTP's exemption from ADR 0092 written down for ISE-744.
    - `email` in CONNECTOR_CAPABILITIES + `EmailMessage`/`EmailAttachment` + the `send_email` contract on Connector.
    - Migration 0142 — `email_sender`, boolean PK with CHECK (singleton), FK ON DELETE CASCADE. Asserted BELOW the API too: a raw INSERT of a second row is refused.
    - `ISE_api/mail/` — `send()` resolves the active sender, reveals the credential, delegates. `unavailable_reason()` is served to the UI as well as used by `send`, so the screen and a real send cannot disagree.
    - `connectors/sendgrid.py` — hidden Type, `POST /v3/mail/send`, health = `GET /v3/scopes`.
    - `GET`/`PUT /api/v1/email/sender`, `PUT /email/transports/{id}/identity`, `POST /email/test`.
    - Settings ▸ Email tab + `components/EmailCard.tsx`.

    Three judgement calls worth recording:

    1. **Health checks the key's SCOPES, not just that it authenticates.** A restricted SendGrid key authenticates perfectly and refuses every message — a token probe reports `connected` right up until the first notice goes missing. Reports `degraded` naming the missing grant. A full-access key reports NO scopes at all, which is deliberately not treated as a missing grant, or every correctly-configured deployment would flag.

    2. **The attachment cap is the tightest transport's, not the active one's.** ~3MB (Graph's simple sendMail, ISE-745), enforced in `mail/` for every transport. The active sender can change under a consumer that has already composed its message: a report that attached happily under SendGrid must not start failing the day someone switches to Exchange. This is the number ISE-748 divides on.

    3. **The email Types are `hidden` from the add-integration picker.** The task flagged this as a decision to take deliberately. Taken: they are created from Settings ▸ Email, where the choice of active sender is made, and a list whose other entries mean "a system to monitor" is the wrong place to offer "the way mail leaves". They stay ordinary Systems everywhere else.

    One test-shape note for the tasks that stack on this: `tests/integration/test_email_sender.py` truncates `email_sender, system, credential CASCADE` per test. The module database is shared, and "how many transports are there" / "is one active" assertions otherwise pass or fail on which test ran first — the flake that only shows up once the suite reshuffles under xdist.

    Full backend + frontend suites green locally; ruff/mypy/eslint/prettier/tsc clean.
assignee: steve
label:
- feature
- brief
priority: high
task_status: done
tech: null
---
The foundation slice, and a complete one: an admin configures SendGrid in **Settings ▸ Email** and receives a test message. Everything else in the sprint stacks on this.

## ADR — "Email is a transport, chosen once"

**Take the next free number, and check `origin/main` first.** This has already moved: 0103/0104/0105 went to ISE-740/741/742 on 2026-08-16, and ISE-749 claims 0106. Do not trust a number written in a task body.

States:

- **Each transport is a connector-backed System**, declaring a new `email` capability. The `MSTeamsConnector` precedent (ADR 0071): a connector with no sync slices and an empty action catalogue whose job is to own a surface. What that inherits rather than rebuilds — encrypted secret storage + rotate (ADR 0018), the per-provider config form drawn from the connector's own `CredentialSpec` (ADR 0031), `health_check` on the normal cadence so a rotated-out key goes degraded on its tile and in the Platform Log (ADR 0027/0077), the enabled toggle, the status pill, the audit trail.
- **Exactly one active sender, and it is a database fact.**
- **Consumers ask the platform, never a mechanism.** Nothing downstream may name SendGrid.
- **SMTP is outside ADR 0092's bounds** and says so here, because the next reader will assume otherwise (see ISE-744).

## Scope

- `email` added to `CONNECTOR_CAPABILITIES` (`connectors/base.py`, near line 58) plus the `send_email` contract on `Connector`.
- **Migration — next free** (head was 0141 on 2026-08-16 and ISE-749 claims the next; re-check). `email_sender`, a singleton table: boolean PK with `CHECK (singleton)`, one `system_id` FK `ON DELETE CASCADE`. Choosing a transport upserts the row. Deliberately **not** an `is_active` column on `System`: "only one active sending mechanism" is then enforced by Postgres rather than by a UI convention, and `System` gains no email-specific column.
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
Sprint order: this task, then ISE-744 (SMTP), ISE-745 (M365), ISE-746 (SES), ISE-747 (notification channels), ISE-748 (report delivery). All five stack on this one.
