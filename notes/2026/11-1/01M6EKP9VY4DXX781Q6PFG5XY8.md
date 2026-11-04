---
id: 01M6EKP9VY4DXX781Q6PFG5XY8
created: 2026-11-02T17:07:42.078675Z
updated: 2026-11-04T07:45:33.823763Z
type: task
title: Cisco, Fortinet and Palo Alto advisories as sources — each vendor's security advisories with the products and versions affected, the first fixed release, workarounds, and whether the vendor knows of exploitation
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1515
sprint: s6xh9g1
blocked_by:
- 01M6EKNB55Q2Z2H9D7BFJNE5CA
comments:
- id: 01M6EW1RF7MYZJJ6H07KBJ0Z77
  author: Steve Vine
  at: 2026-11-02T19:33:46.086929Z
  text: |-
    Done: PR #1532 merged.

    What's there (three rows on Sources, all on by default, each read every 3 hours):
    - Cisco: its public advisory feed, plus each advisory's public CSAF document. That gives every affected release exactly (e.g. 143 ASA releases on one advisory), the fix, workarounds, and whether Cisco's PSIRT says it knows of exploitation (which sets Known exploited, credited to Cisco). An informational notice with no CSAF is kept from the feed with its Security Impact Rating.
    - Fortinet: FortiGuard's advisory feed, plus each advisory's CSAF. That gives version ranges in Fortinet's terms ("FortiOS >=7.6.0|<=7.6.8", "7.4 all versions"), the fix per product line ("FortiOS 7.6: Upgrade to 7.6.9 or above") and workarounds. Where the CSAF is empty, the feed's own words are kept.
    - Palo Alto Networks: its JSON advisories, the latest 200 (more than a year back), with every affected release (e.g. "PAN-OS 12.1.7-h9"), the fixed release per line, the solution and workarounds.
    - Each vendor advisory is its own item, linked to every CVE it covers. Where a vendor lists one CVE once per product, it's merged into one item with every product.

    Changes from the task:
    - No Cisco credentials and no Integrations tile. Cisco's advisories and CSAF documents are public, so nothing needs setting up and Cisco is on from the start.
    - Cisco's and Fortinet's feeds only carry their latest 50 advisories, so their history starts from those, not 12 months. Palo Alto's goes back over a year.

    To test on staging: a FortiOS advisory shows its version ranges, fix and workaround, and links to its CVEs.
- id: 01M6G9YDFRFKNVGGXJ8E22KWDA
  author: Steve Vine
  at: 2026-11-03T08:55:51.032227Z
  text: |-
    Pre-UAT (staging, 2026-11-03): **Passed**, one cosmetic fix logged.

    All three read at 08:07: Cisco 156, Fortinet 99, Palo Alto 105. Cisco reads without credentials, as this task's Review comment says.
    - **Fortinet FG-IR-26-182:** its own page, with affected versions per product ("7.6.0 to 7.6.8; 7.4 to before 7.5; …"), fixed releases, the vendor credited, and a link to its CVE.
    - **Palo Alto PAN-SA-2026-0013:** affected versions, "The fix" with fixed builds, and "No known workarounds exist" in Palo Alto's words.
    - **Cisco IOS XE hardening advisory:** affected releases, and its CVEs listed under Related.
    - FortiOS 7.4.3 in Inventory matched FortiOS advisories with "Our version is affected … Fixed in 7.4.9".

    Found:
    - Palo Alto's score read "9.4 (CVSS )" because it gives no CVSS version. Fixed in COM-1538.
    - Cisco's advisories name products differently from NVD (NX-OS has four names), so a watch list can miss some. Logged as COM-1536 for your call.

    Screenshots: ~/compass-uat/sprint-102/COM-1515/
assignee: steve
label:
- feature
priority: medium
---
Sprint 102, Security Feed (ADR 0139, COM-1510).

## What people see

Three rows on **Sources**: **Cisco**, **Fortinet** and **Palo Alto Networks**. Fortinet and Palo Alto are switched on by default. Cisco is switched on once its credentials are added on **Integrations ▸ Cisco PSIRT** (a free Cisco API account); until then its row says so.

Each vendor advisory:
- is **its own page** ("FG-IR-26-123: FortiOS SSL-VPN heap overflow") with the vendor's title, summary, severity, score, published and updated dates;
- links to every CVE it covers, adding the vendor's details to those CVE items;
- lists **affected products and versions** in the vendor's terms ("FortiOS 7.4.0 through 7.4.5", "PAN-OS 11.1 < 11.1.4-h7") and the **first fixed release**;
- gives **workarounds and mitigations**, in the vendor's words;
- shows **Exploited** when the vendor says it knows of exploitation in the wild, which also sets the item's known-exploited mark, credited to the vendor.

12 months of history load on first switch-on.

## Notes (technical)

- Prefer each vendor's machine-readable advisories:
  - Cisco openVuln API (OAuth client credentials; CSAF per advisory);
  - Palo Alto `security.paloaltonetworks.com` JSON and CSAF;
  - Fortinet PSIRT, via its RSS plus the advisory's CVRF/CSAF.
- Confirm at build time what each vendor actually offers. If one has nothing structured, use its feed and leave products to Polaris (COM-1517). Don't screen-scrape, and say so on this task.
- Version schemes differ (`7.4.5`, `11.1.4-h7`, Cisco train releases such as `17.9.4a`). Store the vendor's raw strings alongside the normalised range in `feed_item_affected`. COM-1518's version comparison has to handle all three.
- Cisco credentials: an Integrations tile (ADR 0128), with keys kept like the others'.

**Chain:** on the chain (migration + API).

**Done when:** on staging, Fortinet and Palo Alto have read 12 months, and Cisco shows "add credentials". A FortiOS advisory shows its affected version ranges, first fixed release and workaround, and links to its CVE items.