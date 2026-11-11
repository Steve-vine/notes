---
id: 01M75SP5AJ9GYE1TW9QB6WGPXX
created: 2026-11-11T17:15:00.818943Z
updated: 2026-11-11T18:41:16.575066Z
type: task
title: A technology asset's support is the worst of its own support and every piece of installed software; its own support date can be N/A
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1736
comments:
- id: 01M75YM2X9ASY2TF8VYZSZB682
  author: Steve Vine
  at: 2026-11-11T18:41:15.689248Z
  text: |-
    Done. PR #1732 (one migration adding the N/A field; ADR 0150, with an amendment note on ADR 0072).

    What you see:
    - An asset's support is the worst of its own and every piece of software installed on it: Out of support, then Not recorded, then Extended support, then In support. Unknown still reads Out of support.
    - The asset page shows a Support fact with what set it, e.g. "Windows Server 2003 (SFT-20), ended 2015-07-14". The list's pill shows the same reason on hover. Where several share the worst state, it names the one ending soonest and adds "and N more".
    - Assets can now read **Extended support**, and the Technology Support filter offers it.
    - **N/A** sits beside Unknown on the asset form and the portal edit, in the CSV import (`n/a`) and in Polaris's add and update tools. Turning one on turns the other off. Either clears the date. A date entered on its own turns both off.
    - Polaris can now clear a date.
    - N/A with nothing installed reads Not recorded.
    - The list, page, filters, out-of-support tile, Inventory summary and the "Software is in support" check all use one rule. The list reads installs in one query, so there's no slowdown.

    Things to know:
    1. **The check:** "Software is in support" now also fails on assets with no support recorded, so it agrees with the tile, which always counted those. It lists each such asset, with the reason, and raises a gap on PAM.1.
    2. **No cloud needed:** the check now judges from the Inventory register, so a company like Moneypenny with no cloud connected no longer reads "can't tell".
    3. **What counts:** only software on an asset's installed-software list counts. What discovery finds but nobody has added is covered by discovery's own findings.
    4. **No CSV export changed:** there is no CSV export of the Technology register today, only the import, which accepts n/a.

    Checks:
    - backend: ruff and mypy clean; unit suite 2,192; 75 + 16 integration tests, covering every Done-when combination;
    - frontend: eslint, tsc and prettier clean; 7 unrelated tests timed out under load and passed when re-run;
    - schema.d.ts regenerated.

    After deploy, the data follow-up: set the VMs to N/A, and give the physical machines their warranty dates when Steve has them.
assignee: steve
label:
- improvement
priority: medium
task_status: review
---
Steve, 2026-11-11, after importing 163 servers and linking each to its operating system in the Software register. Today a technology asset's support comes only from its own date (COM-685).
- **Installed software isn't counted.** A physical server under hardware warranty for two more years but running Windows Server 2003 reads "In support", and the register counts it as supported. Its installed software line separately says Windows Server 2003 is out of support.
- **VMs have no meaningful date of their own.** A VM's own date means nothing, because there's no hardware behind it. Leaving it blank reads "Not recorded", which counts as out of support everywhere a number is reported.

**Behaviour wanted**
- **An "N/A" toggle for support**, beside "Unknown", on the technology asset form, the CSV import (`end_of_support` accepts `n/a`), the assistant's add and update tools, and the portal edit.
  - It means "this asset has no support of its own to track". VMs would usually be N/A; the asset's support then comes from its installed software.
  - N/A and Unknown can't both be set. Setting either clears the date.
  - The assistant's update tool can also clear a date. Today it can only set one.
- **Support is the worst of everything.** An asset's support status, shown in the Technology list, on its page, in filters, in the out-of-support tiles and counts, and in the CSV export, is the **worst** of:
  - its own support (date, Unknown or Not recorded; N/A contributes nothing);
  - the support of **every** piece of software installed on it. An asset can have several, e.g. Windows Server and SQL Server, and each counts.
- **Order, from worst to best:** Out of support, then Not recorded, then Extended support, then In support or Mainstream. Unknown reads as Out of support, as today.
- **Says why:** the asset's page says what set its status, e.g. "Out of support: Windows Server 2003 (SFT-20), ended 2015-07-14". The list's support pill has the same reason as its hover text.
- **N/A with nothing installed** reads "Not recorded", because nothing is known. N/A only removes the asset's own date from the calculation.
- **The Compass check "Software is in support"** and the Inventory and Continuity summaries use the same combined status (`core/inventory_support.py` is the one place the rule lives).

**After it ships (data):**
- The 163 servers imported on 2026-11-11 currently carry their *operating system's* end-of-support date as their own date. Set the VMs to N/A.
- Physical machines get their hardware warranty or support contract dates. Steve will provide them.

**Done when:**
- A VM marked N/A with Windows Server 2019 installed reads "Extended support".
- A physical host with a warranty to 2028 and Windows Server 2003 reads "Out of support", with the reason shown.
- An asset with Windows Server 2022 and SQL Server 2014 reads "Out of support" because of SQL Server.
- Counts, filters, the CSV and the check all agree.
- The assistant can set N/A and clear a date.
- Tests cover the combinations above.

Related: COM-685 (support dates), COM-691/692 (software register, installed software).