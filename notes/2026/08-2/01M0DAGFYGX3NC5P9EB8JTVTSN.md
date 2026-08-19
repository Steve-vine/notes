---
id: 01M0DAGFYGX3NC5P9EB8JTVTSN
created: 2026-08-19T15:33:49.136266Z
updated: 2026-08-19T21:25:02.110148Z
type: task
title: Data types get an order — a position column, a reorder control, and one order everywhere they list
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 290
sprint: sbph5q5
comments:
- id: 01M0DYKJVD5R7X7QKR36BMPY57
  author: Steve Vine
  at: 2026-08-19T21:25:01.933252Z
  text: |-
    Shipped in PR #288, merged to main as 1cb6149.

    `data_types.position` (Integer, NOT NULL, default 0). **Migration 0084** (0080 was taken by the recert work; COM-286 took 0083) backfills from the current alphabetical order so nothing moves on upgrade — backfilled by `name`, not `created_at`, avoiding the COM-219 trap.

    `PUT /data-types/order` takes the complete ordered list of ids and rewrites every position in one transaction. Partial, duplicated or unknown lists are 422. Admin-only. Create assigns `max(position) + 1`.

    One order everywhere: the list endpoint, the `DataType` relationship on `VendorEngagement`, `DataTypePicker` and the admin table. The picker **sorts** rather than relying on insertion order — otherwise an `alsoAllow` type (a disabled one an old engagement still records) would jump to the bottom. A disabled type keeps its position; it is out of the pick-lists, not out of the vocabulary, so it is still named in a reorder and re-enabling puts it back.

    **Two decisions the next two tables inherit** (`approval_areas` and `vendor_contacts` both carry an append-only `position` today):

    1. **Up/down buttons, not drag-and-drop.** Keyboard-reachable, no pointer precision, no drag library, and these vocabularies are short.
    2. **One activity row per reorder, not one per row moved.** The `before_flush` listener now skips a `data_types` change that is position-only (the same shape as the existing `api_tokens` / `last_used_at` skip) and the endpoint writes the single row. That is the only hand-written row in the log — the listener is per-entity and cannot express "these N updates were one action". Both sides carry a comment saying so.

    Tests: the backfill reproduces today's order over rows inserted in one transaction (the trap made explicit); create appends; a reorder rewrites every position and the list endpoint agrees; partial/unknown/duplicate lists refused with nothing moved; a disabled type keeps its place across disable and re-enable; admin-only; exactly one activity row; and an engagement's data types come back in the admin's order. Frontend: the table lists in order and a move sends the whole list; first cannot move up, last cannot move down.
assignee: steve
label:
- improvement
priority: medium
task_status: review
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