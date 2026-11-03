---
id: 01M6H8SA9KBCQCCX9W0537N5H8
created: 2026-11-03T17:54:49.779042Z
updated: 2026-11-03T18:50:39.360996Z
type: task
title: 'Matching understands releases: "SQL Server · 2012" means the same as build 11.0, an unsupported release is flagged, and an item says why it didn''t match'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1548
sprint: s6xh9g1
comments:
- id: 01M6H91G1NTYB3W604KEX0J84J
  author: Steve Vine
  at: 2026-11-03T17:59:17.812925Z
  text: 'Steve decided (2026-11-03): leave unsupported releases out for now. Part 2 (the unsupported-release flag and the optional "Possibly affects us — unsupported release" matches) is out of scope. Parts 1 (release ↔ build) and 3 (why didn''t this match) stand.'
assignee: steve
label:
- improvement
priority: high
task_status: active
---
Raised by Steve testing sprint 102 on staging (2026-11-03): "The matching feels a bit fragile… The product that I have is 'SQL Server · 2012' so it should find all SQL Server instances of 2012."

Proposal, awaiting Steve's go-ahead. It builds on COM-1547, which brings a product's per-release names ("SQL Server 2019", "SQL Server 2022 for x64-based systems CU27") under one product with the release carried as its version.

## What staging shows

No item in the last 12 months names SQL Server 2012, under any name or in any text: 0 of the 103 SQL Server items. That's not because 2012 is safe. Microsoft's extended support ended in July 2022 and paid extended updates in July 2025, so new advisories no longer list it. Matching can't find what the sources stop naming, and today nothing says so.

## What people would see

1. **Releases and builds are the same thing.** "SQL Server 2012" matches an item that states 11.0.x builds, and "11.0.7001" matches one that says "SQL Server 2012". The same goes for SQL Server 2014/2016/2017/2019/2022/2025, Windows Server 2012 R2/2016/2019/2022/2025 (by build) and Ubuntu LTS releases. A small, kept-up table covers the products most companies run, and the rest compare as today.
2. **An unsupported release is flagged** on Products and on its matches: "SQL Server 2012 — no longer supported by Microsoft since July 2025. New flaws won't list it, so Compass can't tell you about them."
   - Optionally: an item about a newer release of the same product, where the sources don't say older ones are safe, shows under "Affects us" as **Possibly affects us — unsupported release**, so it's not silently missed.
3. **"Why didn't this match?"** On an item page in a company with watch lists, a line for near misses: "You run SQL Server 2012; this names SQL Server 2019–2025." On Products, each confirmed product shows how many items it matched in the last 12 months, so a "0" stands out.

## To decide (Steve)

- Whether 2's optional part is wanted. It's more matches, many of them noise, but catches what vendors no longer list.

**Technical:**
- Release↔build table plus end-of-support dates in `naming.py` (or a data file), used by `matching._verdict` on both sides.
- The near-miss explanation reuses the vendor/product family index.
- On the chain only if the item page's API gains the near-miss field (likely).

**Done when:** in Test Company with an "Everything we run" list, SQL Server 2012 shows as unsupported on Products; an item stating SQL Server 11.0 builds matches it; Windows Server 2019 links match items that give 10.0.17763 builds; and an unmatched SQL Server 2022 item explains the near miss.