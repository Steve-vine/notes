---
id: 01KY6ZXHV9RHW280Z7G5RV255X
created: 2026-07-23T08:01:52.489531Z
updated: 2026-07-23T11:04:51.422144Z
type: task
title: Git-sync hangs forever on a stalled network connection (sync stuck "on")
priority: high
comments:
- id: 01KY6ZXSV1C3SQBG4XT4JPBMC4
  author: Steve Vine
  at: 2026-07-23T08:02:00.672576Z
  text: |-
    Steve Vine · 2026-06-29:

    Fixed — PR #102: https://github.com/Steve-vine/notula/pull/102

    ## What was done
    Routed the network git ops (`push`/`fetch`) through a fail-fast envelope in `git.rs`:
    - `GIT_TERMINAL_PROMPT=0` (no interactive-prompt hang),
    - `GIT_SSH_COMMAND` with `BatchMode` + `ConnectTimeout=10` + `ServerAliveInterval=10`/`ServerAliveCountMax=3` (dead connection torn down in ~30s; respects a user-set value),
    - a hard 90s wall-clock timeout (`run_with_timeout`) that kills the child as a backstop, draining stdout/stderr on threads to avoid a false timeout on a chatty transfer.

    The worker already clears `syncing` on the error path, so a bounded failure now self-recovers instead of wedging.

    ## Verification
    - New deterministic tests: `run_with_timeout` kills a `sleep 30` at a 300ms timeout in <5s, and returns real output on the happy path. Existing `push`/`gitsync` tests still green (push now flows through `run_net`).
    - Pre-push gate all green (fmt, clippy, frontend typecheck/build, full test suite).

    ## Live mitigation (done earlier)
    Killed the 13-hour-hung `git push`/`ssh`; the worker recovered with no app restart and sync settled back to healthy.

    ## Follow-up filed
    Panic-safety of `begin`/`end` (the other stuck-flag path) → separate issue, parent-linked.

    Moving to In Review — merge call is yours.
imported_from: linear
assignee: steve
task_status: done
project: 01KY6W9951TW0904DT0GGJVGE7
number: 124
sprint: stkh502
---
## Symptom

The sync indicator gets stuck showing "syncing" indefinitely and never clears.

## Root cause

`git.rs::run()` runs every git command via `Command::output()`, which **blocks until the child process exits — with no timeout, no SSH keepalive, and no** `GIT_TERMINAL_PROMPT=0`. When a `git push`/`fetch`'s underlying `ssh` connection goes stale (laptop sleeps / network changes, leaving a half-open TCP socket neither side tears down), `output()` never returns. The sync worker (`gitsync.rs`) is therefore frozen *inside* a cycle between `begin()` (sets `syncing = true`, [gitsync.rs:249](<http://gitsync.rs:249>)) and `end()` (clears it, [gitsync.rs:256](<http://gitsync.rs:256>)). The single worker thread is blocked, so the flag stays true forever and the 180s auto-sync can never fire again.

Observed live: a `git push -u origin HEAD` (child of the running app) had been blocked **\~13 hours** on a still-`ESTABLISHED`-but-dead TCP connection to GitHub's SSH. There was nothing to push (repo already in sync) — a pure connection hang, not a real transfer.

## Fix (this issue)

Give the network git operations (`push`, `fetch`) a fail-fast envelope so a stalled connection can never wedge sync again:

* `GIT_TERMINAL_PROMPT=0` — never block on an interactive credential/passphrase/host-key prompt.
* `GIT_SSH_COMMAND` defaulting to `ssh -o BatchMode=yes -o ConnectTimeout=10 -o ServerAliveInterval=10 -o ServerAliveCountMax=3` (respecting a user-set value) — aborts a dead connection in ~30s instead of forever.
* A hard wall-clock timeout on the subprocess (kill + return `Err`) as a backstop covering HTTPS or anything SSH keepalive misses.

The worker already resets `syncing` on the error path, so once a network op returns `Err` the indicator clears and the worker resumes.

## Immediate mitigation (done)

Killed the hung `git push` + `ssh`; the worker recovered on its own (no app restart needed) and sync settled back to healthy.

## Out of scope → follow-up

A **panic** inside the sync closure (vs. an error) skips `end()` and strands the flag with no recovery (kills the worker thread). Not the cause here; file separately as a robustness follow-up (scope-guard / `catch_unwind` around `begin`/`end`).

## DoD

`push`/`fetch` cannot block the sync worker indefinitely; a stalled remote surfaces as a recorded `last_error` and the `syncing` flag clears. Existing git/gitsync tests stay green.

---

Linear DEV-712 · M10 — Sync · created 2026-06-29 · done 2026-06-29