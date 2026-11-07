---
id: 01M6PVMKAHWMEB7NT5YK2RJSV5
created: 2026-11-05T22:00:30.28963Z
updated: 2026-11-07T08:55:18.851709Z
type: task
title: The Checks page, rebuilt around problems — problems first, grouped by cause with one fix each; coverage totals that narrow to a framework; then every control, filterable by framework, domain, coverage, result, integration, account and problem, where clicking any total or problem filters the list
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1608
sprint: s5khbev
blocked_by:
- 01M6PVM1EZ9VTQM336YPH4SXFJ
comments:
- id: 01M6QAKQ2VK5M1J5AN815DYN6N
  author: Steve Vine
  at: 2026-11-06T02:22:10.011752Z
  text: |-
    Done — merged to main (PR #1624).

    What's there
    Posture ▸ Checks now opens on an Overview built around problems:
    - Problems come first, grouped by cause, each with one fix and a link to where to fix it. An account that can't sign in is one problem however many checks it breaks; it now names the account (e.g. "MongoDB · Production can't sign in", added in COM-1611/1613). Held captures and failing checks each get one line. When there are none, it says "Nothing needs attention".
    - Coverage totals: Fully automated · Partly · Manual only · Not yet looked at, and the result counts. Pick a framework to narrow them.
    - Every control is listed underneath, filterable by framework, domain, coverage, result, integration, account and problem. The filters live in the address, so a filtered view can be shared or bookmarked. Each number shows exactly the controls it counts.
    - Clicking a control opens a side panel without leaving the list.
    - The old list of checks is the "All checks" tab; Settings is unchanged.

    My calls
    - Overview is the default tab; "All checks" keeps the old view.

    Tests: test_collection_overview.py; CoverageTab.test.tsx, ChecksPage.test.tsx.

    What to check on staging: open Posture ▸ Checks in E2E Test Company, filter by a framework and a result, then refresh the page and check that the filter survives.
- id: 01M6RBFCAVECKEZJE51MQ51F79
  author: Steve Vine
  at: 2026-11-06T11:56:30.938864Z
  text: |-
    Pre-UAT, as E2E Admin A in E2E Test Company: Passed, except "Nothing needs attention", which is Couldn't check.

    What I did: I broke the GitHub test account's sign-in, so GitHub answered 401.

    What I saw:
    - **The problem leads the page.** "E2E GitHub public (test) · E2E GitHub – RootCause-IT public can't sign in: 1 check affected", with the error, one fix ("Re-enter the key", linking to the account) and "Show 1".
    - **Show filters.** The list narrowed to ACC.13 (Partly automated, Broken), and the address carries the filter (`?problem=sign_in:account:…`). Reopening that address gives the same view.
    - **Totals narrow to a framework.** Picking ISO/IEC 27001: "1 fully automated · 7 partly · 0 manual only · 235 not yet looked at", which matches the 243 rows listed.
    - **Totals are buttons:** coverage (Fully / Partly / Manual only / Not yet looked at) and doing (Broken / Held / Failing / Passing / Collecting).

    Couldn't check: "Nothing needs attention". E2E Test Company also has a failing built-in check, so the page never empties.

    Small thing: a hand-typed `?framework=iso-27001-2022` gives a blank page (the page expects the framework's id). Choosing from the picker is fine.

    Screenshots: ~/compass-uat/s5khbev/COM-1608/
assignee: steve
label:
- feature
priority: high
task_status: done
---
Sprint "Checks - Coverage and batch work" (COM-1605). Builds on COM-1607. Batch actions on the list are the next task (COM-1609).

## What people see

**Posture ▸ Checks**, for the selected company, top to bottom:

1. **Problems, grouped by cause, each with its fix:**
   - "**MongoDB – Production can't sign in**: 31 checks affected. *Re-enter the key*" (opens the account; all 31 recover together when it's fixed);
   - "**4 checks broke after a change in the AWS API**. *Ask Polaris to repair all 4*";
   - "**Compass's Azure role is missing a permission**: 3 checks. *What to grant*";
   - "**6 captures held for review**. *Review*";
   - "**12 checks failing**. *See the gaps*".
   - Causes are worked out by Compass (same account and same error = one cause), not listed check by check.
   - **When there are none:** "Nothing needs attention" in one line.
2. **Coverage at a glance**, with a framework picker: "ISO 27001: 118 fully automated · 41 partly · 96 manual only · 12 not yet looked at", and the Doing totals. **Each number is a link** that filters the list below.
3. **Every control**, one row each:
   - columns: ref and title, domain, Covered, Doing, its checks (count and names on hover), accounts read, last capture;
   - **filters:** framework, domain, Covered, Doing, integration, account, problem, and free text;
   - all filters are kept in the address, so a filtered view can be bookmarked or shared;
   - clicking a row opens a side panel with the control's checks, latest captures and history, without leaving the list.
- **Settings** stays as a tab (thresholds, on/off, gap target days, the hold threshold from COM-1603).
- **The detail page of a single check** stays, reached from the panel.

## Notes (technical)

- One API answer for the page: problems (grouped server-side), totals by framework, and rows (paged server-side if needed). Reuse `coverage_for` (COM-1607) and `core/checks/view.py`.
- Cause grouping: Broken checks keyed by (account, error class). Error classes: sign-in refused, permission missing (with the permission), API changed (shape or unknown path), throttled, too big.
- Frontend:
  - rework `pages/ChecksPage.tsx` with kit pieces: `SummaryCards`, `FilterBar` / `FilterButton` / `QuickChips`, `ListTable` + `SortableTh`;
  - `components/useQueryState.ts` hooks for every filter (RR7 transitions → flushSync, URL-backed filters memory);
  - framework options from `useFrameworkFilterOptions`, as `ControlsPage` does.
  - Read the Screen conventions in `brief/information-architecture.md` first. The screen-conventions test needs SortableTh or a no-sort comment, and `w="fit-content"` on toggles.
- The Browser smoke covers every tab, so check it still passes.

**Chain:** on the chain (API).

**Done when:** on staging, in E2E Test Company:
- a revoked Collection key shows as one problem naming the account and how many checks it affects;
- clicking it filters the list to those controls;
- the ISO 27001 totals match the filtered rows;
- a filtered address reopens the same view;
- with no problems, the page says "Nothing needs attention".