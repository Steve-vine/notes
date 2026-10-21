---
id: 01M5DDADXGKGNSD8F0TPXA97ZA
created: 2026-10-20T19:41:25.296353Z
updated: 2026-10-21T13:07:27.005899Z
type: task
title: Every date and time in Compass, its emails and its exports is shown in the reader's own time zone and format
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1185
sprint: ss8348q
blocked_by:
- 01M5DD9YEVY1YEFVQBQTP296HH
comments:
- id: 01M5F95QPAQ2X7R5229TD45X8E
  author: Steve Vine
  at: 2026-10-21T13:07:26.025971Z
  text: |-
    Done in five parts, all merged 21 Oct: #1201 Access Control (12:44 BST), #1203 Inventory, Vendors and the portals (13:12), #1205 the remaining modules and shared screens (13:42), #1207 emails, PDFs and exports (13:59), #1206 Data Subject Requests plus the lint rule (14:06).

    On screen:
    - Every date and time in Compass now uses the reader's own time zone, date format and clock (from COM-1184's Preferences): tables, cards, windows, timelines, history, tooltips and chart axes, in the main app and the vendor portal. A browser set to another language no longer changes how a date looks.
    - Deadlines, run times, schedules and sign-in times name their zone ("Runs 15 Nov 2026, 17:30 GMT"; "Due Feb 1, 4:00 am EST" for a New York reader). Elsewhere the zone is left off, and hovering shows the full moment with its zone.
    - Plain dates (review dates, joined-on, next due, valid until…) show as the same day for everyone. A US reader no longer sees them a day early.
    - Date and time boxes read and write on the reader's own clock: a New York user typing 9:00 means 9:00 New York time. "Today" defaults are the reader's today.

    Emails and documents:
    - Emails give dates and deadlines in each recipient's own zone and format, with the zone named. That covers digests, reminders, the DSR and incident 24-hour warnings ("UK time" is gone), scheduled reports and the vendor assessment notice.
    - PDFs and exports are written on the clock of whoever produced them and say so once ("Times are in New York time (EST)"). Scheduled report files use the schedule's own zone.
    - CSVs carry exact times with their offset (2026-02-01T09:00:00+00:00) and say so in their header. Plain dates stay 2026-11-12.
    - Lateness is exact everywhere ("Late by 5 hours"), and DSR letters give the deadline as an exact moment.
    - A lint rule now stops any screen formatting dates its own way again.

    My calls:
    - The Trust Centre visitor portal keeps its fixed UK date style, since visitors have no Compass account. The day a visitor accepted the NDA is now their own day, not the UTC day.
    - Supplier contacts and trust-centre visitors have no preferences of their own, so their emails use the deployment's (London, UK format, 24-hour).
    - Policy and content PDFs are one shared copy for everyone, so they use the deployment's format. Their review table now shows "15 Jan 2026" on screen, where it used to show dd/mm/yyyy.
    - Settings ▸ Retention CSV: the first column is now "When" (it holds a full time) instead of "Date".
    - Under an hour, a countdown reads "Less than an hour left".

    Found, not fixed — say if you want tasks:
    - The Trust Centre Activity tab's From/To day filters use London's day, not the reader's.
    - A content item's review dates are stored as times, not dates. The screen treats them as plain dates, so nothing shows wrong, but the data should change type.
    - Export period filters (From/To) still count UK days.
assignee: steve
label:
- improvement
priority: high
task_status: review
---
Steve's request (2026-10-20). Implements COM-1182 §2, §4 and §5 across the whole app, using COM-1184's preference and shared formatter.

**What's wrong:** each screen formats dates its own way, in about 150 places. Newer screens force UK style ("12 Nov 2026"). Older ones, many in Access Control, use the browser's language, so a US browser sees "11/12/2026" on some screens and "12 Nov 2026" on others. Times are converted to the computer's clock with no zone shown. Dates sent without a time ("2026-11-12") are read as midnight UTC, so a US viewer sees them a day early.

**What it should do:**
- **Every screen** shows dates and times through the shared formatter, in the viewer's time zone, date format and clock. This covers the internal app and the vendor portal, including tables, cards, modals, timelines, history, tooltips and charts' time axes.
- **A moment** (when something happened, or a deadline) shows in the viewer's zone. **A time is shown with its zone** wherever two people might compare it: deadlines, schedules, "runs at", sign-in times ("1 Feb 2026, 09:00 GMT"). Elsewhere the zone is left off to keep tables tidy, and hovering a time shows it in full with the zone.
- **A plain date** (a review date, a joined-on date, a "next due" date) shows as that date to everyone, never shifted.
- **Relative times** ("3 hours ago", "in 2 days") stay relative, with the full date and time on hover.
- **Emails** (digests, reminders, notifications) are written in the recipient's zone and format, with the zone named.
- **PDFs and exports** are written in the zone and format of whoever produces them, with the zone stated once on the document ("Times are in New York time (EST)"). **CSVs** use full ISO 8601 times with the offset (`2026-02-01T09:00:00+00:00`) so spreadsheets and auditors get the exact moment. Scheduled exports use the schedule's zone (COM-1186).
- **Date pickers and time inputs** read and write in the viewer's zone. A US user entering "Received 9:00 am" means 9:00 Eastern.
- **A lint rule** stops new code calling `toLocaleString` / `toLocaleDateString` / `toLocaleTimeString` / `new Date(…)` formatting directly on a date, so it can't drift back.

**Behind it (technical):** this is a sweep, best done as one PR per area (shell + shared, Access Control, Inventory, Vendors + portal, Content, Incidents, Attestations, SAP, Data Subject Requests, Compliance + reports) so each is reviewable. The backend must send date-only values as dates and moments as full timestamps. Audit the schemas for date-only strings standing in for moments. Server-rendered text (emails, PDFs, `strftime(local_zone())` in exports) takes the reader's or producer's zone instead of `schedule_timezone`.

**Done when:** a London user and a New York user looking at the same record see the same moments, each in their own zone and chosen format. No screen shows a browser-language date. A plain date is never a day out. Emails and exports state their zone. The lint rule is on.