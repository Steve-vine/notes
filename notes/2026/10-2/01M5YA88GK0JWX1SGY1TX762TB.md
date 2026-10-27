---
id: 01M5YA88GK0JWX1SGY1TX762TB
created: 2026-10-27T09:14:53.843936Z
updated: 2026-10-27T19:42:21.29277Z
type: task
title: The Overview — how many are open and how severe, what's overdue, which systems carry the most, where they come from, how old they are, and how all of it has moved over time
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1371
sprint: s6wypy5
blocked_by:
- 01M5YA805C4S4Y8CZSH1PBWYSM
assignee: steve
label:
- feature
priority: high
task_status: active
---
Sprint 91, Vulnerabilities - Register (ADR in COM-1362). Builds on the snapshot task (blocked by it).

Steve asked for vulnerabilities sliced by severity and by the systems affected, and for change over time.

## What people see

- **Figures across the top:**
  - open;
  - critical and high open;
  - overdue;
  - fixed in the last 30 days;
  - average days to fix.
  - Each figure opens the Register filtered to exactly those rows. The count equals what choosing it shows.
- **Open over time:** a stacked area by severity. Range 30 days, 90 days, 1 year, or all; 90 days by default.
- **Found and fixed:** bars per week, side by side, so the trend reads as winning or losing.
- **By system:** the systems with the most open critical and high, as a bar each split by severity. Each opens the Register for that system.
- **By source:** open count per source (Recorded by hand, Nessus, Aikido, pen tests, each cloud), each a filter link.
- **By age:** open by age band and severity. Overdue items are shown in red.
- **Overdue by owner:** the people with the most overdue, each a link to "owner = them, overdue".
- **A kind filter** across the whole page (all, or one kind), so misconfigurations and software flaws can be viewed apart.

## Who can do what

View vulnerabilities.

## Notes (technical)

- Charts: @mantine/charts pinned to core's version, and the time-axis recipe from the Posture timeline.
- Many-series charts need a real-browser look before staging (the headless Chromium harness).
- Colours from the severity tokens; one scale used everywhere, so severity pills and chart colours match.

**Chain:** on the chain (API: overview endpoint).

**Done when:**
- every chart draws from real data;
- every figure and bar opens the matching Register view with the same count;
- it reads well in a real browser at desktop and narrow widths.