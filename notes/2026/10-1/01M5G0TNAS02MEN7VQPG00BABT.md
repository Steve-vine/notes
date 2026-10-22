---
id: 01M5G0TNAS02MEN7VQPG00BABT
created: 2026-10-21T20:00:48.985452Z
updated: 2026-10-22T06:19:32.293193Z
type: task
title: A control assessment's review dates are kept as plain dates, so they can never shift a day
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1202
sprint: ss8348q
comments:
- id: 01M5H47HXMWHCV7XAVZJBARGFX
  author: Steve Vine
  at: 2026-10-22T06:19:31.635903Z
  text: |-
    Done — merged in PR #1232.

    - An assessment's "Last reviewed" and "Next review" are now plain dates. A New York reader sees the same day as a London reader everywhere they appear: the card, the control page, Audit ▸ Evidence, the audit pack, the assistant and the "Review assessment" to-do.
    - Every existing assessment and saved version keeps the day it showed.
    - Activity shows these dates as days, including changes logged before this.

    My calls (beyond the task):
    - **Saving stamps the saver's own day.** Until now a save at 00:30 BST recorded the day before, because it used the UTC date. This follows the same rule as the other time-zone fixes (ADR 0121).
    - **Existing values are converted by their UTC day**, which is the same calendar day as in London for every value saved so far. It matches how content review dates were converted.
assignee: steve
label:
- tech_debt
priority: low
task_status: review
---
Found while building COM-1194 (sprint 79), which made the same change for content review dates. Follows ADR 0121 §4: a date with no time is just a date.

**What's wrong:** a control assessment's "reviewed on" and "next review" are stored as a moment (midnight UTC on the day) rather than as a date. Anything that treats them as a moment (a screen, an export, the assistant, an Actions due date) can show the day before for a reader west of London.

**What it should do:** these review dates are stored and sent as plain dates, the same as content review dates now are. Existing values keep the day they show today. Nothing changes on screen for a London reader.

**Done when:** control assessment review dates are dates everywhere (stored, sent by the API, in exports, Actions and the assistant), existing assessments keep the same day, and a New York reader sees the same review date as a London reader.