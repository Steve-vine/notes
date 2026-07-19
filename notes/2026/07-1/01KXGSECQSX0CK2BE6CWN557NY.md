---
id: 01KXGSECQSX0CK2BE6CWN557NY
created: 2026-07-14T17:05:26.777908212Z
updated: 2026-07-14T18:32:54.03374212Z
type: task
title: Notifications & reminders (Celery Beat)
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 46
sprint: sd5fyv6
blocked_by:
- 01KXGS9Z64EZRB79H2HF29BQJH
comments:
- id: 01KXGSET9MVP6FVEJ8K3ARR95J
  author: Steve Vine
  at: 2026-07-14T17:05:40.660813604Z
  text: |-
    [Migrated from Linear — Steve Vine, 2026-06-17 16:20 UTC]
    **Done — in review.** PR [#42](https://github.com/Steve-vine/compass/pull/42) (`steve/dev-460-notifications-reminders-celery-beat`).

    **What was built** — the Beat scheduler now carries real jobs (backend).
    - `Notification` — per-user, polymorphic target (content/assessment/treatment), read/unread; unique `(user, kind, target, due_on)` = idempotency key.
    - `tasks/reminders.generate_reminders` — daily 07:00 UTC; flags content review due/approaching, assessments due, overdue treatment plans → their owners; new items → one best-effort digest email per owner (no-op without SMTP), deep-linked via `app_base_url`.
    - API `/notifications`: list (`?unread`), unread-count, mark-read, read-all — strictly self-scoped.
    - `Settings.reminder_lead_days` (7); migration `0016`; Celery `include` + `beat_schedule` wired.

    **Decisions made on the fly**
    - Dedup key includes `due_on` → a rescheduled item raises a fresh reminder, not a mutated one.
    - "Risk overdue" surfaced via overdue treatment plans (risks carry no due date).

    **Problems encountered** — none of note; a `rowcount` typing nit (switched `read-all` to load-and-set) and one long-line/lint fix.

    **Checks** — green locally: `ruff check .`, `ruff format --check .`, `mypy src`, `pytest` (31), `pytest -m integration` (113, incl. 3 new). Migration up/down exercised by the per-test cycle.

    UI follow-up: [DEV-464](https://linear.app/stevevine/issue/DEV-464).
assignee: steve
label:
- brief
priority: medium
task_status: done
---
Proactive reminders so the living playbook stays current — review-due and overdue work surfaced to owners. Activates the Beat scheduler (idle since <issue id="7f7d24b6-5a6f-4707-95aa-6ac2206631b3" href="https://linear.app/stevevine/issue/DEV-416/wire-celery-app-broker-workerbeat-readyz-broker-check">DEV-416</issue>). **Backend only**; the top-bar bell UI is <issue id="e93f22f3-c30c-47b2-b5a0-9426bd57ff36" href="https://linear.app/stevevine/issue/DEV-464/notifications-ui-top-bar-bell">DEV-464</issue>.

**Agreed approach (planned 2026-06-17).** Mirrors `tasks/email.py`/`tasks/health.py` conventions + the polymorphic-target pattern.

- [ ] `Notification` **model** (UUID + Timestamp): `user_id` (FK CASCADE), `kind` (content_review_due / assessment_review_due / treatment_overdue), `target_type` + `target_id` (polymorphic), `title`, `body`, `due_on: date`, `read_at`. **Unique** `(user_id, kind, target_id, due_on)` — the idempotency key.
- [ ] **Beat job** `tasks/reminders.py` **→** `generate_reminders()` (idempotent, IDs-not-objects, JSON-only; daily 07:00 UTC via `beat_schedule`): published content `next_review_at <= today + reminder_lead_days`; assessments `next_review_at <= today`; treatment plans `due_date < today` & status open/in_progress (risks have no date — surfaced via treatment plans). Upsert by dedup key (skip existing); collect new-per-user → **one digest email per user** (best-effort; `send_email` no-op without SMTP), deep-linked via `app_base_url`.
- [ ] **API** `api/v1/notifications.py` (own notifications, any auth): `GET /notifications` (`?unread=true`), `GET /notifications/unread-count`, `POST /notifications/{id}/read`, `POST /notifications/read-all`.
- [ ] **Schemas** `NotificationOut`, `UnreadCount`; `Settings.reminder_lead_days = 7`; register task (Celery `include` + `beat_schedule`), router, model. Migration `0016_notifications.py` (down_revision `0015`).
- [ ] **Tests** (`tests/test_reminders.py`, real-Postgres): generate_reminders creates the right notifications + idempotent (2nd run none) + skips no-owner/not-due; API list/unread/unread-count/mark-read/read-all + own-only scoping; digest email via monkeypatched `send_email`.

Refs: ADR 0006, 0017, 0011, 0012. Builds on Celery (<issue id="7f7d24b6-5a6f-4707-95aa-6ac2206631b3" href="https://linear.app/stevevine/issue/DEV-416/wire-celery-app-broker-workerbeat-readyz-broker-check">DEV-416</issue>) + SMTP (<issue id="7375fbce-9b2d-48eb-a496-b47cfc515dd8" href="https://linear.app/stevevine/issue/DEV-417/email-based-password-reset-forgot-password">DEV-417</issue>). Out of scope → <issue id="e93f22f3-c30c-47b2-b5a0-9426bd57ff36" href="https://linear.app/stevevine/issue/DEV-464/notifications-ui-top-bar-bell">DEV-464</issue> (top-bar bell UI).

---
*Migrated from Linear [DEV-460](https://linear.app/stevevine/issue/DEV-460/notifications-and-reminders-celery-beat) · created 2026-06-17 · completed 2026-06-17*  
*Related to (Linear): DEV-417, DEV-416, DEV-728*