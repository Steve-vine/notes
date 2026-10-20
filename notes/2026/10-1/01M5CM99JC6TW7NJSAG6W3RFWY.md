---
id: 01M5CM99JC6TW7NJSAG6W3RFWY
created: 2026-10-20T12:23:53.676596Z
updated: 2026-10-20T16:00:35.902857Z
type: task
title: A vendor review shows as Evidence of operation on the supplier-management controls
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1153
assignee: steve
label:
- follow_up
priority: low
task_status: active
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