---
id: 01M6HGZYM5QT09ACM1XTGEB54Z
created: 2026-11-03T20:18:15.813318Z
updated: 2026-11-03T20:18:18.826219Z
type: task
title: 'A PHP flaw still reads as a Palo Alto one on staging: NVD lists the bundling vendors too, so the CVE''s own vendor needs its description'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1551
sprint: s6xh9g1
assignee: steve
label:
- bug
priority: high
task_status: active
---
Found by Claude checking COM-1543 on staging after the sprint 102 fixes were deployed (2026-11-03, 6932384f).

## What people see

CVE-2026-109618 still reads "Impact of Critical Vulnerabilities in PHP … on Palo Alto Networks Products", with Palo Alto first under Affects. COM-1543 is in, and the quiet re-merge has run over every item.

**Why (technical):** COM-1543 takes "the CVE's own vendors" to be every vendor NVD lists as affected. On staging NVD lists PHP, *and* Palo Alto's PAN-OS and Panorama, *and* nine Siemens products: the bundlers' CPEs. So Palo Alto counts as an own vendor, and its advisory still names the item. The test data only had PHP in NVD's list.

## Fix

Of the vendors NVD lists, the CVE's own are those its own description names, by vendor or product ("PHP uses longjmp()…" → PHP; "PAN-OS lets…" → Palo Alto). Where the description names none of them, all of NVD's vendors count, as now. Raise MERGE_RULES so the worker re-merges every item once more, quietly.

**Done when:** on staging, CVE-2026-109618 and -109619 are titled as PHP flaws with PHP first under Affects; a PAN-OS CVE keeps Palo Alto's title.

Related: COM-1543.