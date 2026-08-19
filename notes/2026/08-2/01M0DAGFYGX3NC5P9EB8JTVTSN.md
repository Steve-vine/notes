---
id: 01M0DAGFYGX3NC5P9EB8JTVTSN
created: 2026-08-19T15:33:49.136266Z
updated: 2026-08-19T15:33:56.704934Z
type: task
title: Data types get an order — a position column, a reorder control, and one order everywhere they list
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 290
sprint: sbph5q5
assignee: steve
label:
- improvement
priority: medium
task_status: todo
---
Data types list alphabetically everywhere — `order_by(DataType.name)` in the list endpoint and in the engagement relationship. Alphabetical is not an order anyone chose: the vocabulary has a shape (broadest to narrowest, least to most sensitive, most to least used) and only the organisation running it knows what that shape is. Give the admin the order, and let every pick-list and every engagement read it.

**Data types only** — Data Entities stays alphabetical for now (Steve, 2026-08-19).

Note this is the **first reordering affordance in Compass**. `approval_areas.position` and `vendor_contacts.position` both exist but are append-order only — nothing has ever changed one — so whatever shape this takes is the pattern those two inherit later.

- [ ] **`data_types.position`** — `Integer`, NOT NULL, default 0, mirroring `vendor_contacts.position` (migration 0058).
- [ ] **Migration** (take the next free number; COM-286 claims 0080): backfill `position` from the current **alphabetical** order, so nothing moves on upgrade. Backfill by `name` — it is unique and indexed — **not** by `created_at`, which is the COM-219 trap: Postgres `now()` is the transaction timestamp, so types seeded together share one value and the tiebreaker is a random UUID.
- [ ] **Reorder endpoint** — one call taking the full ordered list of ids and rewriting positions in a transaction, rather than N patches. Atomic, no intermediate duplicate positions, no half-applied order if a request fails midway. `require_vendor_write` / admin, matching the rest of the rubric's writes.
- [ ] **Create** assigns `max(position) + 1` — a new type lands at the bottom, where the admin can see it, not silently mid-list. The `approval_areas` create already does exactly this.
- [ ] **One order, everywhere they list**: the list endpoint's `order_by`, the `DataType` relationship on `VendorEngagement` (`order_by="DataType.name"` → position), `DataTypePicker`, the admin table, the vendor form's Data Types row (COM-288) and the review surface. A disabled type keeps its position — it is out of the pick-lists, not reordered.
- [ ] **Admin ‣ Data Rubric ‣ Data types** — the reorder control. Up/down buttons are the lower-risk choice and keyboard-reachable; drag-and-drop is nicer with a long list. Pick one and note why, since the next two tables will copy it.
- [ ] **Activity log**: `data_types` is audited (ADR 0042). Decide whether a reorder writes one activity row for the reorder or one per row moved — one per move turns a single admin gesture into a screenful of audit noise.
- [ ] OpenAPI regenerated → `schema.d.ts`.
- [ ] Tests: the backfill reproduces today's alphabetical order exactly; a reorder rewrites every position in one transaction and rejects a partial or unknown id list; create appends; the engagement's data types come back in the admin's order, not the alphabet's.