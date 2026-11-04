---
id: 01M6EKNVMTJN5ZZ0TGXSRFV7AE
created: 2026-11-02T17:07:27.514674Z
updated: 2026-11-04T07:46:09.087167Z
type: task
title: Microsoft's security updates as a source — each month's CVEs with the exact products affected (Windows Server 2019, SQL Server 2016 SP3…), Microsoft's own severity, exploited and publicly-disclosed flags, and the KB and build that fix it
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1514
sprint: s6xh9g1
blocked_by:
- 01M6EKNB55Q2Z2H9D7BFJNE5CA
comments:
- id: 01M6ETVQ6H097B8AAZJ74MBQZZ
  author: Steve Vine
  at: 2026-11-02T19:12:59.601452Z
  text: |-
    Done: PR #1531 merged.

    What's there (Sources ▸ Microsoft, on by default):
    - The first read takes Microsoft's releases from the last 12 months. After that, every 6 hours, it reads any release Microsoft has revised (out-of-band fixes arrive as revisions).
    - Each Microsoft CVE adds to its item:
      - Microsoft's title, severity (Critical, Important, Moderate, Low; Important counts as High) and impact ("Elevation of Privilege");
      - Exploited and Publicly disclosed, as Microsoft states them (Exploited sets Known exploited, credited to Microsoft);
      - the weakness type with its name;
      - workarounds and mitigations;
      - for every affected product by Microsoft's own name, the KB, the fixed build and whether a restart is needed.
    - Products are filed under the names NVD uses (e.g. Windows Server 2019 and its Server Core install are one product), with each fixed build as the version range, so Inventory's Windows Server 2019 can be linked to it (COM-1518).
    - Each month is an advisory of its own ("October 2026 Security Updates"), linked to every CVE in it.

    My call:
    - Entries that only concern Azure Linux packages are left out (about 1,200 of October's 3,400). They're other projects' CVEs, which NVD already carries.

    Checked against the live October release: 2,216 CVEs read in about a second.
- id: 01M6G9YA0VRP86N1YF6SFCM8MC
  author: Steve Vine
  at: 2026-11-03T08:55:47.483531Z
  text: |-
    Pre-UAT (staging, 2026-11-03): **Passed**

    - The Microsoft row read 12 monthly releases (8,179 items) at 08:03.
    - CVE-2026-54118 (SQL Server RCE) shows Microsoft's products by name ("Microsoft SQL Server 2016 for x64-based Systems Service Pack 3 (GDR)", …). For each it lists affected and fixed builds, and "The fix" table gives the KB, fixed build and restart for every product. It has a Security Update Guide link, and Related shows "July 2026 Security Updates".
    - "October 2026 Security Updates" is its own page, listing its CVEs.
    - Matching uses Microsoft's builds. Windows Server 2019 at 10.0.17763.6532 matched the Windows CVEs fixed in later builds. SQL Server 2016 at "13.0" matched at release-line level, and the page says "Some releases of our version line are affected: check which we run".

    Screenshots: ~/compass-uat/sprint-102/COM-1522/item-sqlserver.png, ~/compass-uat/sprint-102/COM-1514/
assignee: steve
label:
- feature
priority: high
task_status: done
---
Sprint 102, Security Feed (ADR 0139, COM-1510).

## What people see

**Sources ▸ Microsoft**, switched on by default. It reads each Patch Tuesday release and the out-of-band updates in between.

A Microsoft CVE joins its item (from NVD) and adds:
- **Microsoft's severity** (Critical, Important, Moderate, Low) and its impact ("Remote Code Execution", "Elevation of Privilege");
- **Exploited** and **Publicly disclosed**, as Microsoft states them. Exploited also sets the item's known-exploited mark, credited to Microsoft;
- **affected products by name**, as Microsoft lists them ("Windows Server 2019", "Windows Server 2019 (Server Core installation)", "Microsoft SQL Server 2016 for x64-based Systems Service Pack 3 (GDR)");
- for each product, **the fix**: the KB article, the fixed build number, and whether a reboot is needed;
- **mitigations and workarounds**, in Microsoft's words, where given;
- a link to the Security Update Guide entry.

Each month's release is also an advisory page ("November 2026 Security Updates") listing its CVEs.

12 months of history load on first switch-on.

## Notes (technical)

- MSRC CVRF API v3 (no key): `/updates` lists the releases; `/cvrf/{id}` has `ProductTree`, `Vulnerability[].Threats` (impact, severity, exploited and disclosed from the `Exploitability` threat) and `Remediations` (KB, `FixedBuild`, `RestartRequired`).
- Product mapping: record Microsoft's product name and its product id. Map each to a `vendor:product` plus a version where it can be derived (Windows builds, SQL Server version and CU/GDR), so that COM-1518 links Inventory's "Windows Server 2019" to it. Keep Microsoft's own name for display.
- The fixed build gives a real version range ("affected below 10.0.17763.6532"). Store it in `feed_item_affected` as the source "Microsoft".

**Chain:** on the chain (migration + API).

**Done when:** on staging, the last Patch Tuesday is in the feed. A Windows Server 2019 CVE shows Microsoft's severity, impact, exploited and disclosed flags, the KB and fixed build for Windows Server 2019, and links to the Security Update Guide.