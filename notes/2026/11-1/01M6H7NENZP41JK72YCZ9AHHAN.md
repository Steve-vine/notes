---
id: 01M6H7NENZP41JK72YCZ9AHHAN
created: 2026-11-03T17:35:14.623486Z
updated: 2026-11-03T17:35:29.737151Z
type: task
title: Confirming the company's products shows nothing under "Affects us" until it has a watch list, and nothing says so
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1546
sprint: s6xh9g1
assignee: steve
label:
- bug
priority: high
task_status: todo
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