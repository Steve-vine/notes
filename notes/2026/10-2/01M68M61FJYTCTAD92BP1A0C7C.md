---
id: 01M68M61FJYTCTAD92BP1A0C7C
created: 2026-10-31T09:20:51.186673Z
updated: 2026-10-31T09:23:08.383117Z
type: task
title: One Status across every action — Overdue, Due soon, Upcoming, Later — so it's obvious what needs attention, instead of each module's own words
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1474
sprint: scpaa6p
blocked_by:
- 01M68M5RS2BS736HK2PFS7R8B8
assignee: steve
label:
- improvement
priority: high
task_status: todo
---
Sprint 100, Actions (ADR 0137 rule 7).

## What people see

Today's Status pill shows each module's own state: New, Assigned, Open, In review, To decide, Due, Expiring… None of it says whether something needs attention. On Actions, Status becomes one of four values:

| Status | Means | Pill |
|---|---|---|
| **Overdue** | past its due date | red |
| **Due soon** | inside its notification window, so emails are going | amber |
| **Upcoming** | due within the horizon (Admin ▸ Actions, 90 days unless changed) | blue |
| **Later** | due beyond the horizon | grey |

- A thing's own status ("In review", "Treated") stays on its own screen. The **Action** column (COM-1470) already says what step it's at.
- Polaris reports the same four.
- The Portal's Actions page uses the same four.

## Notes (technical)

- Derived from the effective due date and window (COM-1473) and the horizon (COM-1469). Not stored.
- Pill colours: use the adaptive colours, never fixed dark shades (COM-1395), and keep the pill rules in the screen conventions (pills never truncate).
- The existing `due_soon` and overdue flags on rows fold into this.

**Chain:** on the chain (API field). Blocked by COM-1473.

**Done when:** on staging, every row for each E2E account shows one of the four. A row inside its window reads Due soon, and with the horizon set to 30 days a row 60 days out reads Later. Checked in light and dark mode.