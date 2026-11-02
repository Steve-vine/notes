---
id: 01M6EXX0AF6MJEC2T3RSK1G7AQ
created: 2026-11-02T20:06:07.439145Z
updated: 2026-11-02T20:06:12.941531Z
type: task
title: The Sources tab shows how far Polaris has read the advisories — "Polaris has read 1,840 of 2,310 advisories", with what's left and when it last read one
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1530
sprint: s6xh9g1
assignee: steve
label:
- feature
priority: medium
task_status: active
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