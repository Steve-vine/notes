---
id: 01M5DD90QG6TNGMCSE8ABHY5XG
created: 2026-10-20T19:40:39.024565Z
updated: 2026-10-21T09:20:36.615882Z
type: task
title: 'ADR: time in Compass — deadlines count exact time from when something arrived, and everyone sees times in their own zone and format'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1182
sprint: ss8348q
assignee: steve
label:
- brief
priority: high
task_status: active
---
Steve's decision while smoke-testing sprint 79 (2026-10-20). Compass has users in the UK and on the US east coast, and more places to come. A company like Moneypenny has offices in both countries.

**Record as an ADR** (amending ADR 0118 §4's deadline maths, and replacing the deployment-wide UK wall clock as the way Compass counts days):

1. **A deadline is an exact moment, counted in elapsed time from the moment the clock starts.** No "end of the day", and no time zone in the calculation.
   - *Days:* N × 24 hours. 45 days for CCPA, received 09:00 on 1 Jan, is due 09:00 on 15 Feb.
   - *Calendar months:* the same date and time N months on. UK GDPR's one month, received 09:00 on 1 Jan, is due 09:00 on 1 Feb (overdue from 09:00; due "by 08:59"). Where that date doesn't exist, it's the last day of that month at the same time (31 Jan → 28/29 Feb). Months are counted on UTC so no time zone is involved.
   - *Business days:* the working days are counted, and the time of day is kept. Weekends are skipped, plus UK bank holidays for UK GDPR rules.
   - This is never later than the law's own deadline (which runs to the end of the due day), so it's safe. A request that arrives at 09:00 and one that arrives at 17:00 get deadlines eight hours apart, as they should.
   - Because it's real elapsed time, across a clock change the due time reads an hour different on the wall clock from the arrival time. That's expected, not a bug.
2. **Everyone sees times in their own time zone and date format** (a personal preference, with daylight saving followed automatically). A deadline is the same instant for everyone: "Due 1 Feb, 09:00 GMT" for a UK user and "Due 1 Feb, 04:00 EST" for a US east-coast user.
3. **Things that genuinely mean "a day" follow the person:** "due today" and "overdue" in Actions and in emails count by the recipient's own time zone. A schedule ("run at 08:00 every Monday") carries a time zone, set to its creator's by default and shown on the schedule.
4. **A date with no time** (a review date, a "joined on" date) is just a date. It shows as that date to everyone and never shifts by a day.
5. **Exports and PDFs** state the time zone they're written in (the person who produced them). CSVs use full ISO 8601 times with the offset.

The deployment-wide `schedule_timezone` setting only remains as the default for a new user or schedule where nothing better is known.

**Done when:** the ADR is merged and the tasks that implement it (deadlines in hours; personal time zone and date format; every screen; day-based server features) reference it.