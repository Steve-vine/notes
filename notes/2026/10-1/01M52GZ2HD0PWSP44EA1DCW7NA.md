---
id: 01M52GZ2HD0PWSP44EA1DCW7NA
created: 2026-10-16T14:13:28.749576Z
updated: 2026-10-16T14:13:33.460566Z
type: task
title: The assistant can run a vendor's reviews, risks and lifecycle — record a review and its actions, link or raise a risk, and take a vendor from active to offboarded
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1036
sprint: shcfcmf
assignee: steve
label:
- feature
priority: medium
task_status: todo
---
Sprint 73, MCP - Vendor Management (ADR in COM-1033). Built on COM-1034.

## What people can ask of it

- **Read:**
  - a vendor's **reviews**: when, what kind, the outcome, compliance and findings, and each review's actions (owner, due date, status);
  - when the next review is due;
  - the **risks** linked to the vendor.
- **Write (whatever the person's role allows on screen):**
  - **record a review.** Compliance is earned by review, so this is how a vendor becomes compliant.
  - add, edit or remove a review's actions;
  - **link an existing risk** to the vendor, or unlink one;
  - **raise a new risk** from the vendor. It lands in the company's risk register, as on screen. This needs the Posture permissions too.
  - **lifecycle:**
    - mark the vendor active or dormant;
    - **offboard** it, with the checklist: data returned or deleted, access revoked, contracts closed, notes;
    - reinstate an offboarded vendor (admins);
    - delete it;
    - **delete it permanently** (admins, offboarded vendors only, as on screen).
- **Example:** "Record this year's review of Acme: satisfactory, compliant, one finding — their pen test is overdue. Add an action for Sam due end of next month." Or: "we've stopped using OldCRM — offboard it, data deleted, access revoked, contract closed."

## Notes (technical)

- Wraps `vendors.py`:
  - reviews GET/POST and `reviews/{r}/actions` POST/PATCH/DELETE, plus `actions` GET;
  - risks GET/POST/DELETE;
  - offboard; the lifecycle fields on PATCH (reinstating is admin-only inside PATCH);
  - DELETE and purge.
- Raising a risk: confirm which route the vendor page's "Raise risk" uses, and its permission (`posture.record_assessments` on screen). Declare both permissions. Risks resolve through `find_risk`.
- Unlink, delete, the review-action remove, and purge are `destructive`. Purge's description says it can't be undone.
- New module `tools/vendors_reviews.py`.
- Tests:
  - purge is refused for a non-admin, or for a vendor that isn't offboarded;
  - offboard records the checklist;
  - a review is recorded via assistant;
  - raise-risk is hidden without the Posture grant.

**Done when:** on staging, the assistant records a review with an action, and the vendor's compliance and its next review date update on the page.