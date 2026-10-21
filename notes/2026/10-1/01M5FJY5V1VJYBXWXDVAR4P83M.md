---
id: 01M5FJY5V1VJYBXWXDVAR4P83M
created: 2026-10-21T15:58:04.129495Z
updated: 2026-10-21T15:58:19.261405Z
type: task
title: Date filters on the Trust Centre Activity tab and on exports count the reader's own day, not the UK day
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1193
sprint: ss8348q
assignee: steve
label:
- improvement
priority: medium
task_status: active
---
Found while building COM-1185 (sprint 79). Follows ADR 0121 §3.

**What's wrong:** where you pick a From / To day to filter by, the server reads that day as a UK day. A New York reader who filters on 12 Nov gets London's 12 Nov, which ends at 7 pm their time:
- **Trust Centre ▸ Activity:** the From / To filter.
- **Export period filters:** the From / To (or period) choices on exports, such as the incident register, the DSR compliance export, the SAP export and the attestation export.

**What it should do:** a day you choose is your own day: from your midnight to your next midnight, in your time zone. A scheduled export uses its schedule's zone. The export still says which zone its times are in, as COM-1185 made it.

**Done when:** a New York reader filtering on a day sees exactly the events between their own midnights, and a London reader's results don't change.