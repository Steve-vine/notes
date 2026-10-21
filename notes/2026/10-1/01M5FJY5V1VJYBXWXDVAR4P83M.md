---
id: 01M5FJY5V1VJYBXWXDVAR4P83M
created: 2026-10-21T15:58:04.129495Z
updated: 2026-10-21T18:58:53.694165Z
type: task
title: Date filters on the Trust Centre Activity tab and on exports count the reader's own day, not the UK day
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1193
sprint: ss8348q
comments:
- id: 01M5FX986B6C2ED664VZTZFS5N
  author: Steve Vine
  at: 2026-10-21T18:58:52.74769Z
  text: |-
    Done — PR #1211, merged 21 Oct 19:58 BST (it was held up for an hour by an outside security advisory and a flaky test, fixed in COM-1196/1197).

    - Trust Centre ▸ Activity: the From / To filter and its CSV count your own day, midnight to midnight in your time zone. London results are unchanged.
    - Data Subject Requests ▸ Compliance uses your own days for the period, "today", the default 12 months, last year's CCPA figures and the 24-month chart.
    - These exports take their period in the asker's days: the DSR request log, refusals and retention log, the incident register and the attestation export. The HIPAA breach log's year is the asker's calendar year.
    - Report conditions such as "created after 10 Feb" use the reader's day on screen, in the preview and in the CSV. A scheduled report uses its schedule's zone.
    - Each CSV's period line now says whose days it counts, e.g. "Period: 2026-02-10 to 2026-02-10 (days in New York time)".
    - The assistant's compliance and trust-centre activity tools count the same way.

    My calls:
    - A report's "before / after a date" on a date-and-time field used to mean UTC midnight. It now means the reader's midnight, so a London report run in summer moves by one hour, to the correct UK midnight.
    - The SAP export and the Disclosures log filter by plain dates, so they had nothing to convert. Evidence of operation's "last 12 months" and nightly retention stay on the deployment clock, since nobody picks those days.
assignee: steve
label:
- improvement
priority: medium
task_status: review
---
Found while building COM-1185 (sprint 79). Follows ADR 0121 §3.

**What's wrong:** where you pick a From / To day to filter by, the server reads that day as a UK day. A New York reader who filters on 12 Nov gets London's 12 Nov, which ends at 7 pm their time:
- **Trust Centre ▸ Activity:** the From / To filter.
- **Export period filters:** the From / To (or period) choices on exports, such as the incident register, the DSR compliance export, the SAP export and the attestation export.

**What it should do:** a day you choose is your own day: from your midnight to your next midnight, in your time zone. A scheduled export uses its schedule's zone. The export still says which zone its times are in, as COM-1185 made it.

**Done when:** a New York reader filtering on a day sees exactly the events between their own midnights, and a London reader's results don't change.