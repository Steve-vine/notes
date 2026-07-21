---
id: 01KY2BCHZMT9EB04HP18Z9M0SR
created: 2026-07-21T12:46:06.32412Z
updated: 2026-07-21T14:52:37.482127Z
type: task
title: Master Incidents
project: 01KX671DATY39VW6GWK3M2T3DN
number: 178
sprint: skj7tft
assignee: steve
priority: medium
task_status: active
---
Create a new feature called **Master Incidents**. When merging one incident into another, the incident being merged becomes a **Child** and the incident it merges into becomes the **Master**. Child→Master is many-to-one. Design agreed 2026-07-21; decision record drafted as **ADR 0035** (`docs/decisions/0035-master-child-incidents.md`) — the governing principle is **merge is a link, never a move**.

## Data model

- New nullable self-referencing FK `issue.master_id` (Alembic migration, append-only). Child = `master_id` set. **Master is derived, not stored**: an incident is a master iff incidents point at it — no flag to go stale; when the last child detaches, the M indicator simply disappears.
- Status stays a pure lifecycle enum — **no "Child" status value**. The child's status is frozen at merge time and it drops out of the queue because the default incidents list hides rows with `master_id` set (children appear nested under their master and via an explicit "show children" filter).
- **Backfill: forward-only.** Pre-existing merged incidents stay `closed` with their `evidence` JSONB provenance; they do not become retroactive children.

## Merge behaviour change (reverses ISE-121 fold-in)

- Accepting a merge sets `master_id` on the child + writes audit entries — nothing else. The child **keeps** its conversation, proposed changes, Findings, and status. Remove the conversation/proposed-change re-pointing and the `closed`/`resolved_at` stamping from `merge.py`; stop writing `evidence["merged_into"]`/`merged_from` for new merges (keep reading it as historical provenance). Fix the stale "signals are folded in" docstring.
- Structural rules (service layer): depth exactly one (`master_id` must point to an incident whose own `master_id` is null); a master cannot be merged into anything; a child cannot merge anywhere without detaching first; merging *into* a child → 409; merge-candidates never propose a child — propose its master instead; self-merge stays rejected.
- Lifecycle rules: a child's lifecycle is **suspended** while attached — a child alert re-asserting writes a timeline event on the **master** and reactivates the master (not the child) if it was resolved. Resolving/closing the master **cascades** the same status to all children (and onward to their signals per ADR 0025's cascade).

## UI

- [ ] **M indicator**: small 'M' style icon next to the incident ID on the Incidents list and the incident detail page when the incident has children.
- [ ] **C indicator**: small 'C' style icon next to the incident ID on the list and detail page when `master_id` is set.
- [ ] **Child pill**: on a child, the status pill area shows a small icon plus the **master's incident ID**; clicking it opens the master.
- [ ] **Incidents list**: children hidden by default, nested/visible under their master and via a filter.
- [ ] **Children section on the master detail page**: collapsible list of all merged incidents; per child, a link to **Detach** (with the status modal) and a link to **Promote to Master**.
- [ ] **Detach from Master** (child detail page): clears `master_id`; modal asks which status the child resumes with, defaulting to its current (frozen) status.
- [ ] **Demote** (master detail page): modal asks what status the children take, then detaches every child; with zero children the incident is ordinary again.
- [ ] **Promote to Master**: one atomic transaction — promoted child's `master_id` → null, old master's `master_id` → new master, all siblings re-pointed. The old master becomes an ordinary child (status frozen).

## Acceptance

- [ ] Merge → detach round-trips a child intact: conversation, proposed changes, Findings, and status all untouched.
- [ ] Chain prevention: merging anything into a child, or a master into anything, is rejected.
- [ ] Child alert re-assert reactivates a resolved master and lands on the master's timeline.
- [ ] Resolving the master cascades to children and their signals.
- [ ] Integration tests against real Postgres for merge/detach/demote/promote + the escalation and cascade rules; frontend tests for the pill/indicators.
- [ ] ADR 0035 status flipped to Accepted and shipped with the branch; API types regenerated (`master_id` and child data in list/detail responses).
