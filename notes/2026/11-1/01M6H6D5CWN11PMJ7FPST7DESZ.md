---
id: 01M6H6D5CWN11PMJ7FPST7DESZ
created: 2026-11-03T17:13:14.396546Z
updated: 2026-11-03T17:13:14.396546Z
type: task
title: A CVE in a common product takes its title and first products from another vendor's advisory, so a PHP flaw reads as a Palo Alto one
priority: high
task_status: todo
label: bug
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1543
---
Found by Steve testing sprint 102 on staging (2026-11-03).

## What people see

CVE-2026-109618 is a critical PHP flaw (in CISA's known exploited list) that affects PHP wherever it runs. In the feed it reads:

- **Title:** "Impact of Critical Vulnerabilities in PHP (CVE-2026-109618, CVE-2026-109619) on Palo Alto Networks Products"
- **Affects:** "Palo Alto Networks · PAN-OS, Palo Alto Networks · Panorama Virtual Appliance +10"

It looks like it only matters if you run Palo Alto equipment. PHP is in the item, but hidden in the "+10".

Expected: it reads as a PHP flaw, and PHP is the first thing it says it affects. Palo Alto and Siemens show as other vendors whose products include the affected PHP.

**What staging holds (technical):** one item with four sources, merged correctly by CVE id:
- NVD: no title (NVD never gives one), PHP / php-src
- Palo Alto: first seen 08:07, title as above, PAN-OS and Panorama
- CISA KEV: exploited, due 29 Oct
- CISA CSAF (VA-26-295-01): title "PHP multipart/form-data insecure out-of-memory error handling", PHP plus 8 Siemens products

CVE-2026-109619 has the same shape, with CSAF's title "PHP insecure state initialization use-after-free".

**Cause (technical):** `ingest._merge_words` takes the title from the first source that has one, with sources ordered by `_KIND_ORDER` (CVE databases 10, vendor 30, government 50). NVD has no title, so a vendor's advisory wins over CISA's even when that advisory is about the vendor's *own products that bundle* someone else's software. The affected names are shown in alphabetical order by vendor, so paloaltonetworks comes before php.

## To decide when fixing

- **Title:** a vendor's advisory names the item only when the vendor is the CVE's own vendor, i.e. NVD's or the CNA's affected vendor, or the vendor assigned the CVE. Otherwise prefer a CISA/CSAF title, then NVD's first sentence.
- **Affects:** list the CVE's own product first (from NVD/the CNA), then the vendors that ship it. Perhaps "PHP · PHP — also in Palo Alto Networks PAN-OS, Siemens …".
- Existing items need re-merging once (like the tidy-feed-names job), not just new ones.
- Check the Polaris-read summary and the digest email use the same title.

**Done when:** on staging, CVE-2026-109618 and CVE-2026-109619 are titled as PHP flaws, with PHP first under Affects; a Palo Alto–only CVE (e.g. a PAN-OS one) still takes Palo Alto's title; and the feed list, item page and digest agree.