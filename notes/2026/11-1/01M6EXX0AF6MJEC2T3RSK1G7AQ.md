---
id: 01M6EXX0AF6MJEC2T3RSK1G7AQ
created: 2026-11-02T20:06:07.439145Z
updated: 2026-11-04T07:46:09.166606Z
type: task
title: The Sources tab shows how far Polaris has read the advisories — "Polaris has read 1,840 of 2,310 advisories", with what's left and when it last read one
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1530
sprint: s6xh9g1
comments:
- id: 01M6F7P54ESFZHBWSQCZZE8GPY
  author: Steve Vine
  at: 2026-11-02T22:57:08.749941Z
  text: |-
    Done. Merged to main (PR #1544). It isn't on staging yet: the whole sprint goes there together once every task is in Review.

    What people see on **Security Feed ▸ Sources**, above the list of sources, is one line about Polaris's reading:
    - while it works through the backlog: "Polaris has read 1,840 of 2,310 advisories for the products they name — 470 to go." It refreshes every minute while reading is under way;
    - once it has caught up: "Polaris has read every advisory (2,310). Last read …";
    - items it couldn't read are counted: "12 couldn't be read";
    - when Polaris is off: "Polaris is off, so advisories aren't read for the products they name. Keyword watch lists still catch them." If it's paused, for example by its spending limit, it gives that reason instead.

    The counts cover the same items Polaris actually reads: advisories with no products of their own, and new CVEs no source has given products for yet.
- id: 01M6GA0EQ5Q94CWBBQJJGDV84T
  author: Steve Vine
  at: 2026-11-03T08:56:57.829167Z
  text: |-
    Pre-UAT (staging, 2026-11-03): **Passed**

    Security Feed ▸ Sources, as E2E Admin A, has a line above the list:
    - at 08:10: "Polaris has read 0 of 121 advisories for the products they name — 121 to go";
    - at 08:50: "Polaris has read 80 of 136 advisories for the products they name — 56 to go".

    None had failed, so no "couldn't be read" count showed. Polaris is on for staging, so I couldn't see the "Polaris is off" wording; the tests cover it.

    Screenshots: ~/compass-uat/sprint-102/COM-1530/
assignee: steve
label:
- feature
priority: medium
task_status: done
---
Sprint 102, Security Feed (ADR 0139 §6). Follow-on to COM-1517, which left this out.

## What people see

On **Security Feed ▸ Sources**, above the list, a line about Polaris's reading of free-text advisories:
- while it's working through them: "Polaris has read 1,840 of 2,310 advisories for the products they name — 470 to go";
- once it's caught up: "Polaris has read every advisory (2,310). Last read 5 minutes ago";
- when Polaris is off: "Polaris is off, so advisories aren't read for products. Keyword watch lists still catch them";
- items Polaris couldn't read are counted ("12 couldn't be read").

## Notes (technical)

- Counts from the items with no structured products: read, waiting, failed. Served with the Sources overview.

**Chain:** on the chain (API).

**Done when:** on staging, the Sources tab shows the line, and its numbers move as the background reading runs.