---
id: 01M87NQP34MRRM0CSSGVB4Z7T6
created: 2026-11-24T21:00:07.140847Z
updated: 2026-11-25T09:17:49.942355Z
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
- id: 01M887RYQCS6SCYJ3R9RQA3T3B
  author: Steve Vine
  at: 2026-11-25T02:15:23.116251Z
  text: |-
    Built and merged to main: PR #2152 (718872136), migration 0919_content_business_services.

    What people see:
    - Every document page (policy, standard, procedure, runbook, flowchart) has a Business services card for the company in the top bar: only that company's linked services, retired ones marked. People who manage the inventory link and unlink there.
    - Switching company shows none of another company's links.
    - A service's page has a Content card: each linked document with type, version (or Draft) and next review, with Link a document and unlink.
    - Linking doesn't change, publish or review the document; drafts can be linked.
    - Each link and unlink is a line in the service's History. A service with documents can be retired, not deleted. A deleted document comes off every service.
    - Reading needs View inventory; linking needs Manage the inventory register (as agreed).
    - Polaris answers "what's our documentation for TAS?" and links and unlinks.

    Tested: backend integration for both sides, per-company isolation, the document unchanged, History, retired refused, the delete guard, deleted documents dropped, permissions, migration up → down → up, and Polaris. Vitest covers both cards. CI green.

    For Steve to decide:
    1. Documents can also be linked from the service's page (as runbooks can from a system).
    2. A retired service can't be newly linked from either side, but can be unlinked.
    3. The activity lines go on the service's History, not the document's.

    Not checked yet: seen in a browser (staging pre-UAT). The link table isn't in the backup catalogue, as with runbook links today.
- id: 01M88E48SA5Y40V3MZ5DVD4SGG
  author: Steve Vine
  at: 2026-11-25T04:06:25.322654Z
  text: |-
    Pre-UAT on staging a63d542b2: **Passed**.
    - A procedure linked from TAS's Content card shows on TAS (Procedure, v1, next review), and on the document's card as "SVC-1 · TAS".
    - With Demo selected, the card shows none of E2E's links (Demo not changed).
    - Unlinking from the document side clears both.
    - The document's record is byte-identical before and after linking.
    - Found (copy, low): the empty card reads "No business services of E2E Test Company yet." even though the company has services. In the fix-forward task.
    Screenshots: ~/compass-uat/ss3ttbb/COM-2155/
assignee: steve
label:
- feature
priority: medium
task_status: done
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