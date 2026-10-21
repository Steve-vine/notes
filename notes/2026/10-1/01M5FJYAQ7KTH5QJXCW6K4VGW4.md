---
id: 01M5FJYAQ7KTH5QJXCW6K4VGW4
created: 2026-10-21T15:58:09.127075Z
updated: 2026-10-21T15:58:21.918028Z
type: task
title: A content item's review dates are kept as plain dates, so they can never shift a day
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1194
sprint: ss8348q
assignee: steve
label:
- tech_debt
priority: low
task_status: active
---
Found while building COM-1185 (sprint 79). Follows ADR 0121 §4: a date with no time is just a date.

**What's wrong:** a policy or other content item's "reviewed on" and "next review" are stored as a moment (midnight UTC on the day) rather than as a date. The screens now read them as plain dates, so nothing shows wrong today. But anything that treats them as a moment (an export, the assistant, an Actions due date, a future screen) can show the day before for a reader west of London.

**What it should do:** review dates are stored and sent as plain dates, the same as other review dates in Compass. Existing values keep their day. Nothing changes on screen.

**Done when:** content review dates are dates everywhere (stored, sent by the API, in exports and to the assistant), existing items keep the same day, and a New York reader sees the same review date as a London reader.