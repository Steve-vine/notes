---
id: 01M6H7NENZP41JK72YCZ9AHHAN
created: 2026-11-03T17:35:14.623486Z
updated: 2026-11-04T07:46:09.25527Z
type: task
title: Confirming the company's products shows nothing under "Affects us" until it has a watch list, and nothing says so
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1546
sprint: s6xh9g1
comments:
- id: 01M6HD8G5WTVGHT3M89FR4FQKT
  author: Steve Vine
  at: 2026-11-03T19:13:01.628401Z
  text: |-
    Done (PR #1559, merged 2026-11-03) — option A, the recommended one (I went ahead with it rather than wait; say if you'd prefer B, the automatic list). Not on staging yet.

    What people see now: in a company with no watch list, the Feed's empty "Affects us" says "No watch list yet": confirmed products are only matched against the feed through a watch list. A Security Feed manager gets a "Create “Everything we run”" button that makes the list in one click. While matching runs, the Feed says it's matching and checks again every few seconds until items appear. The Products tab shows the same notice, with the same button, while there are confirmed products and no list. A reader is told a manager can create one; with nothing confirmed yet, the Feed points at Products first.

    Worth knowing: the one-click list uses the watch list editor's defaults — High and above, known exploited always included. Your own "PHP" list used Medium; if you'd rather the one-click list were Medium, it's a one-line change. As noted in the pre-UAT, the first list matches a year of history at once, so expect a batch of actions (176 in E2E Test Company).

    Verified: screen tests for the notice and empty state as manager and reader, the one click creating the list, and nothing shown once a list exists. Creating any list already starts matching, so no server change was needed. Not yet tried in a browser.

    To check on staging: in a company with confirmed products and no watch list, open Feed and Products, click the button, and watch "Affects us" fill.
assignee: steve
label:
- bug
priority: high
task_status: done
---
Found by Steve testing sprint 102 on staging (2026-11-03), in Test Company.

## What people see

Steve confirmed four products on Security Feed ▸ Products at 17:30 (Windows Server 2019, Windows Server 2012 R2, SQL Server 2012, Ubuntu 24.04). "Affects us" stays empty: "Nothing affects the company — Items matching the company's watch lists appear here."

The feed has 2,480 items naming Windows Server 2019 and 1,674 naming Windows Server 2012 R2, so he expected matches.

**Why (technical):** by design (ADR 0139 §7–8, "company-wide watch lists only"), matches come only from a company's watch lists. Confirmed products are what a list's "Everything we run" or product rule compares versions against. Test Company has **no watch lists**, so `companies_watching` skips it and there are 0 matches. Confirming a link does queue `rematch_company`, but with no lists, nothing matches.

Nothing on Products or Feed tells you a watch list is needed, or offers to make one.

## To decide (Steve)

- **A.** Recommended: the Feed's empty "Affects us" and the Products tab say "No watch list yet — your confirmed products are only matched through one", with a **Create "Everything we run"** button that makes the list in one click.
- **B.** A company gets an "Everything we run" list automatically the first time a product is confirmed.

Either way, the first list matches a year of history at once. In E2E Test Company that made 176 actions, 16 already overdue (the open question from the pre-UAT).

**Done when:** in a company with confirmed products and no watch list, the Feed and Products tabs say why "Affects us" is empty and how to fix it in one step, and after that step the confirmed products' items appear under "Affects us".

Related: COM-1547 (two of the confirmed names are ones the sources barely use).