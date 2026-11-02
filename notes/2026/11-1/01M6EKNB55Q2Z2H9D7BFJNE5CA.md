---
id: 01M6EKNB55Q2Z2H9D7BFJNE5CA
created: 2026-11-02T17:07:10.629108Z
updated: 2026-11-02T17:11:43.338777Z
type: task
title: Every published CVE as a source — NVD, with affected and fixed versions filled in from the vendor's own CVE record and CISA's enrichment where NVD has none, the daily likelihood-of-exploitation score, and 12 months of history
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1513
sprint: s6xh9g1
blocked_by:
- 01M6EKMBGM4NTB8WA0GV76AXKA
assignee: steve
label:
- feature
priority: high
task_status: todo
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