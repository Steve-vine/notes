---
id: 01M6EKMP2TDB3NC3FB8Y64BZRM
created: 2026-11-02T17:06:49.05029Z
updated: 2026-11-02T17:06:49.05029Z
type: task
title: Government alerts as a source — NCSC advisories and news, CISA's known-exploited vulnerabilities list (with its fix-by date and ransomware use) and CISA's advisories
label: feature
priority: high
assignee: steve
task_status: todo
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1512
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