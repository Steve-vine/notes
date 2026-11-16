---
id: 01M7K58DC5C1M3FBNWH6GTTFJH
created: 2026-11-16T21:47:20.837648Z
updated: 2026-11-16T23:35:19.052499Z
type: task
title: Compass's built-in checks get the same full-width page layout as collected checks
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1881
sprint: s7nqsy0
comments:
- id: 01M7KBE0EV4Q6219JX4AHGJZKG
  author: Steve Vine
  at: 2026-11-16T23:35:15.675265Z
  text: |-
    Done — PR #1868, merged a0f9762a.
    A built-in check's page (MFA, dormant accounts, public storage…) now lays out like a collected check's: one full-width column, no side column.
    Order: Details (Tests, each threshold, Control, any gap it raised, Schedule where it has one, Last ran) → How much passed → Failing / Listed (with Export CSV) → Captures (when it has any) → Changes at the bottom.
    Details uses the same "label: value" lines as a collected check's; anything a check doesn't have is left out. The header is unchanged: state, failing count, since, last ran, Run now.
    Both pages share one layout, so they stay alike.
    Assumptions: built-in checks have no schedule of their own on screen, so Schedule shows only for a collected check with a rule; the "what it tests" line is labelled "Tests".
    To check on staging: open CHK-12 to CHK-23 in Test Company at desktop and phone width, light and dark.
assignee: steve
priority: medium
task_status: review
---
From Steve's testing of round 2 (staging 43d03f09).

**What happens.** A collected check's page was reworked in COM-1870 (Details, Evidence, History, Workflows, Changes), and COM-1873 makes every section full width. Compass's built-in checks (MFA, dormant accounts, public storage, overdue vulnerabilities…; CHK-12 to CHK-23 in Test Company on staging) still use the old layout. That layout has two columns: **About** and **Changes** in a side column, beside How much passed, Listed / Failing and Captures. So the two kinds of check look different.

**Done when** a built-in check's page matches a collected check's:
- **Full width, one column**, in this order:
  1. **Details**, which takes over About:
     - what it tests;
     - its thresholds;
     - Controls (linked);
     - any open gap it raised (linked);
     - its schedule and last run, where there is one.
  2. **How much passed** (the chart).
  3. **Failing / Listed** (the table, with Export CSV).
  4. **Captures**, when it has any.
  5. **Changes**, at the bottom.
- Section titles and the Details layout (label: value lines) are the same as on a collected check's page. Anything a built-in check doesn't have is left out, not shown empty.
- The header keeps its state pill, failing count, since and last ran, and its Run action.
- It works at phone width, and in light and dark.
- The page tests are updated, and the Browser smoke still passes on every check page.

**Where** (for the builder): pages/CheckDetailPage.tsx (`main` / `side`, the About panel), checks/NoRuleCheckPage.tsx (the Details panel to match). If both pages can share one layout component, use it. Do this alongside COM-1873, so the two pages land the same way.