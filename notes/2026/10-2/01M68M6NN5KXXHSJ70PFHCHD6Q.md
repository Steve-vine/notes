---
id: 01M68M6NN5KXXHSJ70PFHCHD6Q
created: 2026-10-31T09:21:11.845209Z
updated: 2026-10-31T12:21:31.062284Z
type: task
title: A risk with no treatment plan is an action for its owner — "Risk · Create a treatment plan", due on the risk's own Treat by date — and once treated, its next review is always on their list
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1476
sprint: scpaa6p
blocked_by:
- 01M68M4TR5X3N0A30R9F8XGY5V
- 01M68M5RS2BS736HK2PFS7R8B8
comments:
- id: 01M68YGV5850KYJT2V960RVPHQ
  author: Steve Vine
  at: 2026-10-31T12:21:30.920024Z
  text: |-
    Done: PR #1499 merged (40cc6000, migration 0751).

    - **An open risk with nothing treating it** shows on its owner's Actions as Risk · Create a treatment plan, due on its new **Treat by** date. Adding a treatment replaces it with the risk's Review, which is now always on the list (one row per risk) and emailed from 30 days before.
    - **Treat by:**
      - It fills itself in as raised + 14 days. It shows on the risk page and as a column in the Risks register while the risk is untreated.
      - Anyone who can edit the risk can move it, but not clear it. Changes are in the risk's history.
      - It resets to today + 14 if the risk becomes untreated again: the last open treatment is cancelled, done or removed, or an acceptance runs out.
      - Polaris can read and set it. Risks raised from an approved risk assessment get one too.
    - **Existing untreated risks,** including R-6, got Treat by = release day (31 Oct) + 14 = 14 Nov, so none open as overdue.
    - **Might surprise you:** completing a risk's only treatment while leaving the risk Open puts it back to "Create a treatment plan". That follows the spec. To finish, mark the risk Treated or Accepted.

    To test on staging, in E2E Test Company:
    1. Raise a risk with an E2E owner and no treatment. It should show Treat by = today + 14 and "Risk · Create a treatment plan" due that day for the owner.
    2. Change Treat by: the action's due date should follow.
    3. Add a treatment: the risk's Review should show under Later.
    4. Check R-6 in Test Company shows Treat by 14 Nov, not overdue.
assignee: steve
label:
- feature
priority: high
task_status: review
---
Sprint 100, Actions. Raised by Steve on 2026-10-30: R-6 in Test Company is open, over appetite and untreated, and is on nobody's list until Sept 2027.

## What people see

A risk always has one action, at its current step:

1. **Open with no live treatment plan:** "R-6 · Policy is out of date", **Risk · Create a treatment plan**, for the risk's owner, due on the risk's **Treat by** date (below). It goes when a treatment plan is added.
2. **Treated or accepted:** **Risk · Review**, due on the risk's next review date, for its owner. It's always on the list (*Later* until it gets close) and is emailed from 30 days before.
3. **Closed:** no action.

Each treatment plan keeps its own action (**Treatment · Complete**, or **Approve** for an acceptance) for the treatment's owner. A treatment is a different thing from its risk, so both can show.

## Treat by: a new date on the risk (Steve, 2026-10-31)

- Every risk gets a **Treat by** date, beside its review dates on the risk's page and in the Risks register.
- **It fills itself in** as the day the risk was raised plus N days. N is set on Admin ▸ Actions for "Risk · Create a treatment plan" (I'd start at 14). The risk's owner, or anyone who can edit the risk, can change it, for example when a treatment will genuinely take longer to work out. The change is in the risk's history.
- It matters only while the risk has no live treatment, so it's shown only then. Once treated, the date is kept but is no longer shown as a target.
- **When a risk becomes untreated again** (an acceptance runs out and the risk goes back to Open, or its last treatment is cancelled), Treat by resets to that day plus N, unless someone sets a different date.
- Polaris can read and set it (`posture_get_risk` / `posture_update_risk`).

## Existing risks (Steve, 2026-10-31)

Risks that are already open and untreated when this ships get **Treat by = release day + N**, not raised + N, so old risks don't all turn overdue on day one. Risks raised after release count from the day they were raised.

## Notes (technical)

- Migration: `risks.treat_by` (date, nullable). Backfill open untreated risks to the release date + the type's `due_after_days`; leave the rest null and set it when a risk becomes untreated. Keep the migration data-only and idempotent, and test the backfill on a populated DB: CI only migrates an empty one.
- Set it on create (raised + N) and on the transitions back to untreated (`lifecycle` expiry of an acceptance, treatment cancelled). Revisions and history record changes.
- New source in `core/actions/company.py`, due on `treat_by`. `_risk_reviews` drops its 30-day cutoff, and the window comes from COM-1473.
- "Live treatment" means the same as Polaris's `treatment=untreated` filter. Reuse that predicate.
- The API gains `treat_by` on risk read/update. Regenerate schema.d.ts and update the MCP risk tools.

**Chain:** on the chain (migration + new action type + API). Blocked by COM-1470 and COM-1473.

**Done when:** on staging, in E2E Test Company:
- a new risk raised with an E2E owner and no treatment shows Treat by = today + 14, and "Risk · Create a treatment plan" due that day for that owner;
- changing Treat by moves the action's due date;
- adding a treatment replaces the action with the treatment's, and the risk's Review shows under Later;
- R-6 in Test Company (raised before release) shows Treat by = release day + 14, not overdue.