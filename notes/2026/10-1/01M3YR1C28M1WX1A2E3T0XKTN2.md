---
id: 01M3YR1C28M1WX1A2E3T0XKTN2
created: 2026-10-02T16:44:24.520499Z
updated: 2026-10-10T12:01:38.160571Z
type: task
title: An open recertification review can be withdrawn — and the schedule triggered again in the same period
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 837
assignee: steve
label:
- improvement
priority: medium
task_status: backlog
---
## Why

Found by Steve on staging, 2026-10-02. He set up a schedule, triggered it, realised it was pointed at the wrong thing (Domain Admins is a **Group**, not a role), amended the schedule and pressed **Trigger now** again — and got *"This period's recertification has already been triggered"*.

A schedule runs one review per period, and the review from the first trigger is frozen with the entity and owners as they were then. Today there is no way out:

- the mistaken review cannot be closed — it sits open on **Instances** and in its owners' portal list, goes overdue, and keeps appearing in reminders until the owners submit it;
- the amended schedule cannot fire until the next period (up to a year away on an annual cadence);
- deleting the schedule does not help — its open review stays open.

The only workaround is a second schedule for the same entity, which leaves the orphaned review behind. The design (ADR 0047 §3) says a manager should be able to "amend and re-trigger"; the second half is blocked.

## What people see

- **Withdraw** on an open review, on Access Control ▸ Recertification ▸ Instances (in the review's detail). Offered to anyone who can run recertification. Not offered on a completed review.
- Withdrawing asks for a **reason** (required) and says plainly what will happen: nothing flagged in this review will be removed, and the owners will no longer be asked to review it.
- A withdrawn review:
  - carries out **no removals**, whatever was flagged, and raises no to-dos or removal approvals;
  - stays in the Instances list with status **Withdrawn**, showing who withdrew it, when and why. Decisions already made stay readable; the evidence export still works and says it was withdrawn;
  - disappears from its owners' portal Recertifications list, from Actions, from reminders and from the overdue count on the dashboard. No email is sent about the withdrawal;
  - cannot be un-withdrawn.
- Once the period's review is withdrawn, **Trigger now** works again on that schedule and opens a fresh review from the schedule as it now stands (entity, owners, instructions, minimum attestations).
- Withdrawing does **not** make the schedule fire again by itself. The period only re-opens when somebody presses Trigger now; otherwise the next review is the next period's.
- A review whose schedule has been deleted can also be withdrawn (that is how to clear the orphan the workaround leaves).
- An owner whose only recertification work was the withdrawn review loses the portal Recertifier role, the same as when a schedule is deleted.

## Acceptance

- Trigger a schedule, withdraw the review with a reason, amend the schedule's entity, Trigger now → a new review opens against the new entity with the new owners; the old one shows Withdrawn with the reason.
- Withdraw a review with rows flagged for removal → nothing is removed in the directory, no to-do and no removal approval appears.
- After a withdrawal with no manual trigger, the scheduled opener does not create a second review for that period.
- The withdrawn review is gone from the owner's portal list and from Actions, and is not counted as overdue.
- Withdraw is refused on a completed review, and for a user without the run-recertification permission.

## Implementation notes

- `recert_instances`: add `withdrawn_at`, `withdrawn_by`, `withdrawn_reason` (migration, add-only). Audited.
- `uq_recert_instances_period` is a plain unique on `(schedule_id, period)` — it has to become a partial unique index excluding withdrawn rows, otherwise the re-trigger insert fails.
- `tasks/recert.py::trigger_schedule` — the "covered" check: for `manual=True` ignore withdrawn instances; for the Beat opener (`manual=False`) a withdrawn instance still covers the period.
- New route `POST /api/v1/recert-instances/{id}/withdraw` (`require_recert_writer` + `_require_kind`); 409 on a completed or already-withdrawn instance. Regenerate `schema.d.ts`.
- Every reader of "open" instances must also exclude withdrawn: the portal recertifications router, the Actions source (`core/actions/access.py` ~L330, `completed_at IS NULL`), the reminder/overdue digest, the dashboard tile, completion evaluation and the removal executor (`tasks/access_execute`). A decision or submission on a withdrawn instance is refused.
- `_instance_out` / `InstanceStatus`: a third state alongside open/overdue and completed; sort order on the Instances list.
- `sync_recertifier_roles` for the withdrawn instance's owners (COM-558 rule: an in-flight instance holds the grant, a withdrawn one does not).
- Evidence CSV: include the withdrawal (who/when/why).
- ADR: a short new ADR amending ADR 0047 §1/§3 — a review can be withdrawn, and the `(schedule, period)` dedupe counts only reviews that were not withdrawn when triggering by hand. Do not edit 0047.
- Tests (integration, real Postgres): the five acceptance cases above; frontend test for the Withdraw modal and the Withdrawn status.