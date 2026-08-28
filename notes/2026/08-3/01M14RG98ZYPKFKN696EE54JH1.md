---
id: 01M14RG98ZYPKFKN696EE54JH1
created: 2026-08-28T18:00:54.303934Z
updated: 2026-08-28T20:48:35.341663Z
type: task
title: 'COM-481 fixed one half of the privilege gate: an approved mover is silently refused at the write'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 486
sprint: snq23hz
comments:
- id: 01M14WZEM6HY99Q4TNJA38R5TE
  author: Steve Vine
  at: 2026-08-28T19:19:05.605942Z
  text: |-
    Done — merged to main as 448ca26 (PR #482). Full CI green.

    `KINDS_GATED_ON_A_PRIVILEGED_ACCOUNT` now lives once, in `core/privileged_access`, and both halves of the gate read it. Your mover on an administrator applies end to end and the group reaches the tenant.

    The one-line narrowing was never the real fix. A duplicated predicate that must agree will drift again — and this *was* that drift, one task after the rule changed. So there is a test asserting the two halves read the same object, plus what that object is. Testing either side alone could not have caught this, which is exactly how it got out.

    **What stays split is unchanged and deliberate:** whether a group is role-assignable is re-read from the mirror at the write, because that flag can move after an approval; whether an Access Admin approved is read from the request, because it is a recorded fact about a decision. COM-481's PR argued for that and it remains right — the bug was the *kind* predicate being copied, not the two-sided design.

    Regression test confirmed failing against the old predicate with your symptom:

    ```
    assert 'refused' == 'applied'
    ```

    It drives a mover through approval **and** execution, asserting the subject applied and the group actually landed. COM-481's tests stopped at the approval returning 200 — that gap is what let this reach you, so this one goes all the way to the write.
assignee: steve
company:
- moneypenny
label:
- bug
priority: urgent
task_status: done
---
Regression from COM-481, live on staging (`staging-20260828-1640`).

A mover adding one ordinary group to an account holding a directory role now **approves fine and then does nothing**. The request reaches `executed`; the subject comes back `refused`:

> The account holds a directory role — this change needs an Access Admin's approval (ADR 0061 §5)

## Why

The gate has two sides on purpose — the approval check, and a re-check at the write (ADR 0045 §5.3's double gate). COM-481 narrowed the **approval** side from `mover | leaver` to `leaver`, and left the **execution** side as it was:

`tasks/access_execute.py:868`
```python
request.kind in (AccessRequestKind.mover, AccessRequestKind.leaver)
and not request.privileged_approved
and account_holds_privilege(db, subject.directory_user_id)
```

The two halves now disagree. The API correctly decides the mover does not touch privilege, so `privileged_approved` stays `False` — and the write reads that same flag as *"no Access Admin approved this"* and refuses.

**There is no way to satisfy it.** An Access Manager can approve, and execution refuses. An Access Admin approving does not help either, because `request_privilege_reasons` no longer returns a reason for a mover, so `_require_privilege_gate` never sets the flag.

## Worse than the bug it replaced

Before COM-481 the refusal was at approval: annoying, but visible and honest. Now the request is approved, lands `executed`, and the subject is quietly `refused` at the write — **the change looks like it went through and did nothing**. A silent no-op on a governed write is the failure mode this whole sprint is arranged to design out.

## Scope

**Narrow the execution guard to `request.kind == AccessRequestKind.leaver`**, matching the approval side.

**Then remove the duplication, which is the actual defect.** Two copies of a rule that must agree will drift again — this is that drift, one task after the rule changed. The kinds-that-need-the-gate decision belongs in `core/privileged_access.py` beside `request_privilege_reasons`, with both the API and the execution task reading it from there.

Note what stays split, deliberately: whether the *group* is role-assignable is re-read from the mirror at the write (it can change after approval), while whether an Access Admin approved is read from the request. That two-sided design is correct and COM-481's PR argued for it — the bug is that the *kind* predicate was copied rather than shared.

## Tests

- **An ordinary mover on an account holding a directory role executes end to end**, subject `applied`, group actually added. This is the regression test and it fails today. COM-481's tests stopped at the approval returning 200, which is exactly why this got through.
- A leaver against a privileged account is still refused at the write without an Access Admin, and applies with one.
- A mover dropping a role-assignable group is still refused at the write when the flag is unset.
- Assert the approval side and the execution side agree for every request kind, so the next change to one cannot silently diverge from the other.
