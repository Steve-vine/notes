---
id: 01M14AHGRN7JZZQZNGJZBYMYVD
created: 2026-08-28T13:56:54.677953Z
updated: 2026-08-28T14:50:02.58883Z
type: task
title: The privilege gate fires on who the person is, not on what the change does
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 481
sprint: snq23hz
comments:
- id: 01M14DJR73E3VGMYP6DXHQHF9Y
  author: Steve Vine
  at: 2026-08-28T14:50:00.799745Z
  text: |-
    Done — merged to main as aec65f0 (PR #474). Full CI green.

    Narrowed the account-privilege rule from `mover | leaver` to `leaver` alone. Movers, joiners and membership changes now gate purely on the group test, which already caught every way a mover can reach privilege — including dropping an unexplained membership that turns out to be a role-assignable group.

    **The leaver keeps the gate**, and it should: disabling the account, revoking its sessions and stripping its memberships *is* a change to privileged access however routine the request looks. That is also the case ADR 0061 §5 names as the reason for replacing ADR 0045 §5.4's refusal with a gate at all.

    **The regression test was confirmed to fail against the old code**, with your message:

    ```
    assert ['acts on an ... role: Grace'] == []
    ```

    **ADR 0061 gained an amendment** (2026-08-28, COM-481) recording the narrow reading, appended rather than rewritten. §5's "acting on one needs Access Admin approval" was ambiguous between acting on a privileged *account* and changing privileged *access*; the implementation took the literal reading. Without the amendment the next person reinstates the broad rule straight from the text, so the code fix alone would not have held.

    The §5 mitigations are untouched and the amendment says so explicitly: one write path, maker-checker on every change, protected-object re-checks at the write, the full trail. This narrows *which* second person a privileged change needs; it never removes the requirement for one.

    Four tests: an ordinary mover on an administrator is approvable by an access_manager and reports no privilege reasons; the same for a membership change; a mover dropping a role-assignable group still needs an Access Admin; a leaver against an administrator still needs one and executes when they approve.
assignee: steve
company:
- moneypenny
label:
- bug
priority: high
task_status: review
---
Defect in COM-451, found testing sprint 45 on staging.

A mover that adds one ordinary group to an account which happens to hold a directory role is refused to an Access Manager:

> This change touches privileged access (acts on an account holding a directory role: S Vine) — the approver must hold the Access Admin role

Nothing in that request grants or removes privileged access. The gate fired on the subject's identity.

## Why it is wrong

`request_privilege_reasons` asks two questions. The first — *does this change touch a role-assignable group?* — is correct, and already covers everything a mover can do to privilege, including dropping an unexplained membership that happens to be a privileged group (`drop_group_ids` is in the set it checks).

The second fires for **any mover or leaver** whose subject holds a directory role, whatever the change does. That is the wrong axis: the gate exists for privilege being granted or removed, not for who the person is.

**The cost is not the annoyance.** Administrators are among the most-changed accounts, so this makes an Access Admin a bottleneck on routine work — and the predictable response is to make the change in Entra instead. That is the exact failure ADR 0061 was written to end: *"the only way to make somebody an administrator was to bypass Compass entirely."* This recreates a smaller version of it.

## The one case that keeps the gate

**A leaver against a privileged account.** It disables the account, revokes its sessions and strips its memberships — that *is* a change to privileged access, and it is the case ADR 0061 §5 names as the reason for replacing ADR 0045 §5.4's refusal with a gate.

So narrow the second rule to `leaver`; do not delete it. Movers, joiners and membership changes then gate only when the change genuinely touches a role-assignable group, which the first rule already handles.

## The ADR is ambiguous, and that is the root cause

ADR 0061 §5 says *"acting on one needs Access Admin approval"* — ambiguous between acting on a privileged **account** and changing privileged **access**. The implementation took the broad reading; the section's own reasoning supports the narrow one.

**Append an amendment to ADR 0061** saying which, following the pattern ADR 0045 already uses for its own amendments (append, never rewrite — CLAUDE.md). Without it the next person reinstates the broad rule from the text and this comes back.

## Tests

- A mover adding a non-privileged group to an account holding a directory role is approvable by an **access_manager**. This is the regression test, and it fails today.
- A mover that drops an unexplained membership which *is* a role-assignable group still needs an Access Admin (rule one, must not regress).
- A leaver against a privileged account still needs an Access Admin — the COM-451 behaviour that must survive.
- A membership change adding an ordinary group to a privileged account is approvable by an access_manager.
- A membership change adding a role-assignable group still needs an Access Admin.
