---
id: 01KXGT4BB2S5Z62SSW7C34J6V3
created: 2026-07-14T17:17:26.242180388Z
updated: 2026-07-18T17:25:29.618719Z
type: task
title: Backend — action due dates + unified actions query
task_status: done
label:
- brief
priority: medium
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 71
comments:
- id: 01KXGT4RNPRXEKNTNPVRJ61GSC
  author: Steve Vine
  at: 2026-07-14T17:17:39.894733749Z
  text: |-
    [Migrated from Linear — Steve Vine, 2026-06-20 07:46 UTC]
    Backend implemented — PR Steve-vine/compass#71 (code) + Steve-vine/projects#6 (ADR 0025).

    **Done against the brief:**
    - ✅ **Decision recorded** (ADR 0025): derived aggregation, not a first-class `Action` entity — source rows stay the single source of truth.
    - ✅ `GET /api/v1/actions` aggregating open/in-progress gaps + active treatment plans + upcoming assessment/content reviews, each normalised to `{type, id, title, owner_id, owner, status, due_date, overdue, link, company_id}`. Filters: `mine` / `company` / `overdue` / `status`.
    - ✅ Reuses reminders due/overdue logic — extracted into a shared `core/due.py` (`is_overdue`, `review_lead_window`) now used by **both** the actions query and the reminders Beat job.
    - ✅ Integration tests: aggregation, owner/due/overdue, all filters, company scoping, exclusion of closed/done/far-future work. Full backend suite **150 passed**; ruff + mypy strict clean.

    **One deviation — no migration:** the brief assumed gaps lacked a date field, but **gaps already have `target_date`**. Adding a second `due_date` alongside it would create two competing date fields, so I reused `target_date` as the gap's due date. Net: **no schema change** for M16 backend (treatment plans already have `due_date`; reviews use `next_review_at`). Gap due-date editing for DEV-507 operates on the existing `target_date`, which the gap create/update API already accepts.

    `type` resolves to four concrete values — `gap` / `treatment` / `assessment_review` / `content_review` — so the frontend (DEV-507) can icon/group/deep-link each directly. Note for DEV-507: content reviews are library-global (no company), so they show in the unfiltered / `mine` queue but not under a specific `company` filter.
sprint: szghwdw
---
Backend for remediation/action tracking (M16) — a unified, due-dated view of outstanding work.

- [ ] **Decide (short ADR/note):** first-class `Action` entity vs a **derived aggregation** over existing gaps + treatment plans + upcoming reviews. Lean derived to avoid duplicate state/source-of-truth drift; record the decision.
- [ ] Add `due_date` (+ optional `target_date`) to the `gap` model + **Alembic migration** (treatment plans already have `due_date`; gaps currently don't).
- [ ] `GET /api/v1/actions` aggregating: open/in-progress gaps, active treatment plans, and upcoming assessment/content reviews — each normalised to {type, title, owner, status, due_date, overdue, link}. Filters: `mine` (current user as owner), `company`, `overdue`, status.
- [ ] Reuse the reminders/notifications due/overdue logic where possible (single source of "what's due").
- [ ] Tests (integration): aggregation returns gaps + treatments + reviews with correct owner/due/overdue; `mine` and `overdue` filters; company scoping; gap due_date persists and surfaces.

New subsystem (beyond ADR 0014). Builds on existing owners (gap/treatment) + the reminders engine.

---
*Migrated from Linear [DEV-500](https://linear.app/stevevine/issue/DEV-500/backend-action-due-dates-unified-actions-query) · created 2026-06-19 · completed 2026-06-20*