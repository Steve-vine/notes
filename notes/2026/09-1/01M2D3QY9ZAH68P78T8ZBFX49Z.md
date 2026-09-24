---
id: 01M2D3QY9ZAH68P78T8ZBFX49Z
created: 2026-09-13T10:06:56.831084Z
updated: 2026-09-24T21:00:32.925326Z
type: task
title: Recertification results are reachable from the asset — a Reviews list in the asset's Recertification section, with outcome, instance and evidence
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 706
sprint: skdc1az
blocked_by:
- 01M2D04FXYNZVGHNE8T1W6W8V5
comments:
- id: 01M2ZZ8CZ2WY5G5GX71X6VKKBS
  author: Steve Vine
  at: 2026-09-20T17:54:07.458526Z
  text: |-
    Merged to main 2026-09-20 as 13c5a93 (PR #741). CI green on the PR; backstop green and images built on main.

    What you will see
    - Asset page ▸ Recertification: under the schedules, a Reviews list, newest first and sortable — Period · Status (Open / Overdue / Completed) · Completed (or "open since …") · Attestations ("1 of 1 required · 2 submitted") · Rows ("3 certified · 1 flagged") · Removals ("1 executed · 1 pending") · an Evidence download once the review has completed. Technology assets and data assets alike.
    - Clicking a row opens that review in place, read-only: who attested and when, each holder's decision and removal, Evidence CSV. If you hold Access rights it also offers "Open under Access ▸ Recertification" — that is where removals are approved.
    - The list shows the last ten and says "The last 10 of N reviews"; "All reviews" goes to Access ▸ Recertification ▸ Instances narrowed to this asset's schedules, with a "Show all reviews" link to widen again.
    - A review now has its own address, /access/recert/instances/<id>: the Instances tab with that review open. Nothing mails or links to it yet apart from the asset page — actions and mail can adopt it later.
    - Portal: the owner's technology-asset and data-asset pages gain a Recertification card with the same list, record and evidence, read-only.
    - "All schedules and instances" stays below the list.

    Gate decision (asked for in the task): served through the asset, not by widening the recert list. The reviews, a single review and its evidence are read via the asset (containers, data-assets, and the portal's ownership-scoped router) behind whatever already lets you read the asset — so an inventory reader with no Access rights and a portal owner both see them. Widening /recert-instances for schedule-filtered reads would have made that gate reason about which schedules a reader may name, and a slip there exposes every group's and role's reviews. Every read is pinned to the asset; a review of anything else is a 404. A deleted schedule's past reviews stay on the asset.

    API: GET /recert-instances takes a repeatable schedule_id (as the task suggested); the instance shape gains removals_executed and removals_pending (pending = awaiting the second person, or approved and not yet carried out — for a user/local entry, an Inventory admin has yet to confirm). New bounded shape for the asset's list (total, schedule_ids, reviews). No migration.

    Refactor: the review detail moved out of RecertPage.tsx into access/RecertInstanceView.tsx so the oversight modal and the asset page render one component.

    Tests: backend integration — open then completed review with the right counts read by an inventory-only account (still 403 on /recert-instances), detail + evidence through the asset, 404 from another asset and across kinds, portal owner vs stranger, the bound (12 → 10) and the schedule filter, data-asset routes. Frontend — rows/counts, evidence only when completed, in-place detail, the links for Access holders only, portal reads from the portal API, empty state, the review's own address, the narrowed Instances list.

    Smoke test: an asset with a completed and an open review (CRM-style: trigger a schedule, attest in the portal, flag one entry) → check the list, open a row, download Evidence; repeat as the owner in the portal; then "All reviews" / the deep link as an Access holder.
assignee: steve
label:
- improvement
priority: medium
task_status: done
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