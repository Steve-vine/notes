---
id: 01M57VQQ6XGNJ86QW7CNXP1XBM
created: 2026-10-18T15:57:54.269123Z
updated: 2026-10-18T15:58:00.367164Z
type: task
title: Assigned content opens in cycles and Compass works out who must sign what — each person once per document however many roles ask, new role-holders asked straight away, people who leave a role dropped from its count
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1094
sprint: s7s7mn9
assignee: steve
label:
- feature
priority: high
task_status: todo
---
Sprint 78, Attestations (ADR in COM-1092). Builds on the role's Content tab (COM-1093). This is the rule the rest of the sprint relies on. It has no new screen of its own beyond what the role tab shows.

## What happens

- **A cycle opens** on the assign date, and again every cadence (a one-off opens once). It runs until its deadline (assign date + deadline days).
- **Each person who holds the role is due** for that document in that cycle, unless a signature they already have counts.
- **One request per person per document.** If three of someone's roles assign the Acceptable Use Policy, they see it once. Its deadline is the earliest of the open cycles asking for it. This holds across companies too, because content is shared.
- **A signature counts for a role's cycle** when:
  - it is of the version that was current when the cycle opened, or a later one; and
  - it was made during the cycle, or within that role's cadence before the cycle opened.

  So someone who signed for Role A last week isn't asked again when Role B opens today. Someone whose last signature is older than the cadence is asked again.
- **New starters:** someone who gains the role while a cycle is open is due straight away, with their own deadline counted from the day they joined. When the role's next cycle opens they fall in with everyone else.
- **Leavers:** someone who loses the role is no longer counted for it. If no other role asks, their request disappears from the portal. Their signatures are kept.
- **After the deadline** anyone still outstanding is **overdue**. They stay asked until they sign, and a signature after the deadline is recorded as **late**.
- The role's Content tab shows **Next opens** and, while a cycle runs, "**12 of 40 signed, 6 days left**".

## Rules

- A one-off assignment never re-opens. A signature on the version current when it opened (or later) satisfies it for good.
- Changing the deadline or cadence never rewrites a cycle that has already opened.
- Stopping an assignment lets its open cycle run to its deadline.
- Who holds a role comes from the role's holders as Access Control knows them, and changes as soon as Access Control sees a joiner, mover or leaver.

## Notes (technical)

- Tables: cycle (assignment, opened at, deadline, version current at open) and per-person due rows (cycle, person, own deadline for new starters). Signatures arrive in COM-1095. Until then, test with signatures created directly in fixtures.
- A Beat task opens cycles and reconciles who is due (idempotent, takes IDs). Also reconcile on role-holder change, because "straight away" for a new starter shouldn't wait for the nightly run.
- Unit-test the counting rule hard: overlapping roles with different cadences, a signature just inside and just outside the window, a version bump between cycles, joining mid-cycle, leaving and rejoining, and the same person in two companies.

**Done when:** cycles open on schedule, the due list is right for the cases above, and the role tab shows progress.