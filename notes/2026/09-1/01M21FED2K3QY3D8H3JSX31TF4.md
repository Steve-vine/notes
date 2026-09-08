---
id: 01M21FED2K3QY3D8H3JSX31TF4
created: 2026-09-08T21:40:34.003824Z
updated: 2026-09-08T21:52:55.989441Z
type: task
title: The activity log says what changed — field, old value, new value
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 629
sprint: sa2t9sq
assignee: steve
label:
- feature
priority: medium
task_status: todo
---
Asked for by Steve while smoke-testing, 2026-09-08. Companion to COM-628 (the History box comes off the detail pages).

## Today

Every user-made change to a governance record already writes an entry to the Activity log: when, who, "created / updated / deleted", and a one-liner such as *updated gap Backups not tested*. For an update that is all it says. Compass knows which fields changed at the moment it writes the entry, and discards it; old and new values are never kept. So the trail proves that somebody touched a gap, not what they did to it.

## Change

Each **updated** entry records the fields that changed, with the value before and after, and the Activity page shows them.

**On the Activity page**, the Detail column reads, for an update:

> Backups not tested — Status: Open → In progress · Owner: — → Deb Wharton · Target date: — → 30 Sep 2026

One line per changed field when there are several; the record's name first, as now. Created and deleted entries keep their one-liner. Values show the way the screen shows them — a status by its label, a person by their name, a date as a date — not as identifiers.

**What is not recorded.** Secrets and credentials are never written to the trail — a password change says "changed password", nothing more, as it already does. Long free text (a description, a decision's body, gap notes, a document's content) records that the field changed, not the text before and after: the trail is for "who moved this to Closed and when", not for reading back every draft. (Assumption on the long-text cut-off; say if you want descriptions kept in full.)

**From when.** The detail starts accruing from the day this ships. Older entries stay as they are — the information was never captured, so there is nothing to backfill.

This is one change in the central hook that writes every entry, so it covers gaps, risks, decisions, assessments, treatment plans, and everything else audited, at once.

---

*Implementation notes.*

**Model.** `ActivityLog.changes: Mapped[list[dict] | None] = mapped_column(JSONB, nullable=True)` — `[{"field": "status", "from": "open", "to": "in_progress"}, …]`, raw stored values (the enum value, the UUID, the ISO date), **rendering is the frontend's job**. Append-only migration adding the nullable column; existing rows stay NULL. `changes: list[ActivityChange] | None` on `ActivityLogOut`. Docstring/schema → drift script, commit `schema.d.ts`.

**Capture** (`db/audit.py`). `_changed_attrs` already computes the set from `inspect(obj).attrs[…].history`; build the list from `history.deleted[0]` / `history.added[0]` (or the current attribute value) for each changed key, in `_on_before_flush` next to the existing `_update_summary` call. Exclusions:
- `_SKIP_ATTRS` = `{"updated_at", "deleted_at", "password_hash", "last_used_at", "token_hash", …}` plus anything `Settings.log_redact_keys` matches (`core/logging.py:_should_redact`) — reuse the predicate so the two redaction lists cannot drift.
- Relationship attributes: only column attributes (`attr.key in mapper.column_attrs`); a changed relationship shows up as its FK column anyway.
- Long text: columns of type `Text` whose old or new value exceeds ~200 chars → `{"field": …}` with no `from`/`to` (the "changed, not shown" case). Enum → `.value`; UUID/date/datetime → `str()`; everything else must be JSON-serialisable or is `str()`'d.
- Soft-delete (`_was_soft_deleted`) stays a `deleted` entry with no changes list; creates likewise.
Existing special cases (`_value_summary` for extra-field values, the password-only summary) keep their summaries — the structured list is additional.

**Rendering** (`ActivityPage.tsx` Detail column). A small `ActivityChanges` component: field label map per `entity_type` (reuse `ENTITY_LABELS`' shape; unknown field → humanised key), value formatting by field: `status` → the entity's status labels (`GAP_STATUS_LABELS`, the risk/assessment equivalents — after COM-625 the gap labels are the six new ones); `owner_id` / `*_user_id` → name via the users lookup the page can already fetch (`useUsers` or the OwnerPicker's source), falling back to the id; `*_date` → `toLocaleDateString()`; `null` → "—". A field with no `from`/`to` renders as *Description changed*. Keep the summary as the first line so old rows read exactly as before.

**Tests.** Backend integration (real Postgres): updating a gap's status+owner writes one entry with two changes carrying raw values; password change writes no `password_hash` change; a long description update records the field with no values; a create writes `changes = NULL`. Frontend: the Detail cell renders label/from/to for a gap status change, "—" for null, the field-only case, and an old row with `changes: null` unchanged.