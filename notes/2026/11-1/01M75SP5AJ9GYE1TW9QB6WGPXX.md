---
id: 01M75SP5AJ9GYE1TW9QB6WGPXX
created: 2026-11-11T17:15:00.818943Z
updated: 2026-11-11T22:19:03.506647Z
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
- id: 01M76B2WEJPQ2REJDRYQ7XDCXP
  author: Steve Vine
  at: 2026-11-11T22:19:03.506339Z
  text: |-
    Passed on screen; the assistant part couldn't be checked (Claude's pre-UAT pass, staging fcaf1d13, as E2E Admin A in E2E Test Company).

    Set up: software SFT-21 to SFT-24 ("E2E 1736 …" Windows Server 2003, 2019 and 2022, and SQL Server 2014, with their real support dates), and three technology assets.

    Seen:
    - **The form:** N/A sits beside Unknown, with the hint "N/A (a VM) leaves it to the installed software".
      - Typing a date and then switching Unknown on cleared and locked the date.
      - Switching N/A on then turned Unknown off.
    - **AST-35, a VM marked N/A:**
      - with nothing installed, it reads "Not recorded", with the reason "it has no support of its own (N/A) and no software installed";
      - after adding Windows Server 2019, it reads EXTENDED SUPPORT: "E2E 1736 Windows Server 2019 (SFT-22), extended support to 2029-01-09".
    - **AST-36, its own date 30 Jun 2028, with Windows Server 2003:** OUT OF SUPPORT, "E2E 1736 Windows Server 2003 (SFT-21), ended 2015-07-14".
    - **AST-37, with Windows Server 2022 and SQL Server 2014:** OUT OF SUPPORT, "E2E 1736 SQL Server 2014 (SFT-24), ended 2024-07-09". Windows Server 2022 alone shows Extended support.
    - **The list:** pills match the asset pages. Hovering AST-36's pill shows "Out of support: E2E 1736 Windows Server 2003 (SFT-21), ended 2015-07-14".
    - **Filters:** the Support filter offers In support, Extended support and Out of support. Extended support lists only AST-35. Out of support, across all environments, lists 5: AST-36, AST-37, and three assets with nothing recorded.
    - **The check:** I ran "Software is in support". It now reads FAILING, "5 technology assets are out of support or not recorded". It lists the same 5 with the same reasons, without needing a cloud connection. Before the run, it read "Can't tell".
    - **The dashboard:** the Inventory tile reads 5 OUT OF SUPPORT. List, filter, check and tile agree.

    Couldn't check:
    - **The assistant setting N/A and clearing a date:** needs Polaris's AI provider.
    - **CSV import with n/a:** I didn't run an import.
    - **The portal edit's N/A:** not tried.

    Small observation, not a defect: the check is mapped to control VUM.1, but the build note says it raises a gap on PAM.1. Worth a glance.

    Screenshots: ~/compass-uat/sprint0-2026-11-11/COM-1736/
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