---
id: 01M0MJQ2RJ5AMJCXHMJ1SMENFV
created: 2026-08-22T11:11:54.642673Z
updated: 2026-08-22T14:04:50.331819Z
type: task
title: Open assessments show their progress — percentage, expiry date, manual Close
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 359
sprint: sbph5q5
blocked_by:
- 01M0MJPW4457VZ5VSRKC3GZZE6
comments:
- id: 01M0MWKQ8VTZ0FHVPVZ59FZ7C9
  author: Steve Vine
  at: 2026-08-22T14:04:50.331527Z
  text: |-
    Done — PR #361.

    **Open rows** carry a progress bar *with* the number — "how nearly done is the supplier" is the question the row exists to answer at a glance across a list, and a bare percentage does not answer it — plus the date it expires, as the record has it.

    **No client-side clock logic beyond display**, as specified. Whether an assessment has expired is the Beat job's answer; a browser deciding otherwise would disagree with the server for hours on the day it matters.

    **Close** on open assessments only, vendor-write gated. The confirm **states the consequence** rather than asking "are you sure?": the supplier's links stop working immediately, and the *n*% answered so far becomes the read-only record, and it cannot be reopened. Somebody who only wanted to extend the deadline should find that out before pressing it.

    **Closed vs completed.** Both land in the finished group and must not read the same, so `completed` gains a teal in `statusColors` against `closed`'s grey, and a closed row carries a badge saying how it ended and how far it got — "Expired at 30%" / "Closed at 30%". An abandoned questionnaire and a submitted one are entirely different facts about a supplier.

    Two smaller consequences of the lifecycle: open rows offer **Close rather than Remove** (a supplier may be mid-answer, and removing would destroy what they had written), and no **Start** — they already have it.

    Tests scope the badge assertions per row, because "Completed" is also the group heading above them.
assignee: steve
label:
- feature
priority: medium
task_status: active
---
The admin-side monitoring for assessments that are live on the Vendor Portal, on the vendor detail Assessments tab (COM-355).

- [ ] Each **open** assessment row shows: a **percentage-complete** indicator (the lifecycle task's derived figure — a progress bar with the number, not just a number), and **the date it expires** (`valid_until`).
- [ ] A **Close** action on open assessments (the lifecycle task's manual-close endpoint), vendor-write gated, with a confirm that states the consequence: the supplier's links stop working and the answers so far become the read-only record.
- [ ] Closed assessments render distinctly from completed ones (closed-incomplete vs fully submitted — different badge, same read-only answer view, showing % it reached and how it closed: manually, or expired).
- [ ] Expired-today behaviour is the Beat job's (lifecycle task); this surface just reflects it — no client-side clock logic beyond display.
- [ ] Tests: open rows carry %, expiry and Close; close round-trips and the row moves to the closed group; closed vs completed badges; percentages match answered counts.