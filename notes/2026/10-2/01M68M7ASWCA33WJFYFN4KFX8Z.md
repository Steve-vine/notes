---
id: 01M68M7ASWCA33WJFYFN4KFX8Z
created: 2026-10-31T09:21:33.500785Z
updated: 2026-10-31T11:30:47.313712Z
type: task
title: Repeating reviews are always on their owner's list with the next review date — control assessments, assets, vendors, policies, Q&A answers and risk assessments — emailing only as the date nears
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1478
sprint: scpaa6p
blocked_by:
- 01M68M5RS2BS736HK2PFS7R8B8
assignee: steve
label:
- improvement
priority: medium
task_status: active
---
Sprint 100, Actions (ADR 0137 rule 8; Steve 2026-10-31: "always on the list", with Upcoming only hiding the far ones).

## What people see

Each of these always has one **Review** action for its owner, due on its next review date. It shows as *Later* until the horizon and is emailed only inside its window:

| Type | Action | Today it appears… |
|---|---|---|
| Control assessment | Review | when the review is due |
| Asset (system, data asset, software) | Review ("Confirm accurate") | when the review date arrives |
| Vendor | Review | when the review is due; tier rise is a separate row |
| Policy / standard / procedure / runbook | Review | inside the lead window |
| Q&A answer | Review | 30 days before |
| Risk assessment (current, by kind) | Start the next one | 60 days before Next due |

- Risks are in COM-1476.
- A thing with **no review date** gets one at the type's default interval, or the action says "Set a review date". Decide which in COM-1468.
- A vendor whose tier rose replaces its scheduled Review with **Review (tier rose)**, due now, rather than adding a second row.
- Things with no owner go to the type's default owner (COM-1471).

## Notes (technical)

- Drop the cutoff in `_assessment_reviews`, `inventory._review_due`, `vendors` review due, `library` content review, `ddq` library review and `risk_assessments` due. The window moves to COM-1473.
- Volume: this adds a row for every owned asset, vendor and control. Check the Actions query time on staging, and the digest run, with every company in.

**Chain:** on the chain. Blocked by COM-1473.

**Done when:** on staging, an E2E account that owns an asset and a vendor in E2E Test Company sees both reviews, under Later with Upcoming only off. Neither is mailed until inside its window.