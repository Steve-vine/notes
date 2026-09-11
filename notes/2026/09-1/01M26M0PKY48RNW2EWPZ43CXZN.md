---
id: 01M26M0PKY48RNW2EWPZ43CXZN
created: 2026-09-10T21:36:40.062719Z
updated: 2026-09-11T19:27:57.917602Z
type: task
title: Container recertification — a container as a schedule entity, portal attestation, removals by access model
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 670
sprint: skdc1az
blocked_by:
- 01M26M0B4T8B324YYQ3T7YKKXH
comments:
- id: 01M26X04883F19AGQSY4HP5T8D
  author: Steve Vine
  at: 2026-09-11T00:13:38.439903Z
  text: |-
    Done — PR #678 merged to main.

    Backend: `recert_scope_kind` gains container; `recert_schedules.container_id`; items carry `source` (group | manual), `manual_holder_id`, `holder_label` and who confirmed a manual removal (migration 0182). Every entity switch extended (name, validation, owner defaults from owner + co-owners, create/update, snapshot: the container's governing groups as scope plus its manual holders as their own rows). Removals by source: group rows go to the one directory write path; manual rows flag the holder pending, are never dispatched (the executor refuses them too), and become an unassigned Inventory action for `inventory.admin` — never back to the recertifier. `POST …/manual-holders/{id}/confirm-removed` clears the holder and stamps the evidence with who and when; the CSV carries each row's source. Schedule writes on a container need `inventory.run_recertification`; `GET /containers/{id}/recert-schedules` for the container's card. 2 integration tests covering the acceptance path end to end.

    Frontend: Container entity type on Access ▸ Recertification with a picker; the schedule modal exported with a preset so the container detail's new Recertification card opens it pinned to the container; Confirm removed on a pending holder (inventory.admin); the portal review marks manual rows and says Compass cannot remove them; Actions label "Manual access removal".
assignee: steve
label:
- feature
priority: high
task_status: done
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