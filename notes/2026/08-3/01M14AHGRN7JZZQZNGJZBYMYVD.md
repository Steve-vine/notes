---
id: 01M14AHGRN7JZZQZNGJZBYMYVD
created: 2026-08-28T13:56:54.677953Z
updated: 2026-08-28T13:56:54.677953Z
type: task
title: The privilege gate fires on who the person is, not on what the change does
label: bug
company: moneypenny
assignee: steve
task_status: todo
priority: high
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 481
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
