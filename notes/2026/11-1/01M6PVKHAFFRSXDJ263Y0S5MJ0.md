---
id: 01M6PVKHAFFRSXDJ263Y0S5MJ0
created: 2026-11-05T21:59:55.471852Z
updated: 2026-11-06T11:57:13.908556Z
type: task
title: Pass/fail rules on collected checks — Polaris drafts a rule in plain words, a person approves it, and from then on each capture passes or fails, raising and closing a "Raised by Compass check" gap exactly as built-in checks do
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1606
sprint: s5khbev
blocked_by:
- 01M6PVK2TV9N6RS1EFT7N737KX
- 01M6PVJJKPK5EVC8BBG9HHXR5E
comments:
- id: 01M6Q9SA9CZX6MEWQFAGS4FPN6
  author: Steve Vine
  at: 2026-11-06T02:07:44.940349Z
  text: |-
    Done — merged to main (PR #1622).

    What's there
    - A collected check can have a pass/fail rule. With a rule, each capture passes or fails, and a failure raises a gap on the control, like a built-in check (and closes it when it passes again). It never changes the control's status.
    - "Ask Polaris for a rule" drafts one in a plain sentence (for example "every user has MFA registered"). Before anyone approves it, a preview runs it against the newest capture and shows how many items pass or fail, with examples.
    - Approving the rule is a separate step from approving the check, and it's recorded with who and when.
    - Advanced: a rule can be written or edited by hand. It is tried on the newest capture before it can be saved, and it can be removed.
    - Rules are data from a small fixed set of comparisons, never code.
    - A collected check with a rule shows up beside the built-in checks (All checks, gaps, What changed, the audit pack's "Compass checks" counts).

    My calls
    - A check without a rule stays "evidence only": it is collected and filed, but it never passes or fails.
    - An empty capture under a rule shows as "Can't tell", not as a pass.

    Tests: test_collection_rules.py (unit + integration); RulePanel.test.tsx.

    What to check on staging: the rule preview and approval can be checked by hand (Advanced → write a rule). "Ask Polaris for a rule" is Couldn't check: it needs Polaris's AI provider.
- id: 01M6RBF3K25XZKJ93ZT0V32N3G
  author: Steve Vine
  at: 2026-11-06T11:56:21.98606Z
  text: |-
    Pre-UAT, as E2E Admin A in E2E Test Company, against the real AI provider: Passed, with one defect on Collect now (COM-1617, fixed).

    What I did and saw:
    - **Polaris drafted the rule** (about $0.15, 10 s): "No more than four directory-role assignments grant Global Administrator." It tried it on the newest capture first: "210 role assignments judged, 5 would fail".
    - **Approved: failing.** The control read "Partly automated · failing", and the rule "Failing · 5 of 210 role assignments don't meet the rule".
    - **No gap while unassessed.** ACC.13 wasn't assessed, so no gap: right, as built-in checks behave. I assessed it Partial.
    - **Gap raised.** Re-saving the rule raised "ACC.13: Entra ID (Microsoft 365) directory role assignments — failing", raised by the check.
    - **Gap closed.** Loosening the rule to ten (standing in for fixing the tenant) passed it, and the gap closed: "Closed by Compass: check passing since 6 Nov 2026."
    - **Without a rule.** The check showed "Collecting only: no pass/fail rule."

    Defects:
    - **COM-1617.** After Collect now, the rule showed "Can't tell · The check couldn't run this time" (that worker lane couldn't read the capture), so no gap.
    - **COM-1618.** The Gaps tab count only updated on reload.

    Note: ACC.13's rule is left at "ten", passing. Re-test of Collect now to follow.

    Screenshots: ~/compass-uat/s5khbev/COM-1606/
assignee: steve
label:
- feature
priority: high
task_status: review
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