---
id: 01M0261MGTGAE9CRQAYXM1DTRE
created: 2026-08-15T07:44:09.242666Z
updated: 2026-08-15T07:44:09.242666Z
type: task
title: An operator cannot reopen a resolved incident, so an auto-resolution cannot be reversed
label: improvement
assignee: steve
priority: medium
task_status: backlog
project: 01KX671DATY39VW6GWK3M2T3DN
number: 726
tech: null
---
Found while building ISE-722, which asked that a dismissal a human reverses count against the concluding playbook. **There is no such path.**

`VALID_TRANSITIONS["resolved"] == {"closed"}` (`api/v1/issues.py:132-139`), and `reactivated` is written in exactly one place — `promotion.py:252`, when a signal recurs. So a resolved incident can only go forward to `closed`. An operator who reads a resolution and disagrees with it has no way back.

**This matters more now that ISE can resolve incidents by itself.** A concluding playbook (ADR 0101) auto-resolves on validated preconditions and composes the resolution note; ISE-704 displays it. If the operator reads that note and thinks the conclusion is wrong, the only recourse is to raise a new incident by hand, which:

- loses the link to the signal and the run that closed the first one;
- leaves the playbook's `conclusion_successes` point standing, since `refute_conclusion` only fires on recurrence — so the playbook keeps credit for a conclusion a human rejected, and autonomy reads that number;
- makes the timeline read as two unrelated incidents about one problem.

Recurrence is the only refutation ISE currently has, and it only fires when the signal itself comes back. A conclusion can be wrong without the signal recurring — that is precisely the "benign, expected" class the first autonomous release is limited to.

**Scope**
- A transition from `resolved` (and probably `closed`) back to a live state, with a mandatory note, exactly as `resolved`/`dismissed` demand one (ISE-642). "Reopened because…" is the account the next operator needs.
- Audit it as its own action with the actor, not as a generic `updated`.
- When the incident being reopened carries a `playbook_run` pointer to a concluding playbook, call `playbooks.refute_conclusion` — the hook already exists and does the right thing (retracts the success, keeps the total, re-checks the autonomy floor). ISE-722 left the call site out rather than ship it unreachable.
- Decide what happens to the resolved signal: `resolve_incident_signals` cascaded resolution down to it, so reopening should probably cascade back, or say why not.
- Check the notification path — a reopen is arguably an `incident_opened` event, as a reactivation is.

Worth deciding whether `dismissed` reopens too. A dismissal is sticky by design (promotion.py refuses to bounce it back), and that stickiness is deliberate — but it was chosen when only humans dismissed things.