---
id: 01M88E538VYY2D8SVKHSMFAJR3
created: 2026-11-25T04:06:52.443151Z
updated: 2026-11-25T09:17:49.971076Z
type: task
title: 'Business services touch-ups: BIA submit wording and PDF left-out row, a document''s empty services card, and the vendor''s criticality tile refreshing'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2162
sprint: ss3ttbb
comments:
- id: 01M88FZAKPYYVPPB4SWBPRBZ4C
  author: Steve Vine
  at: 2026-11-25T04:38:40.502002Z
  text: |-
    Built and merged to main: PR #2157 (ce762f6d2). No migration or API change.

    What people see:
    1. Submitting a services BIA: the dialog reads "Every business service is assessed or left out with a reason, and each one assessed has a full impact over time, a tolerable period and its RTO and RPO". Nothing is asked of a left-out service, owner included. An older functions-only draft keeps the function wording. It matches what Submit checks.
    2. BIA PDF: the Business services table lists only assessed services, with columns intact. Left-out services get their own table, "Business services left out" (Service, Type, Reason). Only assessed services get an impact section.
    3. A document's empty card reads "None of <company>'s business services are linked to this document." A service's empty Content card reads "No documents are linked to this business service yet."
    4. Adding, editing or ending an engagement refreshes the vendor header's Criticality, Risk tier and Annual spend tiles at once, plus the register and its counts.

    Tested: a backend test builds the PDF content for one assessed and one left-out service. Vitest covers both Submit wordings, both empty cards, and the refresh after saving an engagement. CI green.

    For Steve to decide: in the PDF, left-out services are in a separate table under the assessed ones (on screen they share one table with a LEFT OUT tag).

    Not checked yet: in a browser, and a rendered PDF (recheck on staging next).
- id: 01M88J4YQ5NPASZXSB32PSHY5X
  author: Steve Vine
  at: 2026-11-25T05:16:42.085699Z
  text: |-
    Pre-UAT recheck on staging 82c0bf7e4: **Passed**.
    - Submit on a services BIA (draft RAS-6) reads "Every business service is assessed or left out with a reason, and each one assessed has a full impact over time, a tolerable period and its RTO and RPO." Nothing is asked of left-out Payroll, and the "not ready" list is worded by service. RAS-6 was then withdrawn (not submitted).
    - PDF: the RAS-6 draft's PDF has TAS alone in Business services, and a separate "Business services left out" table (Service, Type, Reason) with Payroll. RAS-5's PDF still shows the old layout, because an approved BIA keeps the file made at approval (before this fix). That's expected.
    - A document with no services reads "None of E2E Test Company's business services are linked to this document."
    - Vendor tiles: adding a High engagement changed Criticality and Risk tier to High at once; ending it set them back to Low, with no reload.
    - Cosmetic only: the left-out table's Reason cell repeats "Left out:".
    Screenshots: ~/compass-uat/ss3ttbb/COM-2162/recheck-*
assignee: steve
label:
- bug
priority: low
task_status: done
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