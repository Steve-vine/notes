---
id: 01M6EKKGVQYRGNX1RQQAHFFHCR
created: 2026-11-02T17:06:10.935207Z
updated: 2026-11-04T07:46:09.052652Z
type: task
title: 'ADR: the Security Feed — Compass reads trusted public security sources into one searchable feed kept in full, and each company''s watch lists and Inventory decide, by product and version, which items might affect it'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1510
sprint: s6xh9g1
comments:
- id: 01M6EP9JYW71TZR0892A05MHBC
  author: Steve Vine
  at: 2026-11-02T17:53:11.132316Z
  text: |-
    Done: PR #1527 merged.

    - decisions/0139-security-feed.md (ADR 0139, §1–§12), covering all 17 tasks: one shared feed kept in full; one item per issue; sources; products and versions matched by rule; Polaris reads prose once; company-wide watch lists; "possibly affects us"; what a match leads to; links; permissions; Polaris.
    - Modules ▸ Security Feed (after Vulnerabilities) is in the IA brief, and the two permissions are in the permission catalogue.

    For you to read: the "Calls made for Steve to overturn" section, which is the task's list plus one more: suggested product links aren't used for matching until a person confirms them.
- id: 01M6G9WWWV5RVMV6EVTKY9WKVR
  author: Steve Vine
  at: 2026-11-03T08:55:01.274969Z
  text: |-
    Pre-UAT (staging, 2026-11-03): **Passed**

    Checked: decisions/0139-security-feed.md is on main, Accepted, dated 2026-11-02, and the module on staging follows it (sources, one item per issue, company-wide watch lists, version matching by rule, Polaris reading prose only).
assignee: steve
label:
- brief
priority: high
task_status: done
---
Sprint 102, Security Feed - New Module (ADR 0139). Builds on:
- ADR 0129 (Vulnerabilities: one issue on one system; text from a source is untrusted);
- ADR 0072/0114 (Inventory, and the software on technology assets);
- ADR 0099 (text from outside Compass is data, shown as the source's words);
- ADR 0128 (the Integrations library);
- ADR 0055/0137 (Actions);
- ADR 0127 (Polaris's provider and costs);
- ADR 0067/0138 (the permission catalogue and definable roles).

Write `decisions/0139-security-feed.md`. Add Modules ▸ Security Feed to `brief/information-architecture.md`, and the two new permissions to `brief/permission-catalogue.md`.

## Steve's asks (2026-11-02)

- Consolidate public security feeds from several trusted sources, and let people set filters so the findings that matter to them surface.
- Sources: government alerts, all published CVEs, major vendor advisories, and feeds an admin adds.
- Filters are **company-wide**, set by an admin.
- Also flag items that affect **software Inventory already knows the company runs**, in this sprint.
- On a match: it shows on the feed screen; email digest; Exploited/Critical land in My actions; one click raises a vulnerability or risk.
- **Keep the whole unfiltered feed**, so items that weren't flagged can be searched later. Load **12 months** of history on first switch-on.
- **Useful filtering:** by version ("we use PHP, but only the versions we run"), and by product rather than every product a vendor makes. Polaris may help, but watch the cost.
- Filtering includes everything in Inventory (Windows Server 2019, SQL Server 2016…).
- The feed screen filters well: free text, date range, criticality, vendor and so on. Find relevant information quickly and accurately.
- Rich content: links to external sources and additional information.
- An advisory that names a watched product **without stating versions is shown, marked** "versions not stated".

## What the ADR decides

1. **One shared feed, company-specific relevance.** A public item is read once and every company sees the same item. Watch lists, "possibly affects us", Confirmed and Not relevant belong to each company. Read or unread belongs to each person.
2. **One item per issue.** An item is one CVE, merged from every source that reports it. Each source's own words, severity and links are kept as that source's, untrusted (the ADR 0099 pattern). An advisory with no CVE (NCSC, a blog post) is its own item. A vendor advisory that covers several CVEs is linked to each of them.
3. **Kept in full, never deleted.** Every item from every source is kept, matched or not. History starts with 12 months on first switch-on and grows from there.
4. **Sources** are readers that run on a schedule, each with health shown (last read, items, errors):
   - government alerts: NCSC, CISA's known-exploited list and CISA advisories;
   - NVD, every published CVE, with affected versions filled in from the CVE record's vendor and CISA data where NVD has none;
   - Microsoft;
   - Cisco, Fortinet and Palo Alto;
   - RSS/Atom feeds an admin adds.
5. **Products and versions are understood, not guessed.** An item carries the products it affects, as vendor + product, and the version ranges affected and fixed. Inventory software is linked to a product **once**, suggested by Compass and confirmed by a person. Matching compares version numbers by rule, not by AI.
6. **Polaris reads prose, once.** For an item with no structured product data (an NCSC advisory, a blog post), Polaris pulls out the products and versions it names, once per item, shared by every company, and the item marks it as Polaris's reading. Polaris never decides whether an item matters to a company. If Polaris is off, these items are still searchable and keyword watch lists still catch them.
7. **Watch lists** are company-wide, set by a Security Feed manager: an "everything we run" switch (from Inventory), named products with version ranges, keywords, minimum severity and known-exploited.
8. **A match** is "possibly affects us". It names the systems and compares your version against the affected and fixed versions. An item that names a watched product but no versions is shown marked **versions not stated**. A person **confirms** a match or marks it **not relevant** with a reason.
9. **On a match:** it shows in the feed. Exploited or Critical matches become one action for the Security Feed managers (ADR 0137). A per-person email digest (daily, weekly or off). From a match, **raise a vulnerability** on the named system (ADR 0129), or a risk, linked both ways.
10. **Permissions:** *View security feed* (read, search, mark read) and *Manage security feed* (watch lists, sources, product links, confirm or not relevant, raise). Built-in Admin gets both; the starter roles stay frozen.

## My calls (for Steve to overturn)

- Only the Security Feed managers get the actions for Exploited and Critical matches. Readers rely on the feed and the digest.
- An item marked not relevant **comes back** if it later becomes known-exploited, or its affected versions change to include ours, marked "changed since marked not relevant".
- A person with several companies gets **one digest email**, grouped by company.
- Polaris's reading of prose is done as Compass, not as a person. It's counted in Polaris usage under "Security Feed".
- Links open in a new tab and show their domain. Compass never fetches a linked page, and never loads images from a feed.
- A watch-list entry can name a whole vendor, but it must be chosen deliberately; the default is a product.

## Notes (technical)

- Storage is about 0.5–1 GB a year for 55–65k items, including search indexes and affected ranges. Staging's Postgres uses 398 MB of 5 GiB today. Production sizing gets checked before release.
- Sources that need credentials (an NVD API key for the higher rate limit; Cisco's free openVuln API account) are tiles in the Integrations library (ADR 0128). Keys are kept the same way as the others.

**Chain:** independent (docs only).

**Done when:** ADR 0139 is merged and Steve has read the calls above.