---
id: 01M6B4AKBBQSPZ36YFVBCAAJ6K
created: 2026-11-01T08:41:26.635132Z
updated: 2026-11-01T08:41:39.533751Z
type: task
title: Remove the DDQ "Reminder days before a DDQ is due" setting — Admin ▸ Actions decides DDQ timing now
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1500
sprint: scpaa6p
assignee: steve
label:
- tech_debt
priority: medium
task_status: todo
---
Sprint 100, Actions. Follows COM-1473 (computed due dates and windows). Steve decided on 1 Nov 2026 to remove the setting.

## Why

DDQ ▸ Settings ▸ "Review and reminders" has **Reminder days before a DDQ is due**: 7 days unless changed, and set per company. It used to decide when a DDQ appeared on its owner's Actions and when they were reminded. Since COM-1473, each DDQ action ("Get it answered", "Approve answers", "Send") takes its timing from **Admin ▸ Actions**. Changing the DDQ setting has no effect, and a setting that does nothing is misleading.

Per-company reminder timing goes with it. Steve accepted that; Admin ▸ Actions sets one timing for everyone.

## Behaviour

- The reminder field is removed from DDQ ▸ Settings. The library review period stays, and so does the card. It's retitled if "reminders" no longer fits.
- In its place, one line says reminder timing for DDQs is set on Admin ▸ Actions, with a link for anyone who can open it.
- The stored value is dropped by a new migration. Saving DDQ settings no longer accepts it; an old client sending it is ignored, not refused.
- The ADR 0124 §15 wording is amended to point at ADR 0137.

**Chain:** on the chain (migration and an API change).

**Done when:**
- DDQ ▸ Settings shows no reminder field, and its library review period still saves.
- Nothing reads the old value any more, and the migration removes it.
- The DDQ action windows on Admin ▸ Actions are unchanged.
- Pre-UAT in E2E Test Company: open DDQ ▸ Settings as E2E Admin A, check the field is gone and the review period saves.