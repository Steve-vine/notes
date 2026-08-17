---
id: 01M068503XXKPYFGD6AF6YCS8C
created: 2026-08-16T21:37:54.301222Z
updated: 2026-08-17T18:48:23.496361Z
type: task
title: The email transport contract + ADR, and SendGrid end to end
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 230
sprint: ssydm1m
comments:
- id: 01M07TAVVDEYX0MJJCHM4G84TV
  author: Steve Vine
  at: 2026-08-17T12:14:55.341802Z
  text: 'Done and merged to main (PR #230, squash 1052b2a). ADR 0044 "Email is a transport, chosen once": email_transports table (migration 0059) with Fernet-encrypted write-only credential blobs, exactly one active sender enforced by a Postgres partial unique index (a raw second active row is refused — tested), core/mail.send with the shared unavailable_reason() string so the screen and a refused send can never disagree, and the global ~3MB attachment cap. SendGrid ships end to end: send via /v3/mail/send, health via /v3/scopes checking the mail.send scope (full-access keys return no scopes and are deliberately OK), a 5-minute Beat check that provably dispatches freshly-created transports (the ISE-750 lesson, asserted by creating through the API alone), and the Admin ▸ Email tab with Active radio, Health pill ("Not checked yet" when never checked), and test send surfacing the real provider error. ADR decision on the env vars: SMTP_* become a one-time seed (executed in COM-231), never a runtime fallback. m365_settings also joined the audited tables while adding email_transports.'
assignee: steve
label:
- feature
- brief
priority: high
task_status: done
---
The foundation slice, and a complete one: an admin configures SendGrid in **Admin ▸ Email** and receives a test message. Everything else in the sprint stacks on this. Supersedes the COM-79 candidate; the model is the one proven in ISE sprint 67 (ISE-743, ADR 0106 there), translated to Compass's own mechanisms.

## ADR — "Email is a transport, chosen once"

**Take the next free number** (head is 0043 on 2026-08-16 — re-check `origin/main`; the parallel-numbering trap is real). It amends ADR 0007's "email = env-driven SMTP" assumption. States:

- **Each transport is a row in a new `email_transports` table** — the `M365Settings` + `core/secretbox.py` precedent (DEV-772, ADR 0034), generalised: `kind` (`sendgrid | smtp | m365 | ses`), `name` (so the audit log's `_LABEL_ATTRS` reads well), `enabled`, Fernet-encrypted credentials, non-secret config, and health columns (`health`, `health_checked_at`, `health_message`). Secrets write-only through the API, never returned; name the fields `*_secret`/`*_password`/`*_key` so `DEFAULT_REDACT_KEYS` (`core/config.py:20`) covers the logs automatically.
- **Exactly one active sender, and it is a database fact.** Compass's own singleton idiom, used twice already: a partial unique index on a boolean (`uq_companies_single_default`, `models/company.py:29`; `uq_vendor_forms_onboarding`, `models/vendor_form.py:39`). `is_active` + `Index(..., unique=True, postgresql_where=text("is_active"))`. Assert it below the API too — a raw second active row is refused by Postgres. (ISE used a separate singleton table to keep email columns off a shared `System` table; Compass's transport table is new and email-specific, so the column + partial index is the native shape — record the divergence and why.)
- **Consumers ask the platform, never a mechanism.** Nothing downstream may name SendGrid. `core/email.py`'s silent no-op path is rewired in the consumers task.
- **The env-var question, decided.** `core/config.py:84-89` still carries `smtp_*`; `get_m365_config` (`core/graph.py:79`) is the DB-first-env-fallback precedent. Decide whether the SMTP env settings survive as a fallback (they are how staging reaches Mailpit today — `chart/values-staging.yaml:145`) or become a seed for a first SMTP transport row. Either is fine; write it down.
- Email settings are **global, not company-scoped** — like `m365_settings`.

## Scope

- **Migration — next free** (head `0058_vendor_contact_position` on 2026-08-16; re-check `origin/main`). Template: `migrations/versions/0033_m365_settings.py`. Re-export the model from `models/__init__.py` or autogenerate never sees it.
- `core/mail.py` — the send service. `send(db, *, to, subject, html, text, attachments=())` resolves the active sender, decrypts (`core/secretbox`), delegates to the transport implementation. When there is no active sender, or it is disabled, it refuses with **which** reason — `unavailable_reason()` is served to the UI as well as used by `send`, so the screen and a failed send can never disagree.
- **The attachment cap is the tightest transport's, not the active one's** — ~3MB (Graph's simple sendMail; see the M365 task), enforced in `core/mail.py` for every transport. The active sender can change under a consumer that has already composed its message.
- Non-secret identity (`from_email`, `from_name`, `reply_to`) on the transport row.
- **SendGrid transport** — `POST /v3/mail/send`, Bearer key, sync `httpx` with an **explicit timeout** (the `core/graph.py:151` `timeout=30` shape — Compass has no shared HTTP-bounds layer, so every transport sets its own; prefer plain httpx over the SendGrid SDK, matching `core/graph.py`). Health = `GET /v3/scopes`: check the key's **scopes**, not merely that it authenticates — a restricted key authenticates perfectly and refuses every message. A full-access key returns NO scopes at all; deliberately not a missing grant, or every correctly-configured deployment flags.
- **Health checks actually run.** A Beat entry (`core/celery_app.py:54` `beat_schedule`; register the task module in `include=` at line 32) health-checks enabled transports every ~5 minutes and writes the health columns. Bake in the ISE-750 lesson rather than finding it on smoke: every transport test calling the check directly is how "it never executes" ships — **assert that a freshly-created transport gets dispatched, exercising the create path alone** (ISE's first version of that test passed with the fix deleted, because a helper PATCHed after create). Worker sessions are actorless, so the periodic write creates no audit noise — if it ever does, the `api_tokens`/`last_used_at` skip at `db/audit.py:140` is the pattern.
- API: transports CRUD + `GET`/`PUT /api/v1/email/sender` + `POST /api/v1/email/test` — per-endpoint `Depends(require_admin)` (`core/auth.py:103`), `APIError` envelope, schemas in `api/v1/schemas.py`, router registered in `api/v1/router.py`. Add `email_transports` to `_AUDITED_TABLES` (`db/audit.py:32`) — note `m365_settings` never was; consider adding it while there.

## The screen

New **Email** tab in `pages/AdminPage.tsx` (tab list ~line 39) + `src/admin/EmailSection.tsx`, following `IntegrationsSection.tsx`'s shape (useQuery/useMutation with `meta.successMessage`, write-only secret field with "Stored encrypted; never shown again.", test mutation rendering an Alert). Transport list on the left, selected transport on the right: **Active** radio, health pill (`StatusPill` + `statusColors.ts` — add the new keys there, not inline), per-kind credential form, from/reply-to, and **Send test email** surfacing the real provider error on failure.

Label the pill **Health**, and render a never-checked transport as **"Not checked yet"** — never a bare "Disabled" beside an Enabled toggle (the ISE-750 screen half).

## Watch for

- Regenerate `schema.d.ts` in the same PR (`npm run generate:api`; the offline route works without a server) — CI gates drift on push→main.
- Test isolation: "how many transports / is one active" assertions truncate `email_transports` per test (`tests/test_integrations.py` is the fixture template, including the `lru_cache` `cache_clear()` dance), or they pass or fail on which test ran first — the ISE-743 xdist flake.

---
Sprint order: this task, then SMTP, M365, SES (stack on this one, land in any order), then the consumers rewire closes the sprint.