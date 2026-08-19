---
id: 01M0D41E3ZDVX3Z4EJ0TPH8WWE
created: 2026-08-19T13:40:44.287724Z
updated: 2026-08-19T13:41:26.61325Z
type: task
title: Recert trigger — instances, per-owner assignments, notification email
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 282
sprint: s5gwx0s
blocked_by:
- 01M0D4149WAH44RW6PD38EYAFT
assignee: steve
label:
- feature
priority: medium
task_status: todo
---
What happens when a schedule fires (Beat or Trigger now):

* **Instance**: a recertification instance snapshots the entity's membership at trigger (role scope = members across its mapped groups, deduplicated; group scope = that group's members) — the ADR 0015 §4 snapshot discipline as before — plus frozen copies of the schedule's owner set (with Required flags), minimum attestations, and instructions **as at trigger**, so later schedule edits never rewrite an in-flight or historical instance.
* **Per-owner assignments**: one assignment row per owner over the shared row set — submission state lives per owner (`pending | submitted`, submitted_at); the member rows themselves are shared (one row set per instance, all owners see the same live state — the portal task renders it).
* **Email**: via `core/mail`, subject **"Scheduled Recertification - &lt;Entity name&gt;"**, body carrying the schedule's **Instructions** and a link to the portal's **Recertifications** tab (deep link that lands the signed-in owner on their assignments). One email per owner at trigger; unsubmitted owners join the existing reminder/overdue digest machinery rather than a new nag path.
* Owners who no longer resolve at trigger (user deactivated since the schedule was saved): the instance opens anyway with the gap surfaced on the oversight view — an instance that silently can't complete is the failure mode to avoid; completion math uses the frozen owner set, so an access manager needs the visible prompt to reassign or amend the schedule and re-trigger.

Refs: the v2 ADR, the schedules task (entity being triggered), COM-241 (snapshot machinery being reshaped), ADR 0044 (mail path), 0015 §4.