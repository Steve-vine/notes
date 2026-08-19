---
id: 01M0D4230TRYGJMW4W5DJF4WTA
created: 2026-08-19T13:41:05.690511Z
updated: 2026-08-19T13:41:28.763923Z
type: task
title: Recert completion — attestation evaluation, removals at completion, oversight views
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 284
sprint: s5gwx0s
blocked_by:
- 01M0D41E3ZDVX3Z4EJ0TPH8WWE
- 01M0D41S0C0P3YK64XF6MBV9R6
assignee: steve
label:
- feature
priority: medium
task_status: todo
---
Closing the v2 loop:

* **Completion evaluation** — on every owner submission, evaluate: **all Required owners submitted AND total submissions ≥ minimum attestations** (counted across required + optional owners, per the planning decision). Met → the instance completes; the final row states freeze as the attested outcome.
* **Removals execute at completion**, not per submission — rows standing at *flagged for removal* when the instance completes go through the existing removal execution path against the ADR 0045 write machinery. Carry the ADR's single-vs-multi-owner decision: if the ADR lands on second-person approval for single-owner schedules (the lean), implement that routing here; multi-owner completions already carry two attestors and execute directly.
* **Evidence**: the completed instance freezes the full record — snapshot, per-row decision history with attribution, each owner's submission (who/when/required-or-optional), the attestation math (n submissions vs minimum, Required roll-call), executed removals with Graph results. The CSV evidence export (COM-242's pattern) reads from this.
* **Oversight views** (Access ▸ Recertification, beside the Schedules tab): instance list + detail for access managers — live progress (who's submitted, rows flagged, whether completion is blocked on a Required owner or the minimum), the unresolvable-owner warnings from the trigger task with a reassign affordance, and the frozen evidence view for completed instances. Managers **observe and administer; they perform reviews only if they are owners** — the portal is the reviewing surface (planning decision).
* Overdue: instances open past a grace window (relative to cadence — decide a sensible default in the PR) flag on the dashboard tile and in the owners' reminder digests.

Refs: the v2 ADR, the trigger + portal tasks, COM-241/242 (execution path + evidence patterns being carried forward), ADR 0024.