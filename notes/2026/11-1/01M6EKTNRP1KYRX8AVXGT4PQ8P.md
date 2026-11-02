---
id: 01M6EKTNRP1KYRX8AVXGT4PQ8P
created: 2026-11-02T17:10:05.334375Z
updated: 2026-11-02T17:10:05.334375Z
type: task
title: 'The item page — everything known about one issue in one place: affected and fixed versions per product, the score in plain words, exploitation status, the vendor''s fix and workarounds, links grouped by kind, what each source said, and the item''s history'
label: feature
task_status: todo
assignee: steve
priority: high
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1522
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