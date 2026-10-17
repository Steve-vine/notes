---
id: 01M52GZ2HD0PWSP44EA1DCW7NA
created: 2026-10-16T14:13:28.749576Z
updated: 2026-10-16T22:31:40.199535Z
type: task
title: The assistant can run a vendor's reviews, risks and lifecycle — record a review and its actions, link or raise a risk, and take a vendor from active to offboarded
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1036
sprint: shcfcmf
blocked_by:
- 01M52GY5TNNT0MAM8EZMW8HSJW
comments:
- id: 01M53DF82R7YWWQ58ZM4SFFCD5
  author: Steve Vine
  at: 2026-10-16T22:31:38.840545Z
  text: |-
    Done — merged to main (PR #1015, plus fix #1016). Goes to staging with the rest of sprints 73 and 74.

    What the assistant can now do, for a named company:
    - Read a vendor's reviews (newest first: when, kind, outcome, the compliance decided, findings, reviewer) with each review's actions, its compliance now and when the next review is due; and the risks linked to it.
    - Record a review — this is how compliance moves, as on screen — and the reply says what the compliance was and is, and the new next-review date.
    - Add, change (owner, due date, done) and remove review actions. An action goes on the latest review unless you name the review's date.
    - Link or unlink a risk from the register, or raise a new one from the vendor (title, likelihood, impact; same as the Raise button).
    - Make a vendor active or dormant; an admin can reinstate an offboarded one.
    - Offboard against the checklist (data returned/deleted, access revoked, contracts closed, notes) — refused unless all three are confirmed, as on screen.
    - Delete a vendor, and (admins only) permanently delete an offboarded one.
    Unlinking, removing an action, offboarding and both deletes ask first.

    Something you should know: PR #1015 went into main with one test failing. That test was from sprint 70 and checked that no risk tool mentions vendors, which this sprint's ADR deliberately changed. I fixed it in #1016 within 20 minutes, and nothing was deployed in between. The cause on my side was that I merged without reading the result. The cause on the repo side is that main no longer has branch protection: since the move to the RootCause-IT org, GitHub says protection needs a paid plan, so nothing stops a red PR from merging. I now check every result before merging. Turning protection back on is your call — it needs either GitHub Team for the org or a public repo.

    Found while building, for you to decide (not changed):
    - The vendor page shows the "Raise risk" button to people who can record assessments, but saving a risk needs "manage risks". Someone with only the first sees the button and gets refused. The assistant follows the server: it offers "raise a risk" to people who can manage risks (and the vendor register).

    My calls: the raised risk gets the same defaults as the screen's button (category Security, status Open, residual score the same as the starting score).
assignee: steve
label:
- feature
priority: medium
task_status: review
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