---
id: 01M23RGHGFYCEGX43F5JPJHDE4
created: 2026-09-09T18:57:30.127097Z
updated: 2026-09-09T19:28:09.005539Z
type: task
title: The nightly posture snapshot — one row per company per day, written by Beat
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 636
sprint: srtvjyn
blocked_by:
- 01M23RG7ENVERE0H3ZQNC0BTGP
assignee: steve
label:
- feature
priority: high
task_status: active
---
Every night, for every active company, Compass records what its posture was that day. From this task on the line has a future; the backfill gives it a past.

- New model `PostureSnapshot` (`posture_snapshots`): `company_id` (CASCADE), `observed_on` (Date), `source` (`observed` | `reconstructed`, a Postgres enum — create it explicitly, then reference with `create_type=False`), the headline scalars as columns (applicable, assessed, implemented, compliance_percent, avg_maturity, open_gaps, overdue_gaps, risks_total, risks_over_appetite), and the breakdowns as JSONB (`tiers`, `domains`, `frameworks`, `risk_bands`) — exactly the `PostureMeasure` from `core/posture.py`, serialised. Unique on (company, day). Follow `membership_coverage_snapshot.py` for shape and docstring tone.
- `tasks/posture_snapshot.py`: `take_posture_snapshots()` — for each non-archived company, `measure()` and **upsert** today's row as `observed`. Idempotent: running twice in a day rewrites the same row. Beat entry in `core/celery_app.py` at 23:30 wall-clock (ADR 0006) — end of the working day, so "today's point" is what the day ended on. Comment the entry in the style of the others.
- An observed row **always wins**: the upsert overwrites a `reconstructed` row for the same day; nothing overwrites an `observed` one except a later observation of the same day.
- Not audited (ADR 0023 allowlist untouched); no revisions; no activity-log noise.
- Integration test against real Postgres: two companies, run twice, one row each, values match the Dashboard endpoint's response for the same company.

Not in this task: the read API (its own task), the backfill (its own task), and a "take snapshot now" button — if a deploy-day point turns out to be wanted, that's a follow-up.