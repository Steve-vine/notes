---
id: 01M0261MGTGAE9CRQAYXM1DTRE
created: 2026-08-15T07:44:09.242666Z
updated: 2026-08-15T14:45:57.232105Z
type: task
title: An operator cannot reopen a resolved incident, so an auto-resolution cannot be reversed
project: 01KX671DATY39VW6GWK3M2T3DN
number: 726
sprint: sevhjex
comments:
- id: 01M02Y5ZBGQ8FPRQS1BKMS4DXQ
  author: Steve Vine
  at: 2026-08-15T14:45:57.231956Z
  text: |-
    Done — PR #681, merged to main 2026-08-15. Every scope item, plus the `dismissed` question you left open.

    **Dismissed reopens too.** Its stickiness survives completely intact: promotion still refuses to bounce a dismissal back, because that guard is about a **machine** overriding a human's judgement. A human overturning their own side's judgement is the opposite act — and it is exactly what ISE-722 assumed already existed. Same for `closed`.

    **The note, and what happens to the old one.** Same mandatory bar as the two verdicts (ISE-642), and it is the sharpest of the three: the previous verdict stays on the timeline, so an unexplained reopen leaves the reader with two contradictory statements and nothing joining them. The old `resolution_note` is **superseded, not deleted** — moved into the audit row and cleared from the field. Clearing is the point: a live incident has no resolution, and ISE-704 renders that field as though it were the answer.

    Audited as **`incident_reopened`** with its own timeline line, as you asked.

    **`refute_conclusion` finally has its second call site** — the one it was built for. The arithmetic is deliberately identical to a recurrence's (a wrong conclusion is a wrong conclusion however it was caught); only the recorded reason differs, so the two stay distinguishable in the audit trail.

    **On "decide what happens to the resolved signal": it cascades back, and the interesting part is what status it returns to.** Not a guess — `resolved_at` is ingest's own record of whether the source still reports the signal, which is precisely the distinction ISE-733 established this morning:

    | `resolved_at` | returns to |
    |---|---|
    | NULL — still reported | `triggered` |
    | set — source cleared it | `recovered` |

    Never `recurring`: that would claim the signal went away and came back, which is the recurrence this path exists to be **distinct** from. `ignored` is left alone.

    This cascade is not optional, and ISE-733 is why: without it the incident is live while its signal still reads `resolved`, and the new presence filter keeps hiding it — the estate would stay **green** about a problem an operator has just said is not fixed.

    **Notifications:** yes, `incident_opened`, exactly as a reactivation does. **Children:** they come back with the master, symmetrically with ADR 0035 §5 — a child that cannot outlive the master's resolution cannot be left resolved when that resolution is withdrawn.
assignee: steve
label:
- improvement
priority: medium
task_status: active
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