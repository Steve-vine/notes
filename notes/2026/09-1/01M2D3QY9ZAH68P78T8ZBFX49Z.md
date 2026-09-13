---
id: 01M2D3QY9ZAH68P78T8ZBFX49Z
created: 2026-09-13T10:06:56.831084Z
updated: 2026-09-13T10:07:02.101517Z
type: task
title: Recertification results are reachable from the asset — a Reviews list in the asset's Recertification section, with outcome, instance and evidence
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 706
sprint: skdc1az
blocked_by:
- 01M2D04FXYNZVGHNE8T1W6W8V5
assignee: steve
label:
- improvement
priority: medium
task_status: todo
---
Smoke finding, 2026-09-13 (Steve): the asset page's Recertification section (`RecertificationCard` in `pages/ContainerDetailPage.tsx`) shows the schedule, cadence, next due and "last <period>" as text, then one generic link to Access ▸ Recertification. From the asset you cannot see whether the last review completed, who attested, what was flagged or removed, or reach the evidence. The backend already has it all: `GET /recert-instances` (list), `/recert-instances/{id}` (detail), `/recert-instances/{id}/evidence` (CSV).

**The section gains a Reviews list** — for technology assets now, and for data assets when COM-702 adds their section (same component):
* One row per instance whose schedule targets this asset, newest first: **Period** · **Status** pill (open / completed / overdue, as the oversight view names them) · **Completed** date (or "open since <triggered>") · **Attestations** ("2 of 2 required · 3 submitted") · **Rows** certified / flagged · **Removals** executed / pending (pending = flagged manual entries awaiting an Inventory admin, COM-670/COM-704) · an **Evidence** download for completed instances.
* Each row opens the instance's detail — the oversight view that exists under Access ▸ Recertification. If that view is inline in `RecertPage` rather than routed (check: no `instanceId` route was found in `App.tsx`), give it a route (`/access/recert/instances/:id`) so the asset page, actions and mail can deep-link to it; the RecertPage list keeps working as today.
* The list is bounded (last 10, "All reviews" link to the oversight list filtered to this schedule) — an asset reviewed monthly for years must not grow the page.
* **API**: `GET /recert-instances?schedule_id=` (or `?entity_kind=container&entity_id=`) if the list endpoint does not already filter — one query param, no new endpoint; the list items already carry the counts the oversight view shows, so no new shape unless a count is missing (add `removals_pending` if it is).
* Gates: reading instances on the asset page needs `inventory.view` **or** the recert read gate — an inventory reader who cannot see Access ▸ Recertification should still see the outcome of their asset's reviews (the evidence is about the asset). Decide in the PR whether to widen the list gate for schedule-filtered reads or serve the rows through the asset router; say why.
* **Portal**: the owner's asset page shows the same Reviews list read-only (they are usually the attester; seeing the record of what they attested is fair), with the evidence download.
* The generic "All schedules and instances" link stays, below the list.

Tests: rows for open and completed instances with the right counts; the deep link; the bound and the "All reviews" link; an inventory reader without access-recert rights sees the list; portal owner sees it read-only.

**Acceptance**: on an asset with two completed reviews and one open, the Recertification section lists all three with status, dates, attestation and removal counts; clicking one opens the instance; Evidence downloads the CSV; the same on the portal asset page.