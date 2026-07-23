---
id: 01KY728M3MP0WZRZ22KJEY9EPW
created: 2026-07-23T08:42:52.404657Z
updated: 2026-07-23T11:04:51.961104Z
type: task
title: Pre-push hook test run corrupts the repo when pushing from a linked git worktree
priority: high
imported_from: linear
task_status: done
assignee: steve
project: 01KY6W9951TW0904DT0GGJVGE7
number: 269
sprint: sx9znt9
---
## What happened (observed while landing DEV-916)

Pushing from a linked worktree (`git worktree add …`) runs the lefthook pre-push `rust-test` job, and the test suite **corrupted the repository**:

* Test-created commits ("first", "v1", `notuvia: vault update …`) landed on the real feature branch, orphaning the actual work.
* `core.bare = true` and a `[user] Tester / t@example.com` identity were written into the shared `.git/config`, breaking the main checkout (`fatal: this operation must be run in a work tree`) and mislabelling future commits.
* A gitsync test's `push_remote` saw the repo's real `origin` and **pushed the garbage branch to GitHub**.

## Root cause

Git exports `GIT_DIR` to hooks. From the main checkout it is relative (`.git`), so the tests' `git -C <tmpdir>` subprocesses harmlessly re-resolve it inside each temp repo. From a linked worktree it is **absolute** (`…/.git/worktrees/<name>`), so every git subprocess spawned by the tests — `git::run` in `notuvia-core/src/git.rs` and the raw `Command::new("git")` helpers in `gitsync.rs`/`runtime.rs`/`git.rs` tests — operates on the real repository regardless of `-C`. Parallel test threads then race on the real index (`index.lock` collisions, "remote origin already exists").

## Fix

Scrub the inherited git environment wherever we spawn git:

* In `git::run` (production path — inheriting `GIT_DIR`/`GIT_WORK_TREE`/`GIT_INDEX_FILE` is always wrong for vault operations): `env_remove` those vars.
* In the test helpers that call `Command::new("git")` directly.

Optionally also `env: {GIT_DIR: ""}`-style unsetting in `lefthook.yml` as belt and braces.

## Verify

`GIT_DIR=$PWD/.git cargo test -p notuvia-core` from a clean clone passes without touching the enclosing repo; a push from a linked worktree passes the hook.

---

Linear DEV-922 · Backlog · created 2026-07-09 · done 2026-07-10