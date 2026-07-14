---
id: 01KXGT8JJ5Q6D9JDJH6F3F570D
created: 2026-07-14T17:19:44.709888469Z
updated: 2026-07-14T17:19:44.709888469Z
type: task
title: Frontend — actions work queue + dashboard widget
label: brief
task_status: done
priority: medium
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 78
---
Frontend for remediation/action tracking (M16), consuming `/api/v1/actions`.

- [ ] **Actions page** — a unified work queue across gaps, treatment plans and upcoming reviews: owner, due date, status, overdue highlighting; filters for **mine / all**, company, and overdue; each row deep-links to the source entity. Add to nav.
- [ ] **Dashboard widget** — "My actions / overdue" summary on the dashboard.
- [ ] Add **due-date editing** to gaps in the gap UI (new field from the backend).
- [ ] Established patterns (TanStack Query, StatusPill for status/overdue, central toasts, loading/empty states); Vitest coverage.

Depends on: Backend — action due dates + unified actions query (<issue id="7b42e4d4-30fb-4d29-90f1-843a13678878" href="https://linear.app/stevevine/issue/DEV-500/backend-action-due-dates-unified-actions-query">DEV-500</issue>).

---
*Migrated from Linear [DEV-507](https://linear.app/stevevine/issue/DEV-507/frontend-actions-work-queue-dashboard-widget) · created 2026-06-19 · completed 2026-06-20*