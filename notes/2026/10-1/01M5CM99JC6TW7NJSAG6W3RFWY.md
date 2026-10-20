---
id: 01M5CM99JC6TW7NJSAG6W3RFWY
created: 2026-10-20T12:23:53.676596Z
updated: 2026-10-20T18:09:26.861724Z
type: task
title: A vendor review shows as Evidence of operation on the supplier-management controls
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1153
comments:
- id: 01M5D2T3E5GBRMMDTK031AGTEA
  author: Steve Vine
  at: 2026-10-20T16:37:44.517421Z
  text: |-
    Merged in PR #1158 at 16:37 UTC on 2026-10-20 (main 21024ad0). Not yet on staging.

    **What changed:** on a company's assessment of VEM.3, VEM.5 and VEM.12, Evidence of operation has a **Vendor reviews** line, one per company:
    - Beside the title: how many live vendors the company has.
    - **Last done:** the most recent review on any live vendor: when, by whom, and which vendor, kind and outcome (e.g. "Acme Ltd: annual review, findings raised"). The line opens that vendor, where the review sits.
    - **Next due:** the earliest review still to come, and which vendor.
    - **Warnings:** live vendors overdue for review, and live vendors never reviewed.
    - A company with no live vendors shows "No live vendors", with no warning.
    - Only people who can view vendors see it. It only shows: status, maturity and compliance don't change.

    **My calls:**
    - **Live means active and not deleted.** Requested, dormant and offboarded vendors don't count, don't raise warnings, and their reviews never count as "last done".
    - **Overdue** uses the same next-review date as the register, Actions and the nightly cadence expiry. A vendor is overdue from the day its review falls due, which is when it moves to Under review.
    - **Next due** is the earliest date still to come. Vendors already past due appear in the overdue warning, not as a next-due date in the past.
    - **Never reviewed is a warning too:** VEM.5 says *all* vendors are assessed.
    - As in the task: fixed controls, one line per company, and questionnaires count as part of a review.

    **Checks:**
    - New integration tests:
      - each control key matches the ref shown on screen;
      - a full line, with overdue and never-reviewed vendors and non-live vendors ignored;
      - a review falling due today counts as overdue;
      - a company with no live vendors;
      - the permission gate, tested through the API.
    - The attestation, incident, data subject request, SAP and assistant evidence tests pass locally.
    - ruff and mypy are clean. No migration, no API change, no frontend change.
    - **CI:** run 39454612429 took 28.5 min, with backend-test at 28.0. The frontend job was skipped (backend only).

    **On staging:** open a company's assessment of VEM.3 and check the line shows its last vendor review and the next due date.
assignee: steve
label:
- follow_up
priority: low
task_status: done
---
Split from COM-1060 (2026-10-20). Builds on COM-1051's Evidence of operation registry (ADR 0115 §10).

## Why

Recording a vendor review is how a company proves it monitors its suppliers, but the supplier controls' assessments don't show it. Today an assessor has to open Vendor Management to find out.

## What people see

On a company's assessment of these controls, Evidence of operation gains a **Vendor reviews** line:
- **VEM.3** (`VEM.4`): vendor service delivery and compliance are reviewed;
- **VEM.5** (`VEM.6`): all vendors are assessed;
- **VEM.12** (`s42.VEM.7`): supplier performance is monitored through the relationship.

The line shows:
- **Last done:** the most recent review recorded on any of the company's live vendors, by whom, its outcome, and a link to the review.
- **Next due:** the earliest date a live vendor's review cadence runs out.
- **Warning:** how many live vendors are overdue for review (their assurance is "under review" because the cadence expired). Like every source, it only shows. It never changes status, maturity or compliance.
- A company with no live vendors shows "No live vendors". That isn't a failure.

The line is visible to people who can see the assessment and can view vendors. Others don't see it at all.

## My calls (to confirm)

- **Fixed controls:** the three above, the same for every company, as Incidents, Attestations and DSR do. They are not set per vendor or per setting.
- **One line per company, not one per vendor.** A register of 100 vendors would otherwise bury the card.
- **Questionnaires count as part of a review,** not as a separate line.

## Notes (technical)

- New source module like `core/incident_evidence_of_operation.py`, with `CONTROL_EVIDENCE` keyed by control **key**, not ref (memory control-key-vs-ref). Register it in `SOURCES`.
- The review cadence by tier and its expiry are already computed for compliance status (`VendorComplianceStatus.under_review`); reuse that, don't re-derive it.
- Tests: a company with reviews, one with an overdue vendor, one with none; and a reader without vendor view sees nothing.

**Done when:** on staging, a company's assessment of VEM.3 shows its last vendor review and the next due date.