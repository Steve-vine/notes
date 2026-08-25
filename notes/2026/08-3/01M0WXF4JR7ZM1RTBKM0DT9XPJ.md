---
id: 01M0WXF4JR7ZM1RTBKM0DT9XPJ
created: 2026-08-25T16:53:44.152936Z
updated: 2026-08-25T21:07:15.707514Z
type: task
title: An admin can delete a local user — and the audit trail keeps their name
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 404
sprint: sbph5q5
comments:
- id: 01M0XBZBDYCNWZRBFTQQ5100W5
  author: Steve Vine
  at: 2026-08-25T21:07:15.518028Z
  text: |-
    Done — PR #408, merged to main.

    **The trail first.** `activity_log.actor_name`, snapshotted at write time by the `before_flush` listener and backfilled by migration 0108 (a SQLAlchemy `update()` against named tables, not an f-string into `sa.text()`). Rows with a NULL `actor_id` stay NULL, as do rows whose actor was already gone. The Activity page renders the snapshot when the join stops answering, marked "account deleted" — before this it said "System", which read a departed colleague's work as nobody's.

    **The delete.** `DELETE /users/{user_id}`, `require_admin`, hard. No purge module: every FK to `users.id` is SET NULL or CASCADE. That claim is now a **test that reflects the live schema** rather than trusting the models — a future migration omitting `ondelete` would otherwise turn the route into a 500 for exactly the accounts that matter most. One activity-log row, written by hand and issued as a statement rather than `db.delete(user)` so the per-entity listener cannot add a second beside it. An admin cannot delete themselves.

    **Pre-flight.** `GET /users/{user_id}/deletion-impact` names the vendors that would be stranded, flags areas where they are the sole approver, counts open recert assignments and the cascading rows, and warns that an Entra account is re-provisioned on next sign-in.

    Delete sits alongside Disable rather than replacing it. The Status column and its scroll container were widened again — COM-285's defect returns otherwise, with two more actions in that column.

    Full backend suite green (796 integration + 205 unit at the time), frontend 642.
assignee: steve
company: null
label:
- feature
priority: medium
task_status: review
---
Today a user can only be **disabled** (`PATCH /users/{id}` → `status=disabled`); there is no delete at all. A test account, a typo or a departed colleague stays in the list for ever. Same argument as COM-350 made for vendors, and this follows that task's shape.

**Decided with Steve, 2026-08-25:** a real hard delete, and **the audit trail keeps the person's name**. You must still be able to see who assessed a control or approved a request last year. Today `activity_log` holds only `actor_id` with a `SET NULL` FK — so deleting a user silently anonymises their entire history, which in a governance tool is the wrong trade. Vendor approvals already snapshot `decided_by_name` for exactly this reason; the activity log should do the same.

## The trail first — this must land before the delete does

- [ ] `activity_log` gains **`actor_name`**, snapshotted at write time by the `before_flush` listener in `db/audit.py` alongside `actor_id`. Append-only as ever; nothing rewrites it later.
- [ ] Backfill migration from `users.name`. Rows with a NULL `actor_id` (system actions) stay NULL. **Use SQLAlchemy constructs, not an f-string into `sa.text()`** — the sast gate blocks interpolated SQL in migrations too.
- [ ] The activity reads render `actor_name` and fall back to the joined user only for rows written before the backfill.

## The delete

- [ ] `DELETE /users/{user_id}`, `require_admin`. Hard delete of the row.
- [ ] **An admin cannot delete themselves** — the existing self-lockout guard on roles/status, extended. This is also what makes "the last admin" impossible without a separate check: an admin deleting every *other* admin still leaves themselves.
- [ ] No purge module needed. Unlike vendors, **every** FK to `users.id` is already `SET NULL` (33) or `CASCADE` (7) — nothing `RESTRICT`s, so the database does the graph. Verify that claim in a test rather than trusting it.
- [ ] Write **one** `ActivityLog` row by hand for the deletion, as `vendor_purge` does — the listener is per-entity and cannot say "this was one act".

## What the admin must be shown *before* confirming

The cascades and null-outs are individually correct and collectively surprising. A pre-flight impact summary, in the shape of `purge_vendor`'s per-table counts:

- [ ] **Vendors they own** — `vendors.owner_id` is `SET NULL`, so deleting an owner strands every vendor they hold. ADR 0049 §6 is explicit that a stranded vendor is worse than an unowned one: the review-due reminders keep firing at nobody. List them by name and make reassignment the obvious next step.
- [ ] **Approval areas they approve for** — `vendor_approvers` cascades. Removing the last approver for an area means any request needing that area can never be decided. Name the areas, and flag any where they are the only approver.
- [ ] **Open recertification assignments** — a live campaign loses a reviewer mid-flight.
- [ ] Also going: their roles, API tokens, notifications, content-reviewer rows, co-ownerships, recert schedule ownerships.
- [ ] **Entra-provisioned accounts come back.** Deleting the local record does not touch the tenant — they are re-provisioned on next sign-in unless the group mapping is changed first (ADR 0046 §5). Say so on the dialog rather than letting an admin discover it.

## Frontend

- [ ] Delete on the Users admin screen, alongside Disable rather than replacing it — disable is still the right answer for someone on long leave.
- [ ] Confirmation carrying the impact summary above, in the same shape COM-350 used for the vendor purge.

## Tests

- [ ] Delete removes the account and its cascading rows; login afterwards fails.
- [ ] The actor's name survives on their `activity_log` rows after deletion.
- [ ] An admin cannot delete themselves.
- [ ] Owned vendors survive with a null owner and appear in the pre-flight summary; an area where they were the sole approver is flagged.
- [ ] Non-admins are refused.