---
id: 01M77XFP2ZZPRJQT0NSXNZ8B2K
created: 2026-11-12T12:59:51.775242Z
updated: 2026-11-12T13:00:16.870477Z
type: task
title: 'Inventory: each asset tab gets a search box that finds assets by name or alias'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1756
sprint: spsp226
assignee: steve
label:
- improvement
priority: medium
task_status: todo
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