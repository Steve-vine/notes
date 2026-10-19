---
id: 01M59MKSAZGWV17JNT259MC3M2
created: 2026-10-19T08:31:54.207255Z
updated: 2026-10-19T08:32:00.20261Z
type: task
title: CI's package caches are saved once on main and shared, instead of every PR uploading its own 145 MB copy
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1112
sprint: sjlj05e
assignee: steve
label:
- follow_up
priority: low
task_status: todo
---
Sprint 77 follow-up, found during COM-1105 (2026-10-19).

## Why

The repo's Actions cache holds **10.8 GB against GitHub's 10 GB limit**: 74 copies of the frontend npm cache, ~145 MB each, one per PR. There is one uv cache.

- `frontend` and `deps-scan` use `actions/cache` on `~/.npm`, which saves on a miss. Nothing on `main` ever runs npm, so there is no default-branch copy for a PR to restore from. A PR can only read its own scope and the default branch's.
- So **every new PR misses**. `npm ci` downloads the packages from the registry, then the post-job step uploads 145 MB over g5's uplink. On run 39219812891 that was Install 57s plus a 113s save in deps-scan, off the critical path but on the shared link.
- The cache sits at its limit, so GitHub evicts least-recently-used entries continually. That includes the uv cache, and soon COM-1105's pass markers.
- The uv cache has a smaller flaw. Its key is shared by the backstop (`uv sync`, runtime only) and the PR jobs (`--extra dev`). PR jobs get an exact hit on the runtime-only copy and download the dev wheels every run.

## What changes

- The package caches are saved **once on main**, when the lockfile changes, and every PR restores them read-only.
- PRs stop saving their own copies, and the cache stays well under its limit.

## Notes (technical)

- A small push-to-main job, or the backstop, runs `npm ci` and `uv sync --extra dev`, and saves `npm-<lock hash>` / `uv-dev-<lock hash>` with `actions/cache/save` only on a miss.
- PR jobs switch to `actions/cache/restore` with the same keys. Keep the prefix `restore-keys` fallback.
- Delete the existing PR-scoped `npm-*` caches once main has its copy (`gh cache delete`).
- Check COM-1105's `ci-pass-v1-*` markers aren't being evicted. They're tiny, but LRU doesn't care.

**Done when:** the cache is under 3 GB, PR runs restore npm and uv from main and save nothing, and a new PR's first frontend Install is under 20s.