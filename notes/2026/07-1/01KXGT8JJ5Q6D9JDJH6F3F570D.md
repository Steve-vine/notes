---
id: 01KXGT8JJ5Q6D9JDJH6F3F570D
created: 2026-07-14T17:19:44.709888469Z
updated: 2026-07-14T17:19:56.559737947Z
type: task
title: Frontend — actions work queue + dashboard widget
label:
- brief
task_status: done
priority: medium
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 78
sprint: szghwdw
comments:
- id: 01KXGT8Y4FYZ9R1D3TDEGG86ZB
  author: Steve Vine
  at: 2026-07-14T17:19:56.559651069Z
  text: |-
    [Migrated from Linear — Steve Vine, 2026-06-20 08:07 UTC]
    Frontend implemented — PR Steve-vine/compass#72 (→ `main`).

    **Done against the brief:**
    - ✅ **Actions page** (`/actions`, added to the **Company** nav) — unified work queue across gaps, treatment plans and upcoming/overdue reviews: type · what · owner · due · status, red **Overdue** badge + red past-due dates, each row deep-links to its source. Filters: **This company only** / **Owned by me** / **Overdue only** (server-side) + **Type** (Gaps/Treatments/Reviews, client-side). Overdue sorts first.
    - ✅ **Dashboard "My actions" widget** — my open count + overdue tally, links to `/actions`.
    - ✅ **Gap due-date editing** — the Gaps page *Target date* column is now an inline editable date field (PATCHes `target_date`). Note: the brief's "new field from the backend" was actually the pre-existing `target_date` (gaps already had it) — see ADR 0025; no new field was needed.
    - ✅ Patterns: TanStack Query hook, `StatusPill` + overdue badge, `EmptyState`/`Loading`, central success toast on the date edit. Vitest: Actions page (render/empty/overdue-refetch/no-company), filter+label helpers, dashboard widget, gap date PATCH. **Full suite 100 passed**; eslint + tsc + build clean.

    **Sequencing:** per the "sequence, don't stack" rule, DEV-500 (#71) was squash-merged to `main` first (CI green), then this branch was rebased onto `main` so #72 is a **frontend-only** diff.

    **Note for review:** content reviews are library-global (no company), so with **This company only** on they're hidden; turn it off (or use **Owned by me**) to see them. The Type filter groups both review kinds under "Reviews".
---
Frontend for remediation/action tracking (M16), consuming `/api/v1/actions`.

- [ ] **Actions page** — a unified work queue across gaps, treatment plans and upcoming reviews: owner, due date, status, overdue highlighting; filters for **mine / all**, company, and overdue; each row deep-links to the source entity. Add to nav.
- [ ] **Dashboard widget** — "My actions / overdue" summary on the dashboard.
- [ ] Add **due-date editing** to gaps in the gap UI (new field from the backend).
- [ ] Established patterns (TanStack Query, StatusPill for status/overdue, central toasts, loading/empty states); Vitest coverage.

Depends on: Backend — action due dates + unified actions query (<issue id="7b42e4d4-30fb-4d29-90f1-843a13678878" href="https://linear.app/stevevine/issue/DEV-500/backend-action-due-dates-unified-actions-query">DEV-500</issue>).

---
*Migrated from Linear [DEV-507](https://linear.app/stevevine/issue/DEV-507/frontend-actions-work-queue-dashboard-widget) · created 2026-06-19 · completed 2026-06-20*