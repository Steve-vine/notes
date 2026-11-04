---
id: 01M6H8SA9KBCQCCX9W0537N5H8
created: 2026-11-03T17:54:49.779042Z
updated: 2026-11-04T07:45:34.063758Z
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
- id: 01M6HFQVFX76Q92KXWS0P82DY9
  author: Steve Vine
  at: 2026-11-03T19:56:21.88538Z
  text: |-
    Done (PR #1564, merged 2026-11-03) — parts 1 and 3; part 2 (unsupported releases) left out, as you decided. Not on staging yet.

    What people see now:
    - Releases and builds are the same thing to matching. "SQL Server · 2012" matches an item that gives 11.0 builds; Inventory software at a 2012 build (11.0.7001) matches an item naming the 2012 release, and is compared exactly against that release's fixed build. Windows Server 2019 is 10.0.17763, and so on. A small table kept by hand covers SQL Server 2005–2025, Exchange 2013–2019 and Windows Server 2008–2025; other products compare as before. (Ubuntu releases need no table: NVD already gives them as 22.04, 24.04.)
    - "Why it doesn't match what we run": on an item page in a company with a watch list, a line per near miss — e.g. "You run Microsoft · SQL Server 2012; this names Microsoft · SQL Server 2022: before 16.0.4210.1."
    - On Products, each confirmed product says how many items it matched in the last 12 months; "Matched nothing in the last 12 months" shows in orange.

    Verified: unit tests for release ↔ build both ways and exact builds against a release's fix; an integration test through "Everything we run" (11.0 builds, a 2012 build, Windows 10.0.17763), a SQL Server 2022 near miss, and the matched counts; a screen test for the near-miss panel.

    To check on staging: Test Company ▸ Products shows matched counts (SQL Server 2012 will likely read "Matched nothing" — no source has named it in 12 months); open a SQL Server 2022 item to see the near-miss line.
assignee: steve
label:
- improvement
priority: high
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