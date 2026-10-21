---
id: 01M5DD9HTECVZ3KRHD14KVHT4X
created: 2026-10-20T19:40:56.526305Z
updated: 2026-10-21T10:45:01.206454Z
type: task
title: A data subject request's deadlines count exact time from the moment it arrived, not to the end of a UK day
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1183
sprint: ss8348q
blocked_by:
- 01M5DD90QG6TNGMCSE8ABHY5XG
comments:
- id: 01M5F10Y7SD1B9V6T6CX64RY7N
  author: Steve Vine
  at: 2026-10-21T10:45:00.281662Z
  text: |-
    Done — PR #1195, merged 21 Oct 11:44 BST.

    - Every deadline on a data subject request is now an exact moment, counted from the moment the clock started. A UK GDPR request received at 09:00 is due at 09:00 a month later. One received at 17:00 the same day is due eight hours later.
    - Days are 24 hours each, months land on the same date and time, and business days land at the same time of day. A due moment on a weekend or UK bank holiday moves to the next working day at the same time (ADR 0121's call: 09:00 Thu 1 Jan 2026 → 09:00 Mon 2 Feb 2026).
    - Where the rule waits for identity, the clock starts at the moment the identity check was recorded.
    - A pause gives back exactly the time paused: 44 hours paused moves the deadline 44 hours, and the card says "Paused 44 hours so far".
    - The countdown reads "9 days left", then hours in the last two days ("17 hours left"), then "Overdue by 5 hours" or "Overdue by 3 days". It's amber inside a week and red when overdue.
    - Deadlines show as a date and time with the zone ("Due 1 Feb, 09:00 GMT"), for now in the browser's own zone: in the header, on each part's deadline, the acknowledgement deadline, the Status card and the register's Due column.
    - On time or late is judged to the moment ("Answered in 31 days: late by 5 hours"). The compliance figures use the exact moments.
    - Settings ▸ Deadline rules: "Counted from the moment it arrived: 1 month from 09:00 on 1 Jan is 09:00 on 1 Feb."
    - The to-do says "is due in 17 hours", the 24-hour warning email gives the exact time and zone, and the assistant reports each deadline with its zone.
    - Any open request picks up the new counting with Recalculate. There's no data change.

    My calls, for you to confirm:
    - On time or late is measured from when the answer letter was sent, as it was before, not from when the request was closed. Otherwise a handler who answered on time but closed a day later would have to give a late reason. Easy to switch if you'd rather.
    - A customer's own deadline on a forwarded request is a date with no time, so it runs to the end of that day (UK).
    - "Late by N days" counts any lateness as at least one day.

    Left for COM-1185: the wording of deadlines in letters, and the late and date columns in the compliance export and evidence of operation. Until then the export can say "late by 1 day" where the screen says "5 hours".
assignee: steve
label:
- improvement
priority: high
task_status: review
---
Steve's decision while smoke-testing sprint 79. Implements COM-1182 §1 for Data Subject Requests.

**What's wrong:** every deadline runs to 23:59 UK time on its due day. A request that arrives at 09:00 gets the same deadline as one that arrives at 17:00. A US handler sees a deadline end at 6:59 pm Eastern, and "midnight" means something different to each office.

**What it should do:** every deadline is an exact moment, counted from the moment the clock starts:
- **Days:** N × 24 hours (CCPA 45 days: received 09:00 on 1 Jan → due 09:00 on 15 Feb).
- **Calendar months:** same date and time N months on (UK GDPR: received 09:00 on 1 Jan → due 09:00 on 1 Feb). If there's no such date, the last day of that month at the same time.
- **Business days:** that many working days on, at the same time of day. Weekends are skipped, plus UK bank holidays for UK GDPR rules.
- **Where the clock starts:** the moment it was received. Where the rule says so, it starts instead at the moment identity was confirmed (the time the check was recorded, not the day). A customer's own deadline, when forwarded, is taken as the customer gives it.
- **Acknowledgement deadlines** count the same way.
- **Pauses** give back the exact time paused (14:00 on the 3rd to 10:00 on the 5th = 44 hours), not whole days.
- **Extensions** add their period to the current deadline the same way.
- **Countdown:** "9 days left" while more than two days remain; then hours ("17 hours left"); then "Overdue by 5 hours" / "Overdue by 3 days". Amber inside a week and red when overdue, as now.
- **On time / late at close** compares the exact moment closed with the exact deadline.
- **Shown** as a date and time in the viewer's own zone and format ("Due 1 Feb, 09:00 GMT"). Until COM-1184/COM-1185 land, that's the browser's zone with the zone written beside the time.
- **Settings ▸ Deadline rules** explains the counting in one line: "Counted from the moment it arrived: 1 month from 09:00 on 1 Jan is 09:00 on 1 Feb."
- **Compliance figures** (on time %, average days to respond) use the exact moments.
- **The assistant's deadline tools** report the moment with its zone.

**Existing requests:** none are live. Staging has none and production doesn't have the module yet. **Recalculate** applies the new counting to any open request. This should land before production upgrades to a release containing Data Subject Requests.

**Behind it (technical):** `core/dsr_deadline_maths.py` / `dsr_deadlines.py` drop `local_day`/`end_of_day` and work on aware datetimes. Month arithmetic is done in UTC; business days check weekday and bank holiday on the UK date for UK GDPR. `due_at`/`acknowledge_due_at` are already timestamptz, so there's no schema change. The deadline API gives full timestamps instead of date-only strings (the date-only strings are also what shifts a day for US viewers today). Update the property tests in `test_dsr_deadline_maths`.

**Done when:** a UK GDPR request received 09:00 on 1 Jan shows due 09:00 on 1 Feb. One received at 17:00 the same day is due eight hours later. A 44-hour pause moves the deadline by exactly 44 hours. The countdown switches to hours in the last two days.