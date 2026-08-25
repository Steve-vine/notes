---
id: 01M0885S57BA00TPZNPQV9AXMF
created: 2026-08-17T16:16:48.807396Z
updated: 2026-08-25T18:43:12.331614Z
type: task
title: Directory mirror — periodic sync of tenant users, groups and memberships
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 237
sprint: s5gwx0s
blocked_by:
- 01M0885JWENYX3NDY493000M80
comments:
- id: 01M08MPGT64NM967ZW218RBBMH
  author: Steve Vine
  at: 2026-08-17T19:55:40.230262Z
  text: 'Done — merged to main (PR #237, squash 3e32ed7; migration 0061). The mirror: directory_users / directory_groups / directory_group_members keyed by Entra object id, global. Vanished users/groups are marked (vanished_at) and un-marked on reappearance, never deleted, so snapshots keep resolving; membership rows are current-state facts reconciled each pass — security groups only (the governable kind). Group kinds classified security/m365/dynamic with dynamic winning (the rule owns the membership); mail-enabled distribution lists aren''t mirrored; is_assignable_to_role carried for the §5 refusals. Sync is a 15-minute Beat full resync, idempotent, actorless and audit-quiet, paged through the COM-236 helper. Staleness is never silent: every pass (clean or failed) writes the directory_sync_status singleton, shown on the Admin ▸ Integrations Entra card with counts, last error and a "Sync now" queued dispatch. Integration tests drive a mutable MockTransport fake tenant through full sync, vanish/reappear, reconciliation, failure recording and the admin endpoints.'
assignee: steve
company: null
label:
- feature
priority: medium
task_status: done
---
Everything downstream (role matrix pick-lists, JML diffs, recert snapshots) reads a **local mirror**, not live Graph — so screens are fast, work offline from Microsoft, and recert snapshots have something stable to point at.

* **Tables**: `directory_users`, `directory_groups`, `directory_group_members` — mirrors keyed by Entra object id, not governance entities (no soft-delete ceremony; a vanished object is marked, not deleted, so historical snapshots keep resolving). Global, not company-scoped — the tenant is shared (sprint decision).
* **Sync task**: Celery Beat, idempotent upsert taking no arguments (scan-the-world like `tasks/reminders.py`), paged reads via the new `core/graph.py` helper; delta queries where they earn their keep (users, group membership), full resync as the fallback path. Security groups only — scope out M365/dynamic-membership groups explicitly (dynamic membership can't be written to anyway; surface them read-only or not at all, decide in the ADR).
* **Audit quiet**: worker sessions are actorless, so the nightly sync creates **zero activity-log noise** (`tasks/mail_health.py` establishes this; mirrors are deliberately *not* in `_AUDITED_TABLES` — the governed entities downstream are).
* **Status surfacing**: last-sync time + counts + last error on the Admin panel from the connection task; a stale mirror must be visible, never silent (the ADR 0044 no-silent-no-op rule).

Refs: ADR 0045, 0006 (idempotent, IDs, JSON), 0044 §4; `tasks/reminders.py`, `tasks/mail_health.py`.