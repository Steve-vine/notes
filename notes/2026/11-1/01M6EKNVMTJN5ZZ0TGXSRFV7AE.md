---
id: 01M6EKNVMTJN5ZZ0TGXSRFV7AE
created: 2026-11-02T17:07:27.514674Z
updated: 2026-11-02T17:07:27.514674Z
type: task
title: Microsoft's security updates as a source — each month's CVEs with the exact products affected (Windows Server 2019, SQL Server 2016 SP3…), Microsoft's own severity, exploited and publicly-disclosed flags, and the KB and build that fix it
assignee: steve
priority: high
label: feature
task_status: todo
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1514
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