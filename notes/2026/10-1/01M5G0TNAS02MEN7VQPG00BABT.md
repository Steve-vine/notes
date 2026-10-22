---
id: 01M5G0TNAS02MEN7VQPG00BABT
created: 2026-10-21T20:00:48.985452Z
updated: 2026-10-22T05:42:56.62924Z
type: task
title: A control assessment's review dates are kept as plain dates, so they can never shift a day
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1202
sprint: ss8348q
assignee: steve
label:
- tech_debt
priority: low
task_status: active
---
Found while building COM-1194 (sprint 79), which made the same change for content review dates. Follows ADR 0121 §4: a date with no time is just a date.

**What's wrong:** a control assessment's "reviewed on" and "next review" are stored as a moment (midnight UTC on the day) rather than as a date. Anything that treats them as a moment (a screen, an export, the assistant, an Actions due date) can show the day before for a reader west of London.

**What it should do:** these review dates are stored and sent as plain dates, the same as content review dates now are. Existing values keep the day they show today. Nothing changes on screen for a London reader.

**Done when:** control assessment review dates are dates everywhere (stored, sent by the API, in exports, Actions and the assistant), existing assessments keep the same day, and a New York reader sees the same review date as a London reader.