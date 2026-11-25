---
id: 01M87NQ93FMZC3DGEBQWVYQYQH
created: 2026-11-24T20:59:53.839333Z
updated: 2026-11-25T04:06:20.069685Z
type: task
title: Risks link to the business services they threaten
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2153
sprint: ss3ttbb
blocked_by:
- 01M87NPDZVSSZPHJ5EJ6KND9G9
comments:
- id: 01M883R64ER2X1N3XKARYBYWZW
  author: Steve Vine
  at: 2026-11-25T01:05:03.630424Z
  text: |-
    Built and merged to main: PR #2148 (edc93636f), migration 0917_risk_business_services.

    What people see:
    - A risk's page has a Business services card: link the risk to one or more of the company's active services, and unlink with ×. A service retired after linking stays, marked Retired; it can be unlinked but not newly linked.
    - A service's page has a Risks card: every linked risk, newest first, with status and residual score, and an "Open risks only" switch.
    - The risk register has a Business service filter, applied by the server. Retired services are listed too, marked, so their risks can still be found.
    - Linking and unlinking show on both the risk's and the service's History ("Linked RSK-14 to business service SVC-3 · TAS").
    - A service a risk links to counts as in use ("1 risk"): it can be retired, not deleted.
    - Polaris links and unlinks, filters the register by service ("which risks threaten LiveChat?"), and lists a risk's services.

    Tested: backend integration for linking both ways, the register filter, unlink and relink, both histories, the delete guard, retired and other-company rules, permissions, migration up → down → up, and the Polaris tools. Vitest covers both cards, the History line and the filter. CI green first time.

    For Steve to decide:
    1. "Open risks only" shows only status Open, hiding Treated and Accepted as well as Closed. The alternative is to hide only Closed.
    2. Linking needs the right to manage risks. Reading needs the right to view risks. The register filter and picker show only to people who can view the Inventory.

    Not checked yet: seen in a browser (staging pre-UAT).
- id: 01M88E43N5WNS141KP60J1Z4RV
  author: Steve Vine
  at: 2026-11-25T04:06:20.069494Z
  text: |-
    Pre-UAT on staging a63d542b2: **Passed**.
    - RSK-144 linked to TAS. TAS's Risks card lists it (residual 9), and the register's TAS filter finds only it.
    - Payroll linked then retired: it shows marked RETIRED and isn't offered again. Unlinking clears both. History lines on both.
    - Couldn't see "Open risks only" hide anything, because every E2E risk is Open.
    Screenshots: ~/compass-uat/ss3ttbb/COM-2153/
assignee: steve
label:
- feature
priority: medium
task_status: review
---
Sprint "Business Services". Follows the Business services page.

## What people see
- **A risk's page** has a **Business services** card: link the risk to one or more of the company's active services, and unlink.
- **A service's page** has a **Risks** card: every risk linked to it, with score and status. It can be filtered to open risks.
- **The risk register** can be filtered by business service.
- Linking and unlinking show on both records' history.
- Polaris can link and unlink, and answer "which risks threaten LiveChat?".

## Done when
- In E2E Test Company: link a risk to TAS. TAS's page lists it, and the register's TAS filter finds it.
- Unlinking removes it from both.
- A retired service stays on risks already linked (marked), but can't be newly linked.

## For the build
- A dedicated link table shaped like `risk_gap_links` (real FKs both sides, RESTRICT on the risk, actor fields, unique on the pair, audited), not the polymorphic `inventory_risk_links`.
- Routes `/risks/{id}/services` and `/business-services/{id}/risks`. Register filter param.
- Polaris in the posture area (where the risk tools are).
- **On the chain**: migration + API.