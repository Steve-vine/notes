---
id: 01M6EKP9VY4DXX781Q6PFG5XY8
created: 2026-11-02T17:07:42.078675Z
updated: 2026-11-02T17:07:42.078675Z
type: task
title: Cisco, Fortinet and Palo Alto advisories as sources — each vendor's security advisories with the products and versions affected, the first fixed release, workarounds, and whether the vendor knows of exploitation
task_status: todo
priority: medium
assignee: steve
label: feature
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1515
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