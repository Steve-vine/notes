---
id: 01KXGT7EQDK0BWNV8BF3T387Y9
created: 2026-07-14T17:19:08.013251688Z
updated: 2026-07-14T18:33:23.115959596Z
type: task
title: Activity feed UI + per-entity history
label:
- brief
task_status: done
priority: medium
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 76
sprint: sxptdhb
blocked_by:
- 01KXGT31JG6786KXXZTQ4AZ27K
---
Frontend for the audit trail (M14), consuming the `/api/v1/activity` API.

- [ ] **Admin Activity page** — paginated, filterable feed (by actor, entity type, date range, company); each row links to the affected entity. Add to the Admin section / nav.
- [ ] **Per-entity History tab** — an "Activity / History" view on the control, risk, gap, content, and decision detail pages showing that entity's trail.
- [ ] Use the established patterns (TanStack Query, StatusPill where relevant, loading skeletons, empty states).
- [ ] Vitest coverage for the feed + filters.

Depends on: Activity log model + capture + API (<issue id="f0948ebd-76f9-4a47-82f7-31a28143acc1" href="https://linear.app/stevevine/issue/DEV-498/activity-log-model-capture-api">DEV-498</issue>).

---
*Migrated from Linear [DEV-505](https://linear.app/stevevine/issue/DEV-505/activity-feed-ui-per-entity-history) · created 2026-06-19 · completed 2026-06-19*