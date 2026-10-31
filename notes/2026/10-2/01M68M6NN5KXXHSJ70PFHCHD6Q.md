---
id: 01M68M6NN5KXXHSJ70PFHCHD6Q
created: 2026-10-31T09:21:11.845209Z
updated: 2026-10-31T09:22:42.769999Z
type: task
title: A risk with no treatment plan is an action for its owner — "Risk · Create a treatment plan" — and once treated, its next review is always on their list
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1476
sprint: scpaa6p
assignee: steve
label:
- feature
priority: high
task_status: todo
---
Sprint 100, Actions. Raised by Steve on 2026-10-30: R-6 in Test Company is open, over appetite and untreated, and is on nobody's list until Sept 2027.

## What people see

A risk always has one action, at its current step:

1. **Open with no live treatment plan:** "R-6 · Policy is out of date", **Risk · Create a treatment plan**, for the risk's owner. It's due a set number of days after the risk was raised (Admin ▸ Actions; I'd start at 14). It goes when a treatment plan is added.
2. **Treated or accepted:** **Risk · Review**, due on the risk's next review date, for its owner. It's always on the list (*Later* until it gets close) and is emailed from 30 days before.
3. **Closed:** no action.

Each treatment plan keeps its own action (**Treatment · Complete**, or **Approve** for an acceptance) for the treatment's owner. A treatment is a different thing from its risk, so both can show.

Existing untreated risks get the action the day this ships, with a due date counted from when they were raised, so old ones are overdue at once. Say so in the release note.

## Notes (technical)

- New source in `core/actions/company.py`. `_risk_reviews` drops its 30-day cutoff, and the window comes from COM-1473.
- "Live treatment" means the same as Polaris's `treatment=untreated` filter. Reuse that predicate.

**Chain:** on the chain (new action type). Blocked by COM-1470 and COM-1473.

**Done when:** on staging, in E2E Test Company, a new risk raised with an E2E owner and no treatment shows "Risk · Create a treatment plan" for that owner. Adding a treatment replaces it with the treatment's action, and the risk's Review shows under Later with its review date.