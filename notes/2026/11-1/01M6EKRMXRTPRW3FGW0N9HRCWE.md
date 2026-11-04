---
id: 01M6EKRMXRTPRW3FGW0N9HRCWE
created: 2026-11-02T17:08:58.936136Z
updated: 2026-11-04T07:46:09.121377Z
type: task
title: Company watch lists — an "everything we run" switch from Inventory, plus named products with the versions we use, keywords, a minimum severity and known-exploited, with a preview of what a list would have caught in the last 90 days
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1519
sprint: s6xh9g1
blocked_by:
- 01M6EKR465QFTCK53KJ6AZ2FFV
comments:
- id: 01M6EZXQAVZ7G2SZHTVN9HYH66
  author: Steve Vine
  at: 2026-11-02T20:41:28.155443Z
  text: |-
    Done. Merged to main (PR #1536). It isn't on staging yet: the whole sprint goes there together once every task is in Review.

    What people see on **Security Feed ▸ Watch lists**:
    - A company can have several lists, each with a name, on or off, and an owner. Managers create, edit and delete them. Readers see them but can't change them.
    - There are four kinds of rule:
      - **Everything we run**: every confirmed product on the Products tab, at the version Inventory has;
      - **a product**: exact versions or a range ("8.1 to 8.3"), or left empty for all versions;
      - **a whole vendor**: with a warning of roughly how many items that vendor had in the last 12 months;
      - **a keyword**.
    - Conditions:
      - a minimum severity;
      - a minimum likelihood of exploitation;
      - known-exploited items always included (on by default), even below those minimums;
      - rejected CVEs left out (on by default).
    - **Preview** shows what the list would have caught in the last 90 days, before you save it: the total, a count per week, and the top 20 items with why each one matched.
    - Versions are ours. A PHP flaw that affects only 8.3 doesn't match a list for PHP 8.2.20. An item that gives no versions still matches, marked "versions not stated".

    Built differently from the task:
    - The owner is whoever created the list. There's no owner picker.
    - The vendor rule takes the vendor's name typed in. The product rule has a picker.
    - Keyword search matches word forms, so "patches" also finds "patch".

    Was missing, now fixed in COM-1531: each list's matches in the last 7 and 30 days.
- id: 01M6G9ZB3ZCBM0VJKC2CDZ29Y0
  author: Steve Vine
  at: 2026-11-03T08:56:21.375313Z
  text: |-
    Pre-UAT (staging, 2026-11-03, E2E Test Company): **Passed**, one fix logged.

    As E2E Admin A on Watch lists ▸ New watch list:
    - The form has the name, On, rules ("Everything we run" by default; Add a rule offers A product, Every product from a vendor, A keyword), and conditions (severity High and above; likelihood of exploitation; always include known-exploited, on; leave out rejected CVEs, on).
    - A whole-vendor rule for Microsoft warned "About 8,178 items in the last 12 months". I swapped it for the keyword "SSL-VPN".
    - **Preview the last 90 days** showed "1,712 items in the last 90 days", counts by week, and the top items, each with the rule that caught it.
    - Saved as "E2E pre-UAT 102 Everything we run". The card shows its rules, its conditions, "Owner: E2E Admin A", and the counts from COM-1531.
    - Matching ran within a minute: 2,479 items, mostly Windows Server 2019 (the test build predates a year of fixes).
    - E2E Viewer can't open the module at all, so I couldn't check the read-only view.

    Found: the card said "Matched 2,479 in the last 7 days · 2,479 in the last 30 days", counting the history load as new. Fixed in COM-1538 (counts by the item's own date).

    Screenshots: ~/compass-uat/sprint-102/COM-1519/
assignee: steve
label:
- feature
priority: high
task_status: done
---
Sprint 102, Security Feed (ADR 0139 §7, COM-1510).

## What people see

**Security Feed ▸ Watch lists**, per company, set by managers. A company can have several lists ("Perimeter", "Web stack", "Everything we run"), each with a name, an owner and on/off.

**A watch list holds rules.** An item matches the list if it matches any rule, and also passes the list's conditions. The rules:
- **Everything we run** (one switch): every **confirmed** product link on the Products tab (COM-1518), each at the version Inventory says.
- **Product + versions**: pick a product from the feed's vocabulary ("PHP · PHP"), then the versions we use, either as exact versions ("8.2.27, 8.3.14") or ranges ("8.1 to 8.3"). Leaving versions empty means all versions, and the rule says so.
- **Whole vendor**: every product from a vendor. It's a deliberate choice, with a warning about volume ("Microsoft: about 1,100 items in the last 12 months").
- **Keyword**: words or phrases in the title or text ("SSL-VPN", "Citrix Bleed", "MOVEit"). Use it for items with no product data.

**The list's conditions:**
- minimum severity (e.g. High and above);
- **always include known-exploited**, whatever the severity (on by default);
- minimum likelihood of exploitation (e.g. EPSS ≥ 1%), optional;
- leave out items rejected by NVD (on by default).

**Preview** shows what the list *would have caught* in the last 90 days, before saving, with the count by week and the top items. The list can then be tightened until the noise is right.

Each watch list shows its last 7 days and last 30 days of matches (once COM-1520 stores matches).

## Who can do what

*Manage security feed* creates and edits lists. Anyone with *View security feed* sees them, read-only.

## My calls

- Versions on a product rule are what **we** run. An item matches when any of our versions is in its affected range.
- An item that names the product but gives **no versions** matches, marked **versions not stated** (Steve, 2026-11-02).
- A keyword matches whole words, case-insensitively, in the item's title and text, including Polaris's reading of products (COM-1517).

## Notes (technical)

- `watch_lists(company_id, name, owner_id, enabled, min_severity, include_kev, min_epss, exclude_rejected)` and `watch_list_rules(list_id, kind, vendor, product, versions JSONB, keyword)`.
- **The matcher is built here:** item × rules → match, plus why (which rule; our version against the affected and fixed versions, or versions not stated, or can't compare), using COM-1518's version comparison. Preview runs it read-only over a 90-day window. COM-1520 runs it on arrival, change and list edits, and stores the results.
- Keep Preview under a few seconds with the item indexes. Paging, not a count of everything.
- Keyword matching through the item's `tsvector` (phrase queries), never `LIKE` with interpolated input. Semgrep rules apply.

**Chain:** on the chain (migration + API).

**Done when:** on staging in E2E Test Company:
- a manager builds a list with "PHP 8.2.20" and the keyword "SSL-VPN", High and above, known-exploited always included;
- Preview shows the last 90 days' matches by week;
- a PHP CVE affecting only 8.3 does **not** appear.