---
id: 01M6EZ8TEXXXFBH4ZQ291SHZBN
created: 2026-11-02T20:30:03.229097Z
updated: 2026-11-02T20:30:07.647039Z
type: task
title: Security Feed gaps found before review — each watch list shows its matches in the last 7 and 30 days; a comeback's action is due from when it came back; Raise isn't offered on a not-relevant item and says which right is missing
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1531
sprint: s6xh9g1
assignee: steve
label:
- bug
priority: medium
task_status: active
---
Sprint 102, Security Feed (ADR 0139). Found by checking COM-1519, COM-1523 and COM-1525 against their tasks before Review.

## What people see

- **Watch lists**: each list shows how many items it matched in the **last 7 days** and the **last 30 days** (COM-1519 asked for this; it was left out).
- **My actions**: when an item marked not relevant comes back (now exploited, now Critical, or now our versions), its action is due **from the day it came back**, not from when it first matched, so it doesn't arrive already overdue (COM-1523).
- **Item page**: **Raise vulnerability** and **Raise risk** aren't offered while the item is marked not relevant (reopen it first). If someone can raise one but not the other, the page says which right the other needs, e.g. "Raising a risk needs *Manage risks*" (COM-1525).

**Chain:** on the chain (API).

**Done when:** on staging, the Watch lists tab shows the two counts; a comeback's action has a due date counted from the comeback; a not-relevant item offers no Raise.