---
id: 01M6EKT5J234PTM7M7D02CGS6B
created: 2026-11-02T17:09:48.738121Z
updated: 2026-11-04T07:46:09.133234Z
type: task
title: 'The Feed tab — find the right item fast: free-text search, published or updated date range, severity and score, known-exploited, likelihood of exploitation, vendor, product, source, "affects us" and status, with new or read per person and filters kept in the web address'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1521
sprint: s6xh9g1
blocked_by:
- 01M6EKSK3GGHY1E8J0FQPE60NV
comments:
- id: 01M6F27S79Z5QDGT36K6E0GSJ6
  author: Steve Vine
  at: 2026-11-02T21:21:54.921766Z
  text: |-
    Done. Merged to main (PR #1538). It isn't on staging yet: the whole sprint goes there together once every task is in Review.

    What people see on **Security Feed ▸ Feed**:
    - It opens on **Affects us**: items matching the company's watch lists that aren't marked not relevant, newest first. One switch shows **Everything**, the whole feed of the last 12 months.
    - **Search** finds words or a quoted phrase. Typing a CVE or advisory id jumps straight to that item.
    - **Filters:**
      - published or updated date, with last 24 hours, 7 days, 30 days or 12 months;
      - severity, minimum score, known exploited, exploit published, minimum likelihood of exploitation;
      - vendor and product;
      - source, status and watch list;
      - unread only.

      Every filter is kept in the web address, so a filtered view can be bookmarked or shared. **Clear filters** resets them.
    - Sort by updated, published, severity, score or likelihood. 50 rows a page.
    - Each row shows the id, title, severity, score, exploited and exploit marks, likelihood, products, sources, dates and the company status, with the number of systems under the status.
    - **Read and unread are per person.** Unread rows are bold, and opening an item marks it read. **Mark selected as read** and **Mark all as read** (for the current filter) are both there. The tab shows how many Affects-us items you haven't read.
    - **Export CSV** downloads the current filter, up to 10,000 rows.
    - Rejected CVEs are hidden unless you search for one by id.

    Built differently from the task:
    - Score and likelihood are minimums picked from a short list (score 4.0+, 7.0+ or 9.0+; likelihood 1%, 10% or 50%), not free ranges.
    - Dates are the quick picks only, with no custom from–to range on screen.
    - The number of systems sits under the status rather than in a column of its own.
- id: 01M6G9ZKKVZ8DHMDHYQR2Z4C8Z
  author: Steve Vine
  at: 2026-11-03T08:56:30.074797Z
  text: |-
    Pre-UAT (staging, 2026-11-03, E2E Test Company): **Passed**

    As E2E Admin A on the Feed tab:
    - It opens on **Affects us** (2,478 items). The tab title shows the unread count ("Feed 2476" after I opened two items). Unread rows are bold.
    - The columns are item, severity, score, likelihood, products ("+14" beyond two), sources, published, updated and status, with the systems count.
    - **Everything** shows 17,884 items.
    - The phrase search "SSL-VPN" finds 5. Searching a CVE id (CVE-2025-14180) jumps straight to its page.
    - Filters are kept in the address: reloading kept the search, and /security-feed?view=everything&severity=critical&exploited=yes&since=12m opened with those filters set (28 items). Clear filters appears.
    - **Export CSV** downloaded security-feed-2026-11-03.csv with 2,478 rows: id, title, severity, score, known exploited, exploit published, likelihood, products, sources, dates, status and systems.

    Screenshots: ~/compass-uat/sprint-102/COM-1521/
assignee: steve
label:
- feature
priority: high
task_status: done
---
Sprint 102, Security Feed (ADR 0139, COM-1510).

## What people see

**Security Feed ▸ Feed** opens on **Affects us**: items matching the company's watch lists that aren't marked not relevant, newest first. One switch flips to **Everything**, the whole unfiltered feed of every item from every source, for searching history (Steve, 2026-11-02).

**Search and filters**, all usable together:
- **Free text** over the CVE id, title, description, each source's text, products named and vendor advisory ids. Exact phrases in quotes. Typing a CVE id or advisory id (FG-IR-26-123) jumps straight to it.
- **Date range**, published or updated (a choice), with quick picks: last 24 hours, 7 days, 30 days, 12 months.
- **Severity**: Critical, High, Medium, Low, None. Plus a **CVSS score** range.
- **Known exploited** (yes or no) and **Exploit published**.
- **Likelihood of exploitation**: a minimum EPSS percentage or percentile.
- **Vendor** and **product**, multi-select pickers from the vocabulary.
- **Source**: NVD, CISA, NCSC, Microsoft, Cisco, Fortinet, Palo Alto, each admin feed.
- **Affects us** and **company status**: Possibly affects us, Versions not stated, Confirmed, Not relevant, Changed since marked not relevant.
- **Watch list**.
- **Unread only**.

Every filter is **kept in the web address**, so a search can be bookmarked, shared or refreshed. **Clear filters** resets them.

**The table**:
- CVE or advisory id;
- title;
- severity pill and score;
- Known exploited and Exploit published marks;
- EPSS;
- vendor and product (first two, then "+3");
- sources (small badges);
- published and updated dates;
- company status;
- systems affected (a count).

New items are bold until opened. Sortable by date, severity, score and EPSS. Paged.

Also:
- **Mark as read** for one or many, and **Mark all as read** for the current filter. Read state is per person.
- The tab title shows the unread count of Affects us.
- **Export** of the current filter to CSV (up to 10,000 rows).

## My calls

- The default sort is newest updated first, so a re-scored or newly exploited item rises to the top.
- Rejected CVEs are hidden unless the source filter or a CVE search asks for them.

## Notes (technical)

- `GET /security-feed/items`: filter params, cursor paging, and `company_id` for status and matches. Postgres full-text (`websearch_to_tsquery`) on the item `tsvector`. GIN on the `tsvector`; btree on published, updated, severity, EPSS and known-exploited; GIN on `vendor_products` (array).
- Target under 500 ms for a typical filter over 12 months (about 60k items). Test with a generated 100k-row fixture locally, not in CI.
- `feed_item_reads(user_id, item_id, read_at)`.
- Filters go through the `useQueryState` hooks (COM-792), with flushSync on navigation.
- Screen conventions: SortableTh, pills never truncate, page header and tab title.

**Chain:** on the chain (API).

**Done when:** on staging, as a reader in E2E Test Company:
- searching "SSL-VPN" over 12 months with Critical, Known exploited and Fortinet finds the expected items;
- the filters survive a page refresh and a copied link;
- Everything shows unmatched items;
- read and unread is per person (the admin's read items stay bold for the reader).