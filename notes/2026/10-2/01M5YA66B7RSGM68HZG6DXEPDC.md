---
id: 01M5YA66B7RSGM68HZG6DXEPDC
created: 2026-10-27T09:13:46.087042Z
updated: 2026-10-28T18:17:05.315594Z
type: task
title: The Register — every vulnerability with its severity, system, sources, state, owner, age and fix-by date, filtered and sorted, and grouped by issue to see one CVE across every system
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1365
sprint: s6wypy5
blocked_by:
- 01M5YA5TK3885MH9SGEA4MFF94
comments:
- id: 01M5ZFFR3QAVVHARYBW02JJRZH
  author: Steve Vine
  at: 2026-10-27T20:05:36.503316Z
  text: |-
    Built and merged: PR #1380.

    **What's there**
    - **Register tab**: open vulnerabilities by default, most severe first, then oldest. Columns are VUL ref, title, severity pill with its CVSS score, kind, system, a mark per source, state, owner, first seen, and fix by (red when overdue). Each row opens its vulnerability.
    - **Filters**, all kept in the address so a link opens the same view: state, severity, kind, system, source, owner (Mine, Unassigned or a person), age band, Overdue only, and a search over title, CVE and reference. Each option shows its count, which is exactly what choosing it shows.
    - **Group by issue**: one row per issue (for example a CVE) with its worst severity and how many systems it's on. Opening a row lists those vulnerabilities, with "Show every issue" to go back.
    - **Show logged in error** brings those back. **Export CSV** downloads the filtered list.

    **My calls**
    - Informational ones are left off the Register unless the company's Settings show them.
    - The whole register is sent to the browser (up to 10,000), which filters and counts it there. That's why the counts can't disagree with the rows.
assignee: steve
label:
- feature
priority: high
task_status: done
---
Sprint 91, Vulnerabilities - Register (ADR in COM-1362). Builds on COM-1364.

## What people see

- **Register tab**, open vulnerabilities by default, most severe first, then oldest. Columns:
  - VUL reference;
  - title;
  - severity (a pill, with the CVSS score beside it when there is one);
  - kind;
  - system;
  - sources (one small mark per source);
  - state;
  - owner;
  - first seen;
  - fix by, in red when overdue.
- **Filters**, all kept in the address so a filtered view can be shared or bookmarked:
  - state (Open by default);
  - severity;
  - kind;
  - system;
  - source;
  - owner (including "Mine" and "Unassigned");
  - **Overdue only**;
  - age band (under 30 days, 30–90, 90–180, over 180);
  - a search over title, CVE and reference.
- **Group by issue:** one row per issue, e.g. a CVE, with how many systems it's open on and the worst severity. Opening a row lists those systems' vulnerabilities.
- **Every list sorts.** The head stays put while the rows scroll, and a row is a link to the vulnerability (IA brief *Screen conventions*).
- **Export** the filtered list as CSV.

## Who can do what

View vulnerabilities.

## Notes (technical)

- List endpoint with filters, sort and paging. Counts per filter value match what choosing it shows.
- Use the `useQueryState` hooks for filters (COM-792 pattern).
- New tables need SortableTh (`screen-conventions` test).

**Chain:** on the chain (API).

**Done when:**
- the register filters, sorts, groups and exports;
- filter counts match;
- a filtered address reopens the same view.