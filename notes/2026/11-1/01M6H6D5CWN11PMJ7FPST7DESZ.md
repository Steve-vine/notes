---
id: 01M6H6D5CWN11PMJ7FPST7DESZ
created: 2026-11-03T17:13:14.396546Z
updated: 2026-11-04T07:46:09.239777Z
type: task
title: A CVE in a common product takes its title and first products from another vendor's advisory, so a PHP flaw reads as a Palo Alto one
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1543
sprint: s6xh9g1
comments:
- id: 01M6H6NCAKNHK0GZMEYXQ58TPM
  author: Steve Vine
  at: 2026-11-03T17:17:43.635077Z
  text: 'Steve decided (2026-11-03): the one-off re-merge of existing items on deploy stays out of each item''s change history (as tidy-feed-names did), so a year of items don''t all show "title changed". New source changes after the fix are recorded as usual.'
- id: 01M6HCQZXQGMDF9E1365FSKFHH
  author: Steve Vine
  at: 2026-11-03T19:04:00.69504Z
  text: |-
    Done (PR #1558, merged 2026-11-03). Not on staging yet.

    What people see now: a CVE in a common product reads as that product's flaw. When a vendor's advisory is about its own products that include someone else's software (Palo Alto on PHP in PAN-OS), its words no longer name the item. The CVE's own vendor, then CISA's title, then NVD's first sentence come first. So CVE-2026-109618 should read "PHP multipart/form-data insecure out-of-memory error handling", and CVE-2026-109619 "PHP insecure state initialization use-after-free". PHP comes first under Affects, with Palo Alto and Siemens after it. The feed list, the item page and the digest all use the same title and order. A Palo Alto CVE about PAN-OS still takes Palo Alto's title.

    Existing items are worked out again once, quietly, as you decided — no history entries, not marked Updated — by the worker within about 10 minutes of the deploy.

    Verified: integration test with NVD + a "bundling" vendor + a government source: CISA's title wins; without CISA, NVD's first sentence; a PAN-OS CVE keeps Palo Alto's title; feed row, item page and Affects order agree.

    To check on staging (~10 min after deploy): CVE-2026-109618 and -109619 in the feed list and on their pages.
- id: 01M6HK8G7RTAAQZ57DTWSAPD36
  author: Steve Vine
  at: 2026-11-03T20:57:53.14358Z
  text: 'Checked on staging after deploy: on its own this fix wasn''t enough — NVD lists Palo Alto and Siemens products against CVE-2026-109618 too, so Palo Alto still counted as the CVE''s own vendor. Fixed forward in COM-1551 (now on staging): CVE-2026-109618 reads "PHP Memory Corruption Vulnerability", -109619 "PHP Stale Internal Request-State Vulnerability", PHP first under Affects; PAN-OS CVEs keep Palo Alto''s titles.'
assignee: steve
label:
- bug
priority: high
task_status: done
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