---
id: 01KXGT4BB2S5Z62SSW7C34J6V3
created: 2026-07-14T17:17:26.242180388Z
updated: 2026-07-14T17:17:26.242180388Z
type: task
title: Backend — action due dates + unified actions query
task_status: done
label: brief
priority: medium
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 71
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