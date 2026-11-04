---
id: 01M6EKMP2TDB3NC3FB8Y64BZRM
created: 2026-11-02T17:06:49.05029Z
updated: 2026-11-04T07:46:09.072891Z
type: task
title: Government alerts as a source — NCSC advisories and news, CISA's known-exploited vulnerabilities list (with its fix-by date and ransomware use) and CISA's advisories
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1512
sprint: s6xh9g1
blocked_by:
- 01M6EKMBGM4NTB8WA0GV76AXKA
comments:
- id: 01M6ERHQQ295CMMX1ZYJTZ3WY5
  author: Steve Vine
  at: 2026-11-02T18:32:35.298235Z
  text: |-
    Done: PR #1529 merged.

    What's there (three sources on the Sources tab, all on by default):
    - CISA known exploited: the whole catalogue, every 3 hours. A CVE on it is marked Known exploited with CISA's date added, CISA's due date, ransomware use (Known / not known), CISA's required action, and the vendor and product (versions not stated). If the CVE is already in the feed it gains the mark rather than becoming a twin. A CVE CISA takes off the catalogue is marked "No longer marked known exploited" in its history.
    - NCSC: the News feed (alerts such as "Critical security issue affecting PHP") and the Reports feed (threat reports), hourly. Each entry is its own item, linked to the CVEs it names.
    - CISA advisories: CISA's alerts and ICS advisories feed, hourly, each linked to its CVEs.

    Checked against the live sources: 1,766 KEV entries (361 known to be used in ransomware), 20 NCSC news, 20 NCSC reports, 30 CISA advisories.

    My calls:
    - NCSC's blog and guidance feeds are left out: they aren't alerts.
    - NCSC and CISA only carry their latest 20–30 entries, so their history starts from those, not 12 months. CISA's catalogue is complete.
    - Text is kept as plain text only; images and markup in the feeds are dropped.
- id: 01M6G9X62EGHR2866HVMDKKH96
  author: Steve Vine
  at: 2026-11-03T08:55:10.670653Z
  text: |-
    Pre-UAT (staging, 2026-11-03): **Failed** for CISA advisories. NCSC and CISA known exploited passed.

    - **CISA known exploited:** 1,766 entries read at 08:07. CVE-2025-68686 (FortiOS) shows "Known exploited — says CISA known exploited", "CISA due 10 Aug 2026", "Used in ransomware campaigns: Not known" and CISA's required action under Mitigations. Where NVD already had the CVE, the mark joined the existing item.
    - **NCSC:** 40 items (news and reports), each in NCSC's words with its link.
    - **CISA advisories:** the row says "The source refused the request (403)" and has read nothing. cisa.gov turns away Compass's automated requests to that feed from staging, though the known-exploited file on the same site reads fine. Logged as COM-1537, with options for you to choose from. Compass won't pose as a browser to get round it.
    - On the first read, the CISA list and NVD both brought one new CVE at the same moment, which broke NVD's read. Fixed in COM-1533.

    Screenshots: ~/compass-uat/sprint-102/COM-1522/item-fortios-kev.png
assignee: steve
label:
- feature
priority: high
task_status: done
---
Sprint 102, Security Feed (ADR 0139, COM-1510).

## What people see

Three rows on **Sources**: *NCSC*, *CISA known exploited* and *CISA advisories*, all switched on by default.

**CISA known exploited:**
- an item on the list is marked **Known exploited**, with the date CISA added it;
- CISA's own fix-by date ("CISA due 2026-11-21");
- "Used in ransomware campaigns: Known" when CISA says so;
- CISA's required action, in its words.

If the CVE is already an item (from NVD), the existing item gains the mark rather than becoming a second item. If the CVE isn't an item yet, it becomes one, and NVD's details fill in later.

**NCSC:** advisories, alerts and threat reports, each its own item unless it names CVEs, in which case it's linked to those items. Title, summary, published date and the link to the NCSC page.

**CISA advisories:** cybersecurity and ICS advisories, linked to the CVEs they name.

On first switch-on: the whole known-exploited list (it's small), and 12 months of NCSC and CISA advisories.

## Notes (technical)

- KEV: CISA's JSON catalogue. Re-read it daily. A CVE dropping off the list is recorded, but the item keeps its history.
- NCSC: its RSS feeds. CISA advisories: its RSS feeds. Use the feeds' own links. Don't scrape pages beyond what the feed carries.
- Products and versions in NCSC/CISA prose are left for Polaris (COM-1517). KEV's vendor and product fields are structured, so record them as a vendor/product name (no versions).

**Chain:** on the chain (migration + API).

**Done when:** on staging, Sources shows all three reading. A CVE that's on CISA's list shows Known exploited, the CISA due date and its ransomware status, and an NCSC advisory from the last week appears in the feed.