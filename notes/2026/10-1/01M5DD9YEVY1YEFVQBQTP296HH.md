---
id: 01M5DD9YEVY1YEFVQBQTP296HH
created: 2026-10-20T19:41:09.467773Z
updated: 2026-10-21T10:53:08.54595Z
type: task
title: Each person sets their own time zone and date format, and daylight saving is followed automatically
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1184
sprint: ss8348q
blocked_by:
- 01M5DD90QG6TNGMCSE8ABHY5XG
comments:
- id: 01M5F1FT9NY0J8NF01R57929CM
  author: Steve Vine
  at: 2026-10-21T10:53:07.765342Z
  text: |-
    Done — PR #1197, merged 21 Oct 11:52 BST.

    - Your menu (top right) now has **Preferences** in place of "Email preferences". It holds your time zone, date format and clock, plus the email settings that were already there.
    - **Time zone:** a searchable list of places, each with its current offset ("New York — EST, UTC−5"). Daylight saving follows the place, so there's never a GMT/BST choice to make.
    - **Date format:** each option shows today's date that way: "21 Oct 2026 (UK)", "Oct 21, 2026 (US)", "2026-10-21 (ISO)". **Clock:** "24-hour (14:05)" or "12-hour (2:05 pm)".
    - A preview line follows your choices: "A deadline will show as: Due 1 Feb 2026, 09:00 GMT" (or "04:00 EST" for New York).
    - **First sign-in:** Compass saves the browser's time zone. US English gets US dates and the 12-hour clock; anything else gets UK dates and 24-hour. After that they only change when you change them.
    - **Travelling:** a note you can dismiss says "Times are shown in London time (BST). Your computer is on New York time. Change".
    - Vendor portal users get the same Preferences in the portal's menu.
    - An admin sees each person's time zone on Admin ▸ Users (e.g. "New York time (EST)" or "Time zone not chosen yet") and can't change it.
    - A shared date and time formatter is in place, tested for London and New York across both clock changes. Screens move onto it in COM-1185, so most dates won't follow these preferences until that lands.

    My calls:
    - Places with no common English abbreviation show their offset ("UTC+9" for Tokyo).
    - In the autumn's repeated hour, a typed time takes the first one. A time that doesn't exist in spring moves an hour later (01:30 → 02:30).
assignee: steve
label:
- feature
priority: high
task_status: review
---
Steve's request (2026-10-20). Implements COM-1182 §2. Compass has users in the UK and on the US east coast, and more places to come.

**What it should do:**
- The user menu (top right) gets **Preferences**, which also holds today's email preferences:
  - **Time zone:** a searchable list of places ("London", "New York", "Los Angeles", "Sydney"…), each showing its current offset ("New York — EST, UTC−5"). Daylight saving follows automatically from the place, so there's never a GMT/BST or EST/EDT choice to make.
  - **Date format:** "12 Nov 2026" (UK), "Nov 12, 2026" (US), "2026-11-12" (ISO). The option shows today's date in each format.
  - **Clock:** 24-hour ("14:05") or 12-hour ("2:05 pm").
  - A preview line: "A deadline will show as: Due 1 Feb 2026, 09:00 GMT".
- **First sign-in:** the time zone is taken from the browser. The format comes from the browser's language: US English → US format and 12-hour clock; everything else → UK format and 24-hour clock. Both are saved so they don't change when someone travels. They change only when the person changes them.
- **When the browser's zone differs from the saved one** (travelling), a small dismissable note: "Times are shown in London time (GMT). Your computer is on New York time. [Change]".
- **Vendor portal users** get the same preferences in the portal's menu.
- An admin can see a user's time zone on their user record. Only the person can change it.

**Behind it (technical):** three columns on `users` (IANA zone name, date format, clock), exposed on `/auth/me` and saved through the existing preferences endpoint or a sibling one. Validate the zone against the IANA list. Detect with `Intl.DateTimeFormat().resolvedOptions().timeZone` on first sign-in. This task provides the preference and a single shared formatter (`formatDate`, `formatDateTime`, `formatTime`, `formatCountdown`) that reads it. COM-1185 moves every screen onto it.

**Done when:** a user can set their time zone, date format and clock. A new user gets sensible defaults from their browser. The shared formatter shows a deadline correctly in London and New York across both clock changes.