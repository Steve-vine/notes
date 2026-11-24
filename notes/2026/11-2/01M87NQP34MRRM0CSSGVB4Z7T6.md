---
id: 01M87NQP34MRRM0CSSGVB4Z7T6
created: 2026-11-24T21:00:07.140847Z
updated: 2026-11-24T23:10:07.483275Z
type: task
title: 'Content links to a company''s business services: policies, procedures and runbooks for a service'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2155
sprint: ss3ttbb
blocked_by:
- 01M87NPDZVSSZPHJ5EJ6KND9G9
comments:
- id: 01M87PQ5TDM9MR5NXE2KBPQRBJ
  author: Steve Vine
  at: 2026-11-24T21:17:19.053365Z
  text: 'Steve agreed (24 Nov 2026): reading a document''s service links needs View inventory, and linking or unlinking needs Manage the inventory register, as with runbooks. Content editors don''t get it separately.'
assignee: steve
label:
- feature
priority: medium
task_status: active
---
Sprint "Business Services". Follows the Business services page.

## What people see
- **A document's page** (any type: policy, standard, procedure, runbook, flowchart) has a **Business services** card for the company being viewed. It links the document to one or more of that company's services. Content is shared by every company, so each company sees and sets only its own links, as with a runbook's "systems it recovers".
- **A service's page** has a **Content** card: every document linked to it, with type, version and review status.
- Linking doesn't change, publish or review the document, and can be done on a draft or a published one.
- Linking and unlinking are in the activity log.
- Polaris can link and unlink, and answer "what's our documentation for TAS?".

## Done when
- In E2E Test Company: link a procedure to TAS. TAS's page lists it, and the procedure's page shows TAS for E2E Test Company.
- Switch to another company: the procedure shows none of E2E Test Company's links.
- Unlinking removes it from both.

## For the build
- A link table copying `runbook_systems` (content_item_id CASCADE, business_service_id CASCADE, unique on the pair, labels for History), scoped through the service's company. Any content type.
- Card beside `RecoversCard` on ContentDetailPage.
- Reads need View inventory and writes need Manage the inventory register, as runbook links do. Confirm that suits content editors, or allow Content editors too.
- **On the chain**: migration + API.