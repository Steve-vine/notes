---
id: 01M1VXQ0GSWQ5MYPBK8A9E1TC8
created: 2026-09-06T17:54:29.52971Z
updated: 2026-09-06T17:55:22.7243Z
type: task
title: Backend — the suggestions record, its permission and the API behind the light bulb
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 599
sprint: scx5myr
assignee: steve
label:
- feature
priority: medium
task_status: backlog
---
Everything the dialog needs, before there is a dialog. A suggestion is a title, a description, who wrote it, when, and where it has got to.

## The record

`models/suggestion.py` — `Suggestion(Base, UUIDPrimaryKeyMixin, TimestampMixin, ActorMixin, SoftDeleteMixin)`, table `suggestions`. **No `CompanyScopedMixin`** (ADR 0068, COM-598).

* `title` — `String(255)`, required.
* `description` — `Text`, required. Plain text; the dialog is two fields, not an editor.
* `status` — `SAEnum(SuggestionStatus, name="suggestion_status")`, default `new`. `new` / `under_review` / `planned` / `done` / `declined`.
* Author is `created_by` from `ActorMixin` — it is already the column that means this, so do not add a second one.

## The permission

One new tick in the Admin group of `core/permissions.py`: `admin_manage_suggestions = "admin.manage_suggestions"`, labelled **"Manage suggestions"** — *"Edit anyone's suggestion, move it through triage, and delete duplicates."* Add its `PermissionInfo` to the `admin` `PermissionGroup` and to `brief/permission-catalogue.md`; it is not dangerous, so it stays out of `DANGEROUS_PERMISSIONS`. Add it to the built-in admin role's seed so an existing administrator has it after deploy without anybody ticking anything.

Then `core/auth.py` gets `require_manage_suggestions` alongside its siblings.

## The endpoints

`api/v1/suggestions.py`, `prefix="/suggestions"`, registered in `router.py`.

* `GET /suggestions` — any authenticated internal user. Every suggestion, newest first, each with its author's name and its status. Not paginated; if it ever needs to be, that is a follow-up.
* `POST /suggestions` — any authenticated internal user. Title and description; status is `new` and is not settable on create.
* `PATCH /suggestions/{id}` — title and description if you are the author **or** hold `admin.manage_suggestions`; `status` only with the permission. A non-manager sending `status` gets a 403, not a silent drop.
* `DELETE /suggestions/{id}` — `admin.manage_suggestions` only. Soft delete (`deleted_at`), and every read filters `deleted_at.is_(None)`.

Author-or-manager is a rule about a person and a record, so it lives in the handler and not in the permission matrix — the catalogue docstring already says why.

## Migration

- [ ] `op.execute` the `CREATE TYPE suggestion_status`, then reference it with `postgresql.ENUM(..., create_type=False)`. `create_table` does **not** emit the `CREATE TYPE` on its own and the failure only shows on an incremental deploy, never in fresh-DB CI.
- [ ] `created_at` / `updated_at` need `server_default=sa.func.now()` in `create_table`.
- [ ] One Alembic head after rebasing on main.

## Tests

`tests/test_suggestions.py`, real Postgres:

- [ ] Anyone can create and read; the list is newest first and carries the author's name.
- [ ] The author can edit their own title and description; another ordinary user gets 403 on the same record.
- [ ] A manager can edit anyone's, and can set the status; an ordinary user sending `status` gets 403.
- [ ] Delete is 403 without the permission, and after a manager's delete the record is gone from `GET` but still in the table.
- [ ] A portal user (`is_internal=False`) gets nothing — add it to the auth sweep if that is where the portal boundary is asserted.
- [ ] Switching company does not change the list (the ADR 0068 claim, asserted once).

## Before pushing

- [ ] `ruff check` and `ruff format --check` over `src`, `tests` **and** `migrations`.
- [ ] Regenerate `schema.d.ts` and commit it — new routes and new docstrings both drift it, and the PR suite does not check.

## Related

- COM-598 — ADR 0068, the scope decision this implements.
- COM-600 — the dialog that calls these endpoints.
