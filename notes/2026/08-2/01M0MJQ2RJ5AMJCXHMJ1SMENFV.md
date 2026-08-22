---
id: 01M0MJQ2RJ5AMJCXHMJ1SMENFV
created: 2026-08-22T11:11:54.642673Z
updated: 2026-08-22T13:47:54.488562Z
type: task
title: Open assessments show their progress — percentage, expiry date, manual Close
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 359
sprint: sbph5q5
blocked_by:
- 01M0MJPW4457VZ5VSRKC3GZZE6
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