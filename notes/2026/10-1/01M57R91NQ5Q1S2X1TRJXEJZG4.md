---
id: 01M57R91NQ5Q1S2X1TRJXEJZG4
created: 2026-10-18T14:57:27.735482Z
updated: 2026-10-18T14:57:41.324022Z
type: task
title: The tests that rebuild the database from empty start from a saved copy instead, so they stop getting slower with every new migration
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1090
sprint: sjlj05e
assignee: steve
label:
- improvement
priority: high
task_status: todo
---
Sprint 77, CI / Build optimisation. Raised 2026-10-18. Start after sprint 76 is on staging.

## Why

Most integration tests already start from a database cloned from one migrated template (`template_compass` in `tests/conftest.py`), which is cheap.

The **migration tests** are the exception. They take an **empty** database and replay the whole migration chain up to an old revision, seed data, then migrate forward. Their cost grows two ways at once:

- **More migrations to replay:** 184 in mid-September, 293 now.
- **More tests doing it:** 14 test files then, 29 now, with 106 `command.upgrade` calls.

So every sprint makes every existing migration test slower, as well as adding new ones. They are also fragile: a test that seeds an old revision through today's models breaks when a later migration adds a column. That cost a red CI round in COM-1072 (`test_container_access.py`).

## What changes

- A migration test asks for **"a database at revision X"** and gets a clone of a saved copy at that revision. The copy is built once per test worker, the first time any test asks for X, and reused after that. Tests stop replaying from empty.
- A small helper for seeding rows at an old revision with plain SQL, so tests no longer reach for today's models against an old schema. Convert the existing migration tests that seed through the models.
- Nothing about what is tested changes. Every migration test still checks its own upgrade (and downgrade where it does today).

## Notes (technical)

- Fixture shape:
  - `db_at_revision(revision)` builds `template_rev_<hash>` by upgrading an empty database to the revision (or, cheaper, upgrading from the nearest already-built lower template), then `CREATE DATABASE … TEMPLATE`.
  - Cache per xdist worker; templates need zero connections when cloned (see the existing conftest note).
- Measure the migration tests' total time with `--durations=0` before and after, and record it in the PR.
- Check whether `upgrade head` itself (the main template build, once per worker) is worth caching across workers too. It runs six times per CI job today.
- Lint and format `tests/` as CI does (`ruff check .`).

**Done when:** migration tests clone from per-revision templates rather than replaying from empty; the seeding helper exists and the model-based seeds are converted; the migration tests' total time is measured before and after and is at least halved.