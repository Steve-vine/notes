---
id: 01M5DDADXGKGNSD8F0TPXA97ZA
created: 2026-10-20T19:41:25.296353Z
updated: 2026-10-21T10:53:33.410608Z
type: task
title: Every date and time in Compass, its emails and its exports is shown in the reader's own time zone and format
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1185
sprint: ss8348q
blocked_by:
- 01M5DD9YEVY1YEFVQBQTP296HH
assignee: steve
label:
- improvement
priority: high
task_status: active
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