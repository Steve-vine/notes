---
id: 01M16G1ZTK12X61M4TBV9BKQD4
created: 2026-08-29T10:11:46.131967Z
updated: 2026-08-29T17:08:06.722136Z
type: task
title: Restore an archived company
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 506
sprint: s2fcksg
blocked_by:
- 01M16G1KQ4CCD6TRMM321AYQEG
assignee: steve
company: null
label:
- feature
priority: medium
task_status: todo
---
Archiving is currently one-way. There is no un-archive endpoint, and `CompanyUpdate` (`api/v1/schemas.py:230-234`) only accepts `name`, `slug` and `is_default` — `status` is not writable. Archive the wrong company and the only route back is the database.

## Behaviour

An admin can **Restore** an archived company from Admin ▸ Companies. It returns to active: back in the switcher, writable again, and its background work resumes.

- Restore action on the archived row, admin-only, with a plain confirmation.
- Sets `status` back to `active`. Best as a dedicated `POST /companies/{id}/restore` mirroring the archive endpoint, rather than opening `status` up on the update schema.
- Everything frozen by [[COM-505]] unfreezes by the same switch — no separate resume plumbing, provided the freeze is implemented as a status check rather than a stored flag anywhere.

## The staleness notice

While archived, the company's *derived* picture stopped being maintained: coverage figures, membership provenance/attribution, vendor review statuses, recertification schedule firing. On restore, show a dismissible notice on the company that its figures may be out of date until the next full pass.

Word it about the derived picture, **not** the directory. The Entra/Graph mirror is tenant-wide and never stopped, so users, groups and memberships are current — saying "data may be stale" flat would be misleading. Recert schedules that fell due while archived also need a decision at build time: fire late on restore, or skip to the next occurrence (dedupe is on `(schedule, period)`, `tasks/recert.py:484`).

## Tests
Restore returns the company to the switcher list; a write that was refused while archived succeeds after restore; restore on an already-active company is a no-op or a clean 400.
