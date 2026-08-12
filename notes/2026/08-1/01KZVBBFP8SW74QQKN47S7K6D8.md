---
id: 01KZVBBFP8SW74QQKN47S7K6D8
created: 2026-08-12T16:02:13.832799Z
updated: 2026-08-12T16:02:13.832799Z
type: task
title: Normalise redvektor-admin create-company to raise BadParameter on slug conflict
task_status: backlog
assignee: steve
imported_from: linear
priority: low
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 115
---
**Source:** Brief 067 implementation (DEV-285).

`redvektor-admin create-user` raises `typer.BadParameter("user already exists: …")` cleanly on a duplicate email — well-formed exit code 2 + stderr message. `redvektor-admin create-company` does NOT do the same on a slug conflict: a `Company` with a duplicate slug propagates the underlying SQLAlchemy `IntegrityError` as an unhandled exception (full traceback to stderr).

Brief 067's seed wrapper (`scripts/dev/seed_smoke_user.py`) worked around this by pre-checking via `list-companies` before calling `create-company`. That's the right local workaround, but the CLI inconsistency is a papercut for any future seed/idempotency wrapper.

**Scope of the fix**

1. In `app/backend/src/redvektor_api/cli/admin.py::create_company`, catch the SQLAlchemy IntegrityError on slug conflict and re-raise as `typer.BadParameter(f"company already exists: {slug}")`, matching the `create_user` shape.
2. Add a unit test mirroring whatever covers `create_user`'s duplicate-email path.
3. Once shipped, simplify `scripts/dev/seed_smoke_user.py` to drop the pre-check and rely on the BadParameter exit-code-2 signal (parity with how a re-implementation of `create_user` idempotency would look).

**Out of scope**

* Generic CLI exception-handling refactor — only the slug-conflict path.
* Backporting to any tag.

**Priority:** Low. Not blocking the smoke harness or any other consumer.

---

Imported from Linear [DEV-292](https://linear.app/stevevine/issue/DEV-292/normalise-redvektor-admin-create-company-to-raise-badparameter-on-slug)