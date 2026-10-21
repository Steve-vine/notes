---
id: 01M5FJYAQ7KTH5QJXCW6K4VGW4
created: 2026-10-21T15:58:09.127075Z
updated: 2026-10-21T16:48:44.515246Z
type: task
title: A content item's review dates are kept as plain dates, so they can never shift a day
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1194
sprint: ss8348q
comments:
- id: 01M5FNTXA3JQ4Z2WGHHQ5B3CDK
  author: Steve Vine
  at: 2026-10-21T16:48:42.818765Z
  text: |-
    Done — PR #1208, merged 21 Oct 17:47 BST.

    - A document's "Last reviewed" and "Next review" are now kept and sent as plain dates, not as a moment at midnight UTC.
    - Every existing document keeps the day it showed before. Nothing changes on screen for a London reader.
    - A New York reader sees the same review days as a London reader everywhere they appear: the Content screens, the review-date pill, Activity, the cover of a PDF or Word copy, the Actions queue, the assurance calendar, evidence of operation and the assistant.
    - In Activity, review-date changes show as days. Older entries read as the right day too, and the field is labelled "Last reviewed".
    - The assistant gives and takes review dates as plain dates (2026-11-12).

    My calls:
    - A stored value that wasn't exactly midnight keeps the day every screen showed for it (its UTC day). In practice all of staging's were midnight.
    - A review date sent with a time of day other than midnight is now refused rather than guessed at. A midnight one from an older caller is still accepted.

    Found, not changed: control assessments' review dates have the same latent problem (stored as times, used as days). Say if you want a task.
assignee: steve
label:
- tech_debt
priority: low
task_status: review
---
Found while building COM-1185 (sprint 79). Follows ADR 0121 §4: a date with no time is just a date.

**What's wrong:** a policy or other content item's "reviewed on" and "next review" are stored as a moment (midnight UTC on the day) rather than as a date. The screens now read them as plain dates, so nothing shows wrong today. But anything that treats them as a moment (an export, the assistant, an Actions due date, a future screen) can show the day before for a reader west of London.

**What it should do:** review dates are stored and sent as plain dates, the same as other review dates in Compass. Existing values keep their day. Nothing changes on screen.

**Done when:** content review dates are dates everywhere (stored, sent by the API, in exports and to the assistant), existing items keep the same day, and a New York reader sees the same review date as a London reader.