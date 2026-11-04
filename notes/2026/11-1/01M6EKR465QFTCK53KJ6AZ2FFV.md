---
id: 01M6EKR465QFTCK53KJ6AZ2FFV
created: 2026-11-02T17:08:41.797867Z
updated: 2026-11-04T07:45:33.851722Z
type: task
title: Products and versions — Compass compares version numbers the way each vendor writes them, and each piece of Inventory software (operating systems and databases included) is linked once to its product, suggested by Compass and confirmed by a person
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1518
sprint: s6xh9g1
blocked_by:
- 01M6EKNB55Q2Z2H9D7BFJNE5CA
- 01M6EKNVMTJN5ZZ0TGXSRFV7AE
comments:
- id: 01M6EYVGQV8W9M08ZCCRQQRFB1
  author: Steve Vine
  at: 2026-11-02T20:22:47.291821Z
  text: |-
    Done. Merged to main (PR #1535). It isn't on staging yet: the whole sprint goes there together once every task is in Review.

    What people see:
    - **Security Feed ▸ Products** lists each company's Inventory software (operating systems and databases included), each with the product it's linked to and the version we run.
    - For software not linked yet, Compass suggests a product from its name ("Microsoft SQL Server 2019" → Microsoft · SQL Server). A manager confirms the suggestion, picks a different product, or marks the software "not in the feed". Nothing is linked until a person says so.
    - A piece of software is linked once, and the link holds for every system it's installed on.
    - Versions are compared the way each vendor writes them: 7.4.5, 11.1.4-h7, Windows builds, Cisco trains and so on. Where a version can't be compared with confidence, Compass says so instead of guessing, and the match shows "versions not stated".

    Worth knowing:
    - Suggestions are worked out when the tab is opened, not stored, so they improve as the feed learns more product names.
    - A product with the release in its name (for example Windows Server 2019) means "any build of that release".
    - For UAT, E2E Test Company may need some PHP or Windows Server software in Inventory, so there's something to link and match.
- id: 01M6EYVYCZZS4X7K1408CBDQHB
  author: Steve Vine
  at: 2026-11-02T20:23:01.279779Z
  text: |-
    Correction to the comment above. The button on screen is **Not tracked**, not "not in the feed". **Confirm all suggestions**, with a preview of how many, and the "Version too vague to compare" note are both built.

    Left out: Polaris suggesting a product for software the name rules can't place. Those rows show **No match**, and a manager picks the product by hand. Say if you want the Polaris suggestion added as its own task.
- id: 01M6G9Z64DQM0NBWS85VVAS8PV
  author: Steve Vine
  at: 2026-11-03T08:56:16.269333Z
  text: |-
    Pre-UAT (staging, 2026-11-03, E2E Test Company): **Passed**

    Set-up: I added two systems to Inventory, AST-32 "E2E pre-UAT 102 web-1" (PHP 8.2.20, FortiOS 7.4.3, FortiManager "latest") and AST-33 "E2E pre-UAT 102 dc-1" (Windows Server 2019 Standard 10.0.17763.6532, Microsoft SQL Server 2016 Standard 13.0, and an internal "E2E pre-UAT 102 Payroll Portal" 2.1).

    As E2E Admin A on Products:
    - Every entry is listed with its publisher, title, version, systems, product and status. The tab heading counts the ones waiting.
    - **Suggested:** Fortinet · FortiOS, Microsoft · SQL Server 2016, Microsoft · Windows Server 2019, and PHP · PHP. PHP was "No match" at first, then suggested once NVD had loaded PHP CVEs.
    - The Payroll Portal was "No match". I marked it **Not tracked**, and Undo appeared.
    - **Confirm all suggestions** asked "Confirm 4" first, then all four showed Confirmed.
    - FortiManager "latest" says "Version too vague to compare: matches will say versions not stated".
    - **Change** opens a picker that searches the feed's products ("fortimanager" → Fortinet · FortiManager (15), FortiManager Cloud (8)).
    - A suggested link isn't used for matching: FortiManager, left Suggested, has no matches.

    Screenshots: ~/compass-uat/sprint-102/COM-1518/
assignee: steve
label:
- feature
priority: high
---
Sprint 102, Security Feed (ADR 0139 §5, COM-1510).

## What people see

**Security Feed ▸ Products** lists every Inventory software entry for the company, including operating systems, database engines, infrastructure software and business applications. Each row shows:
- publisher, title, edition and version as Inventory has them;
- how many systems run it;
- the **product it's linked to** (e.g. "Microsoft · SQL Server", "PHP · PHP", "Fortinet · FortiOS");
- the link's state: **Suggested**, **Confirmed**, **No match** or **Not tracked**.

Linking:
- Compass **suggests** a product for each entry from the publisher and title ("Microsoft SQL Server 2016 Standard" → Microsoft · SQL Server, version 13.0, edition Standard).
- A manager **confirms** a suggestion, picks a different product (a search over every product the feed knows), or marks it **Not tracked** (e.g. an internal app no feed will ever mention).
- **Confirm all suggestions** works in one go, with a preview first.
- An entry added to Inventory later shows up here as Suggested. The Products tab heading counts entries still waiting.

**Version is checked too.** If Inventory's version is missing or too vague to compare ("2016", "latest"), the row says "Version too vague to compare: matches will say versions not stated". It links to the Inventory entry so it can be fixed there.

Microsoft products use Microsoft's own versions: "Windows Server 2019" is matched on its build. If Inventory holds only "2019", Compass treats it as any 2019 build and says so on the match.

## Version comparison (applies to every match)

Compass compares versions as the vendor writes them:
- dotted numbers: `8.2.27`, `10.0.17763.6532`;
- letter suffixes: OpenSSL `3.0.7a`, Cisco `17.9.4a`;
- hotfix suffixes: PAN-OS `11.1.4-h7`;
- Fortinet ranges such as "7.4.0 through 7.4.5";
- Ivanti-style `22.7R2.3`.

Where a version can't be compared reliably, Compass says **can't compare** and never guesses either way.

## My calls

- A Suggested link is **not** used for matching until it's confirmed. One click confirms all suggestions, so the cost is minutes, and a wrong guess never raises a false alarm.
- If Polaris is on, it suggests a product for entries the name rules can't place, marked "Polaris's suggestion". It's still confirmed by a person.

## Notes (technical)

- **Product vocabulary:** distinct `vendor:product` pairs seen in `feed_item_affected`, using CPE vendor and product naming where the source gives it, with aliases (Microsoft product names, vendor names such as "PAN-OS" → `paloaltonetworks:pan-os`). Seed the aliases for common software (Windows Server editions, SQL Server, Exchange, PHP, OpenSSL, Apache, nginx, Java, .NET, FortiOS, PAN-OS, IOS XE…).
- **Links:** `software_product_links(company_id, software_asset_id, vendor, product, version_normalised, state, confirmed_by)`. Inventory stays as it is.
- **Version comparison:** a single `compare(a, b, scheme)` with schemes for semver-ish, Microsoft build, Cisco, PAN-OS hotfix, Fortinet and Ivanti, plus a fallback that returns "unknown". Consider `univers` (aboutcode), which handles many of these. Property tests on ordering.
- Matching itself (items × links) is COM-1520.

**Chain:** on the chain (migration + API).

**Done when:** on staging in E2E Test Company:
- the Products tab lists Inventory's software with suggestions;
- a manager confirms "Windows Server 2019" and "PHP 8.2", and corrects one suggestion;
- an entry with a vague version says so.

Unit tests cover version ordering for each scheme.