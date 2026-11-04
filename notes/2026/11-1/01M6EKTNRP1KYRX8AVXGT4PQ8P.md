---
id: 01M6EKTNRP1KYRX8AVXGT4PQ8P
created: 2026-11-02T17:10:05.334375Z
updated: 2026-11-04T07:46:09.138995Z
type: task
title: 'The item page — everything known about one issue in one place: affected and fixed versions per product, the score in plain words, exploitation status, the vendor''s fix and workarounds, links grouped by kind, what each source said, and the item''s history'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1522
sprint: s6xh9g1
blocked_by:
- 01M6EKT5J234PTM7M7D02CGS6B
comments:
- id: 01M6F31FB1VXH6N5DG7RBYP7C3
  author: Steve Vine
  at: 2026-11-02T21:35:56.769862Z
  text: |-
    Done. Merged to main (PR #1539). It isn't on staging yet: the whole sprint goes there together once every task is in Review.

    What people see when they open an item:
    - **The header** shows:
      - the id and title;
      - a severity pill with the score;
      - Known exploited, Exploit published, Updated and Rejected marks;
      - when it was published, updated and first seen;
      - the company's status for it.

      Managers get Confirm, Not relevant, Reopen and Raise here.
    - **Exploitation:**
      - who says it's exploited (CISA, Microsoft, the vendor);
      - CISA's due date and whether ransomware uses it;
      - whether an exploit is published;
      - the likelihood of exploitation with its percentile.
    - **The score in plain words**, for CVSS 3.x and 4.0 (for example "anyone on the internet, no login, no user action, full control"). Other sources' scores are shown where they differ, along with the weakness type (CWE).
    - **Does it affect us?**, from COM-1520.
    - **Affected products:** each product with its affected and fixed versions, saying who says so, with the vendor's own wording quoted.
    - **The fix:** the KB and fixed build per product, whether a restart is needed, and the workarounds and mitigations.
    - **Links**, grouped as Patch, Vendor advisory, Exploit, Mitigation, Analysis and Other. Each shows its site and opens in a new tab.
    - **Related items**, and **Raised from this item** (COM-1525).
    - **What each source said**, one read-only panel per source, with "(added by an admin)" for feeds an admin added. A manager can correct the products here (COM-1517).
    - **History:** first seen, severity and score changes, marked known exploited, rejected, product and version changes, and the company's decisions by name.

    Built differently from the task:
    - A link that isn't a web address is left out rather than shown as plain text.
    - Related advisories and government alerts are one list. They aren't grouped by kind.
- id: 01M6G9ZS7QJJDSDVG8EMWXRERC
  author: Steve Vine
  at: 2026-11-03T08:56:35.831182Z
  text: |-
    Pre-UAT (staging, 2026-11-03, E2E Test Company): **Passed**, one cosmetic fix logged.

    I opened CVE-2025-14180 (PHP, NVD), CVE-2026-54118 (SQL Server, Microsoft) and CVE-2025-68686 (FortiOS, CISA known exploited) as E2E Admin A. Top to bottom:
    - **Header:** id, severity and score pill, Exploit published / Known exploited / Versions not stated marks, the dates (including "First seen by Compass"), and Confirm / Not relevant / Raise.
    - **Does it affect us**, as in COM-1520.
    - **Affected products:** a table of product, affected versions, fixed in, and who says so.
    - **The fix:** Microsoft's KB, fixed build and restart per product, and CISA's required action under Mitigations.
    - **Links:** grouped (Patch, Vendor advisory, Exploit, Analysis), each with its domain.
    - **What each source said:** in each source's words, with first-seen dates.
    - **History:** first seen from the source, then the company's decisions with who made them.
    - **Side panels:** Exploitation (known exploited by whom, CISA due date, ransomware use, exploit published, "Likelihood of exploitation in 30 days: 0.70% — higher than 53.1% of CVEs"); the score in plain words ("Reached over the network · no login needed · no user action · low complexity · full impact on availability"), with the vendor's score too; and the type of weakness ("CWE-502 Deserialization of Untrusted Data").
    - **Related:** the month's Microsoft release, and "Raised from this item" (VUL-1, R-32).

    Found: a score with no CVSS version read "9.4 (CVSS )". Fixed in COM-1538.

    Screenshots: ~/compass-uat/sprint-102/COM-1522/
assignee: steve
label:
- feature
priority: high
task_status: done
---
Sprint 102, Security Feed (ADR 0139, COM-1510).

## What people see

Opening an item (CVE-2026-1234, or an advisory) shows the following, top to bottom.

**Header:**
- id, title, severity pill and score;
- Known exploited, Exploit published, Rejected or Updated marks;
- published and updated dates;
- the company status and its actions (Confirm, Not relevant, Raise…; COM-1520 and COM-1525).

**At a glance:**
- **Exploitation:**
  - known exploited, credited to whoever says so (CISA, Microsoft, the vendor);
  - CISA's due date, and ransomware use;
  - exploit published;
  - likelihood of exploitation (EPSS, with its percentile).
- **Score in plain words:** the CVSS vector spelled out, e.g. "Reached over the network · no login needed · no user action · low complexity · full impact on confidentiality, integrity and availability". When sources score it differently, each one's score is shown.
- **Type of weakness:** CWE id and name ("CWE-787 Out-of-bounds write").

**Does it affect us** (when matched): the "Why this matched" panel from COM-1520, listing the systems, our versions, and the affected and fixed versions.

**Affected products:** a table of vendor, product, affected versions, fixed version, and who says so (NVD, the vendor, CISA, Polaris's reading). The vendor's own wording is kept ("FortiOS 7.4.0 through 7.4.5").

**The fix:**
- the vendor's fix: KB article and build (Microsoft), first fixed release (Cisco, Fortinet, Palo Alto);
- workarounds and mitigations, in the vendor's words;
- whether a restart is needed, where stated.

**Links**, grouped as **Patch**, **Vendor advisory**, **Exploit**, **Mitigation**, **Analysis** and **Other**. Each shows its label and **domain** ("msrc.microsoft.com") and opens in a new tab. Compass never fetches them.

**Related:** vendor advisories that cover this CVE; government alerts that mention it; vulnerabilities and risks raised from it in this company (COM-1525).

**What each source said:** one panel per source, in that source's words. Each is marked as from the source and never editable. Admin-added feeds are labelled "added by an admin".

**History:** first seen; each change (score, versions, known-exploited, rejected), with the date and source; and the company's decisions, by whom.

## Notes (technical)

- `GET /security-feed/items/{id}` returns the merged view plus per-source panels. Source text is returned under `from_the_source` (the ADR 0099/0129 pattern) and rendered as plain text. Use Mantine `Anchor` with `target=_blank rel="noopener noreferrer nofollow"` and show `new URL(href).hostname`. Allow only http(s) links; anything else is shown as text, unlinked.
- CVSS v3.1 and v4.0 vector to plain words: a small mapping table in the frontend, unit-tested against known vectors.
- The item page is the breadcrumb target from the feed, from a vulnerability and from Actions.

**Chain:** on the chain (API).

**Done when:** on staging:
- a known-exploited Microsoft CVE shows CISA's and Microsoft's exploited marks, the vector in plain words, the CWE, the KB and fixed build per product, grouped links with domains, and NVD's and Microsoft's panels;
- links open in a new tab;
- the history shows when it was added to the known-exploited list.