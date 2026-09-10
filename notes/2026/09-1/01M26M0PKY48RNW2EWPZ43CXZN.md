---
id: 01M26M0PKY48RNW2EWPZ43CXZN
created: 2026-09-10T21:36:40.062719Z
updated: 2026-09-10T23:37:52.843948Z
type: task
title: Container recertification — a container as a schedule entity, portal attestation, removals by access model
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 670
sprint: skdc1az
blocked_by:
- 01M26M0B4T8B324YYQ3T7YKKXH
assignee: steve
label:
- feature
priority: high
task_status: active
---
Scheduled access recertification of containers on the recert v2 model (ADR 0047), extended by ADR 0072.

* **Schedule entity**: `recert_schedules.entity_type` gains `container`. Owners prefill from the container's owner + additional owners; Instructions, cadence, minimum attestations as today. Schedules are created from the container detail (**Recertification** section: schedule summary, next due, last instance, Add/Edit) and remain listed under Access ▸ Recertification ▸ Schedules for oversight.
* **Snapshot at trigger**: the combined holder list from COM-669 — group holders resolved through nested expansion plus manual holders — one row per holder with its source frozen. Owners attest in the portal's existing **Recertifications** tab; nothing new to learn.
* **Removals at completion**, by source:
  * **Group holder** → the one directory write path (`tasks/access_execute`, ADR 0045 §5/§6), with the single-owner second-person rule from ADR 0047 §5 unchanged. An inherited holder's removal edits the nested group and the row says so.
  * **Manual holder** → Compass cannot remove it. Set `removal_pending` on the holder and raise an **Inventory action** (ADR 0055 source `inventory.manual_removal`) — **unassigned**, visible to everyone holding `inventory.admin` (rule two of ADR 0055; the recertifier is the owner, so it cannot go back to them). The admin removes the access outside Compass and marks the action done, which clears the holder from the list; the instance's evidence records who confirmed and when.
* The frozen evidence and CSV export cover both sources. The dashboard tile and reminder digests treat container instances like any other.
* Gated: schedule writes `inventory.run_recertification`; the removal action `inventory.admin`.

**Acceptance**: trigger a schedule on a container with both access models; flag one group holder and one manual holder; complete → the group removal executes through Graph, the manual one appears as an action for Inventory admins and the holder shows *removal pending* until it is done.