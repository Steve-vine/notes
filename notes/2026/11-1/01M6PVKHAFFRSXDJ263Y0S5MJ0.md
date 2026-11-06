---
id: 01M6PVKHAFFRSXDJ263Y0S5MJ0
created: 2026-11-05T21:59:55.471852Z
updated: 2026-11-06T00:23:10.699777Z
type: task
title: Pass/fail rules on collected checks — Polaris drafts a rule in plain words, a person approves it, and from then on each capture passes or fails, raising and closing a "Raised by Compass check" gap exactly as built-in checks do
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1606
sprint: s5khbev
blocked_by:
- 01M6PVK2TV9N6RS1EFT7N737KX
- 01M6PVJJKPK5EVC8BBG9HHXR5E
assignee: steve
label:
- feature
priority: high
task_status: active
---
Sprint "Checks - Coverage and batch work" (COM-1605). Builds on the previous sprint's collected checks (COM-1601–COM-1604).

## What people see

- **A collected check can gain a rule.**
  - When Polaris designs a check, it may propose one.
  - On a live check, **Ask Polaris for a rule** does the same.
  - A rule reads as a sentence, "Every policy that targets All users requires MFA", with what counts as an item ("a policy"), so the result reads "Failing: 2 of 14 policies".
- **Rules are approved separately from the check** (Record assessments). Before approving, the reviewer sees the rule applied to the latest capture: what would pass, and what would fail, by name. A check with no approved rule stays **Collecting**.
- **Once approved, it behaves like a built-in check** (ADR 0132):
  - Passing, Failing (with which items) or Can't tell (capture Broken or Held).
  - A failure raises a gap "Raised by Compass check: <name>" on the control, which Compass closes when it passes, with the same reopen and cancel rules and the same "no gap where unassessed / out of scope / excepted".
  - It never changes the control's status or maturity.
- **History, What changed, audit packs and the SoA** treat it like any other check: time passing, changes of state, gaps raised and closed.
- **A person can edit a rule by hand** (Advanced), which needs re-approval. Re-create (COM-1604) proposes a new rule with a new check.

## Notes (technical)

- Don't let Polaris write code. A rule is a small, safe expression over the capture's items:
  - **item selector** (a JSON path);
  - **conditions**: field equals / contains / in / exists / count ≤ n, with all / any / none, and "where" filters;
  - **mode**: every item must / no item may / at most N items may.
  - Evaluated deterministically in Python, and validated against the capture's approved shape on approval.
- Plug into `core/checks/`: data-defined checks become a second source joined in `_declared()` (today code-only), keyed `collected:<id>`. That way `engine.run_check` (lock, gap raise / close / reopen, Compass as actor), `view.py` and `checks/evidence.py` work unchanged. `Check.control_keys` comes from the collected check's control key. `items_permission`: Record assessments, or the module's own where items are people.
- Run the rule right after each capture, not on the hourly engine pass. A held capture means Can't tell, not a pass.

**Chain:** on the chain (migration and API).

**Done when:** on staging, in E2E Test Company, a collected Conditional Access check gets an approved rule. A policy that breaks it makes the check fail and raises a gap on the assessed control; fixing it closes the gap at the next capture. The same check without a rule only collects.