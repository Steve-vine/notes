---
id: 01M77XFP2ZZPRJQT0NSXNZ8B2K
created: 2026-11-12T12:59:51.775242Z
updated: 2026-11-12T16:50:38.730719Z
type: task
title: 'Inventory: each asset tab gets a search box that finds assets by name or alias'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1756
sprint: spsp226
comments:
- id: 01M784KVFC26CB0F3MJZPCWV1C
  author: Steve Vine
  at: 2026-11-12T15:04:28.396398Z
  text: |-
    Built — PR #1752 (auto-merge set), commit d7393742. Independent: all three registers load whole, so the search runs in the browser — no API change.

    What you'll see:
    - Each asset tab has a Search box at the start of its filter row. Technology assets: "Search by name or alias…", matching name, reference (AST-14) or any alias. Data and Software assets: "Search by name or reference…".
    - Case-insensitive, part of a word. Works together with chips and filters; chip counts and the "N … assets" count follow it.
    - Kept in the address, so a reload or a link keeps it; changing tab starts the new tab unfiltered.
    - A row found by an alias shows "also known as srv-db-01" under its name.
    - No matches: "No data assets match “zzz”." with Clear search.

    Choices:
    - A software asset also matches its full name with edition and version (e.g. "Windows Server 2012 Standard R2").
    - On Technology the Production chip stays on, so a search for a non-production asset finds nothing at first — the message then says "Choose All to see the non-production ones that do", and the Non-production chip shows the count.

    Checks: eslint, tsc, prettier clean; 15 new tests pass; full vitest green apart from known load flakes (pass alone). Checked in headless Chromium, light and dark, 1400px and 390px, console clean. Make/Model/Serial join the search with COM-1757.
- id: 01M78AP8GAC3S5GPBSKZV56G6E
  author: Steve Vine
  at: 2026-11-12T16:50:38.73054Z
  text: |-
    Pre-UAT on staging (3175d2ad), 2026-11-12 — **Passed**.
    Technology: "PHYSICAL HO" finds AST-36 and AST-38; "e2e-srv" / "srv-1757" find AST-38 with "also known as e2e-srv-1757"; "AST-38" matches by reference. Chips and count follow ("All 1 / Production 1 / Non-production 0", "1 technology asset"). With Production on, a non-production match says "Choose All to see the non-production ones that do". Combines with Kind=System. Kept in the address (?q=), survives reload; Clear search restores the list; changing tab starts unfiltered. Data: "SPRINT 8", "DAT-11", "dat-1" match; "zzz" → "No data assets match 'zzz'." Software: "sql" finds 2, "SFT-24" finds 1. Dark and 390px; console clean.
    Minor: with Kind=Application on, the empty message mentions only the search, not the Kind filter that removed them.
    Screenshots ~/compass-uat/spsp226/COM-1756/.
assignee: steve
label:
- improvement
priority: medium
task_status: review
---
Steve, testing on staging (2026-11-12).

**Today:** the three asset tabs in Inventory (Technology assets, Data assets, Software assets) have quick-filter chips and a filter bar, but nowhere to type a name. You can't find one asset quickly in a long register.

**What it should do:**
- Each of the three tabs gets a free-text **Search** box at the start of its filter row, with a placeholder like "Search by name or alias…".
- **Technology assets:** it matches the asset's name or any of its aliases. Its reference (e.g. AST-14) matches too.
- **Data assets** and **Software assets** have no aliases today, so they match on name and reference.
- Matching ignores case and works on part of a word ("sql" finds "Prod SQL cluster").
- It narrows the list as you type, together with the other filters and chips. The chip counts and the "N shown" count follow it.
- The search is kept in the address like the other filters (COM-792), so a link or a reload keeps it. Changing tab starts the new tab unfiltered, as today.
- A search that matches nothing says so, with a way to clear it.
- A row that matched on an alias shows which alias matched, e.g. "also known as srv-db-01", so the match makes sense.

**Done when:**
- on each tab, typing part of a name finds it;
- on Technology assets, typing an alias finds its asset and shows the alias that matched;
- the search combines with the chips and filters, and the counts follow;
- the search survives a reload, and clearing it brings the full list back;
- light and dark mode and a narrow window are checked;
- there are no errors in the browser console.

Frontend, `pages/InventoryPage.tsx` (`Filters` / `useQueryState`). If a register is paged by the API rather than loaded whole, the list endpoints gain a `q` parameter, and that puts this on the chain; check first. Aliases are `containers.aliases` (JSONB list).