---
id: 01M57VQQ6XGNJ86QW7CNXP1XBM
created: 2026-10-18T15:57:54.269123Z
updated: 2026-10-19T20:43:50.690649Z
type: task
title: Assigned content opens in cycles and Compass works out who must sign what — each person once per document however many roles ask, new role-holders asked straight away, people who leave a role dropped from its count
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1094
sprint: s7s7mn9
blocked_by:
- 01M57VQ4RV73G6J0R641030M50
comments:
- id: 01M58E4NK6YENKC48Y5QT1H8QY
  author: Steve Vine
  at: 2026-10-18T21:19:32.964872Z
  text: |-
    Done: PR #1084, built on top of #1083, all checks green, waiting to be merged.

    - Content on a role opens for signing on its assign date, then again every cadence. A one-off opens once. Assigning or restarting for today opens it straight away; otherwise an hourly run opens it.
    - Everyone holding the role is in the cycle. Each person is asked once per document, however many roles or companies ask, and their due date is the earliest one asking.
    - A signature already counts if it's of the version asked (or later) and was made within that role's cadence before the cycle opened. So signing for one role last week means another role doesn't ask again today.
    - Someone who gains the role is asked within moments, with their own deadline counted from that day. That also happens after the cycle's deadline, so a new starter on an annual role isn't left waiting a year.
    - Someone who loses the role drops out of its count and isn't asked any more. Their signatures stay, and if they get the role back they're asked again.
    - After the deadline, anyone unsigned is overdue and stays asked. A signature after someone's own deadline is marked late.
    - Stopping lets the open cycle run to each person's deadline. Restarting counts again from the new date. Changing the deadline or cadence never alters a cycle already open.
    - The role's Content card shows Running, with "12 of 40 signed, 6 days left".

    Calls I made:
    - A leaver who had already signed a closed cycle stays in that cycle's record, so past results don't shift.
    - Re-enabling a disabled role brings its overdue asks back.
    - Signatures are shared across companies, because content is shared. Each company sees them only through its own cycles.
    - Days are counted on the UK calendar.
assignee: steve
label:
- feature
priority: high
task_status: done
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