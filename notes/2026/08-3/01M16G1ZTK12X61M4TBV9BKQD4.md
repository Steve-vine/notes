---
id: 01M16G1ZTK12X61M4TBV9BKQD4
created: 2026-08-29T10:11:46.131967Z
updated: 2026-08-29T19:36:55.791013Z
type: task
title: Restore an archived company
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 506
sprint: s2fcksg
blocked_by:
- 01M16G1KQ4CCD6TRMM321AYQEG
comments:
- id: 01M17GCTQFZYDXQCDG1VQT15N9
  author: Steve Vine
  at: 2026-08-29T19:36:55.79087Z
  text: |-
    Done — PR #525, merged to main as fa98f25.

    POST /companies/{id}/restore, admin-only, mirroring the archive endpoint rather than opening status up on CompanyUpdate — this is a state transition with a confirmation behind it, not a field somebody edits.

    The ticket's expectation held: everything COM-505 froze unfreezes by the same switch, with no resume plumbing, because the freeze is a status check at each site and never a stored flag. The test that proves it is a write refused while archived succeeding after restore.

    Archive and Restore share one slot in the row — the same decision from either side, so an archived row is never offered Archive and an active one never Restore. A plain confirmation, not a typed one: restoring is reversible, so the friction the delete dialog needs would be theatre here. The dialog still says what will be behind rather than only asking.

    The staleness notice. companies.restored_at is set by restore and cleared by the coverage snapshot pass — the pass that actually recomputes those figures. So the notice ends when the condition does, rather than on a timer or on the admin's word for it. Worded about the derived picture as you specified: coverage figures, membership attribution, vendor review statuses. It says explicitly that users, groups and memberships are current and the directory mirror never stopped, because a blanket "data may be stale" would send someone looking for a problem that is not there. It sits above the routed page rather than on one screen, since the figures are behind everywhere they are read. Dismissal is per-viewer localStorage keyed by the restore itself, so a later archive-and-restore shows it again — that is different staleness.

    The recert question you left open was answered on the freeze side, in COM-505: a schedule falling due while archived is skipped, not queued. The dedupe key is (schedule, period), so restoring resumes from the next occurrence rather than firing a backlog at whoever owns it.

    One existing test changed rather than added to: the COM-505 assertion that an archived row's Archive button is disabled — that button is now Restore, which is the one thing that should still be offered.

    Migration applied and reversed against a real incrementally-migrated database. 17 backend tests, full frontend suite (881).

    Ready for smoke test on staging.
assignee: steve
company: null
label:
- feature
priority: medium
task_status: active
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
