---
id: 01M87NQ93FMZC3DGEBQWVYQYQH
created: 2026-11-24T20:59:53.839333Z
updated: 2026-11-24T22:17:19.470858Z
type: task
title: Risks link to the business services they threaten
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2153
sprint: ss3ttbb
blocked_by:
- 01M87NPDZVSSZPHJ5EJ6KND9G9
assignee: steve
label:
- feature
priority: medium
task_status: active
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