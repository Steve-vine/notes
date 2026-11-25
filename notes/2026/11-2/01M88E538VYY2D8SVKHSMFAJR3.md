---
id: 01M88E538VYY2D8SVKHSMFAJR3
created: 2026-11-25T04:06:52.443151Z
updated: 2026-11-25T04:06:52.443151Z
type: task
title: 'Business services touch-ups: BIA submit wording and PDF left-out row, a document''s empty services card, and the vendor''s criticality tile refreshing'
task_status: active
assignee: steve
label: bug
priority: low
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2162
---
Sprint "Business Services". Found in the round 2 pre-UAT on staging a63d542b2 (25 Nov 2026).

## What people see after the fix
1. **BIA Submit dialog** (COM-2156): its checklist talks about services, not functions ("Every business service is assessed or left out with a reason…"). Items that don't apply to a left-out service (e.g. an owner) aren't asked of it. Screenshot `~/compass-uat/ss3ttbb/COM-2156/04-submit-dialog-wording.png`.
2. **BIA PDF** (COM-2156): a left-out service's row keeps its columns. Type shows Internal or Client facing, and "Left out" plus the reason appear in their own place, not under "Maximum tolerable period of disruption". See `09-bia-RAS-5.pdf` page 3.
3. **A document's empty Business services card** (COM-2155) reads like "None of E2E Test Company's business services are linked to this document", not "No business services of E2E Test Company yet." (the company does have services).
4. **The vendor's Criticality tile** (vendor page header) updates as soon as an engagement is added, edited or ended, as the Blast radius card already does, instead of only after a reload. This is probably older than this sprint, but it was seen while testing COM-2152.

## Done when
- Each of the four reads or updates as above, with Vitest for 1, 3 and 4 and a backend test for the PDF row in 2.

Independent: no migration or API change expected.