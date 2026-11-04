---
id: 01M6EKNB55Q2Z2H9D7BFJNE5CA
created: 2026-11-02T17:07:10.629108Z
updated: 2026-11-04T07:45:33.804651Z
type: task
title: Every published CVE as a source — NVD, with affected and fixed versions filled in from the vendor's own CVE record and CISA's enrichment where NVD has none, the daily likelihood-of-exploitation score, and 12 months of history
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1513
sprint: s6xh9g1
blocked_by:
- 01M6EKMBGM4NTB8WA0GV76AXKA
comments:
- id: 01M6ESSJAV8NJ38ZCHEP1D54MS
  author: Steve Vine
  at: 2026-11-02T18:54:20.506907Z
  text: |-
    Done: PR #1530 merged.

    What's there (two sources on the Sources tab):
    - NVD (all published CVEs). The first read loads 12 months, showing "Loading history: n of ~N", and carries on where it stopped if interrupted. After that, every 2 hours, it reads whatever changed. Each CVE carries NVD's and the vendor's scores (each labelled with whose), weakness type, references labelled Patch / Vendor advisory / Exploit / Mitigation / Analysis, "exploit published", NVD's status (Rejected kept, marked), and the affected products and versions.
    - Where NVD hasn't analysed a CVE yet, its products come from the vendor's own data in the CVE record, or CISA's, and the item records whose. On a live sample, 19 of 20 recent CVEs got their products this way, so this matters.
    - FIRST EPSS: the daily likelihood-of-exploitation score and its percentile, applied to every CVE in the feed.

    Changes from the task:
    - No NVD API key tile. It isn't needed: 12 months is about 50 requests (roughly 5 minutes) without a key, and the 2-hourly reads are a page or two.
    - Volume is higher than I estimated when planning: about 101,000 CVEs were published in the last 12 months (53,000 in the last four), so storage is nearer 1 GB to start and perhaps 1.5–2 GB a year. Staging has room (5 GiB, 398 MB used); production sizing should be checked before release. I'll note the actual size after the first load on staging.

    To test on staging: the NVD row shows its count and last read; a PHP CVE shows its affected version ranges, fixed version, weakness type, likelihood score and labelled links.
- id: 01M6GYTJ9HK2C8N7VAJMN3A1YC
  author: Steve Vine
  at: 2026-11-03T15:00:44.977262Z
  text: |-
    Pre-UAT (staging, 2026-11-03): **Passed**, after COM-1533.

    - **First load:** the 12-month history loaded from 08:03 to 11:50: 101,677 CVEs, no errors. It stalled at 8,000 between 08:06 and 11:13 when another source raced it on one CVE; that's fixed in COM-1533, and the load carried on from its checkpoint. While it ran, the row said "Loading history: N of ~57,517".
    - **Since then:** it has read on schedule (last read 13:23, 101,726 items) with no problems.
    - **CVE-2025-14180 (PHP):** NVD's and the vendor's scores, each labelled ("Vendor: 8.2 (CVSS 4.0)"); CWE-476; affected ranges per release line and fixed versions; links labelled Exploit and Analysis; "An exploit has been published"; "Likelihood of exploitation in 30 days: 0.70% — higher than 53.1% of CVEs".
    - NVD's NX-OS CVEs (20) are now filed under the same Cisco · NX-OS as Cisco's and CISA's (COM-1536).

    For production sizing: staging's database is 1.3 GB after the full year (it was 398 MB before the sprint).

    Screenshots: ~/compass-uat/sprint-102/COM-1522/item-php.png
assignee: steve
label:
- feature
priority: high
---
Sprint 102, Security Feed (ADR 0139, COM-1510).

## What people see

- **Sources ▸ NVD (all published CVEs)**, switched on by default. New and changed CVEs are read every couple of hours.
- **On first switch-on**, the last 12 months load: about 45–55k CVEs. The Sources row shows progress ("Loading history: 31,200 of ~50,000"). The feed is usable while it loads.

Each CVE item carries:
- **severity and score** (CVSS, its version and vector) from NVD and from the vendor, each labelled with whose it is;
- **type of weakness** (CWE id and name);
- **affected products**, as vendor + product, each with its affected version ranges and, where stated, the fixed version;
- **references**, each labelled by kind where the source says: Patch, Vendor advisory, Exploit, Mitigation, Third-party analysis, Other;
- **Exploit published** when a reference is tagged Exploit;
- **likelihood of exploitation**: the daily FIRST EPSS score as a percentage, with its percentile ("4.2% — higher than 92% of CVEs"), refreshed daily;
- **status** from NVD (Received, Awaiting analysis, Analysed, Modified, Rejected). A **Rejected** CVE stays, marked rejected, and is hidden from the default view.

Where **NVD hasn't analysed a CVE yet** (its backlog is long), the affected products and versions come from the CVE record's vendor data, or CISA's enrichment, and the item says which. If no source gives products, the item shows **"products not stated yet"** and is re-checked as sources update.

The **Integrations** library gets an *NVD* tile for an optional API key, which raises NVD's rate limit. Without one, reading is slower but works.

## Notes (technical)

- NVD API 2.0: `lastModStartDate`/`lastModEndDate` for changes. Backfill by `pubStartDate` in windows of at most 120 days, paged at 2,000. Respect the rate limit (5 or 50 requests per 30 s), back off on 403/503, and resume from the last window after a restart.
- CVE records (CVE List v5): the CNA's `affected` block (vendor, product, versions with `lessThan` / `lessThanOrEqual` / `status`) and the CISA ADP container (Vulnrichment: CPEs, CVSS, SSVC). Read them from the CVE Services API or the cvelistV5 deltas.
- Configurations: keep NVD's CPE match criteria as `vendor:product` plus a range (`versionStartIncluding`, `versionEndExcluding` and so on). Store them in a normalised `feed_item_affected(item_id, vendor, product, range…, source)` table that COM-1518/1520 match against.
- EPSS: FIRST's daily CSV or API. Store the latest score and percentile per CVE, not the history.
- Check worker memory on the backfill (stream pages; don't hold a window in memory). Check the staging DB size after the backfill and note it on this task.

**Chain:** on the chain (migration + API).

**Done when:** on staging:
- 12 months of CVEs have loaded;
- the NVD row shows the count and last read;
- a known PHP CVE shows its affected version ranges and fixed version, CWE, EPSS and labelled references;
- a recent CVE that NVD hasn't analysed shows products from the vendor or CISA, saying so.