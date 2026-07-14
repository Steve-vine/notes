---
id: 01KXGSGFWJFBTYSSN8Y296C606
created: 2026-07-14T17:06:35.538284207Z
updated: 2026-07-14T17:06:35.538284207Z
type: task
title: 'Notifications UI: top-bar bell'
task_status: done
label: brief
priority: medium
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 48
---
The top-bar notifications bell (frontend), against the merged <issue id="1c292ad6-deb8-4cc7-82b4-489186c4e041" href="https://linear.app/stevevine/issue/DEV-460/notifications-and-reminders-celery-beat">DEV-460</issue> API. Frontend-only; mirrors existing hook/component conventions.

**Agreed approach (planned 2026-06-17).**

- [ ] **API layer**: `client.ts` `Notification` type; `src/notifications/hooks.ts` — `useUnreadCount()` (`GET /notifications/unread-count`, 60s `refetchInterval`), `useNotifications()` (`GET /notifications`, unread-first from backend), `useMarkRead()` / `useMarkAllRead()` (invalidate list + count).
- [ ] `NotificationBell`: `IconBell` `ActionIcon` in a Mantine `Indicator` (unread count, hidden at 0) inside a `Menu`. On open, list loads (invalidate-on-open); each item shows title + body + unread dot; click → mark-read + navigate to its section; "Mark all read" when unread > 0; empty state. Added to `AppLayout` between Search and `UserMenu`.
- [ ] **Target linking**: **section-level** by `target_type` — `content_item → /content`, `assessment → /assessments`, `treatment_plan → /risks` (robust with the payload; title/body name the item). Precise per-item deep links would need a backend target slug/URL — deferred.
- [ ] **Tests** (`NotificationBell.test`): unread badge reflects count; opening lists notifications; click posts `/{id}/read`; "Mark all read" posts `/read-all`; zero-state hides the badge.

Refs: ADR 0006, 0017. Depends on: <issue id="1c292ad6-deb8-4cc7-82b4-489186c4e041" href="https://linear.app/stevevine/issue/DEV-460/notifications-and-reminders-celery-beat">DEV-460</issue> (done).

---
*Migrated from Linear [DEV-464](https://linear.app/stevevine/issue/DEV-464/notifications-ui-top-bar-bell) · created 2026-06-17 · completed 2026-06-17*