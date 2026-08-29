---
id: 01M16C5S8T7AAKCHRB1FVV5M3C
created: 2026-08-29T09:03:56.186266Z
updated: 2026-08-29T09:03:56.186266Z
type: task
title: Consider SSH connection multiplexing for git-sync
task_status: backlog
assignee: steve
priority: low
label: improvement
project: 01KY6W9951TW0904DT0GGJVGE7
number: 407
---
Follow-up from NOT-405, where it was the one checklist item deliberately not folded into the brief.

Each sync cycle opens two SSH connections — `fetch` then `push`. Against an address GitHub is throttling (a shared corporate NAT, SSH routed over `ssh.github.com:443`), halving the connection rate is worth having. `run_net` (`src-tauri/crates/notuvia-core/src/git.rs:116`) already sets a `GIT_SSH_COMMAND` default when the user hasn't; adding `-o ControlMaster=auto -o ControlPath=… -o ControlPersist=…` there would share one connection between the two.

## Why it wasn't done under NOT-405

The retry + diagnosis work landed under NOT-405 addresses the reported symptom directly: the dropped push now retries with backoff, and the message no longer accuses the user's key. Multiplexing is a *rate* optimisation on top of that, against a problem observed once, and it introduces a shared-state failure mode a sync engine doesn't currently have — so it wants its own brief and its own testing rather than a ride on a bug fix.

## What it has to get right

- **`ControlPath` length.** The socket path is a `sun_path`, capped near 104 bytes on macOS. A path derived from the vault's location will sometimes exceed it, so it needs a short digest under the OS temp/runtime dir, not the vault path.
- **A wedged master blocks every later session.** With `ControlMaster=auto`, clients attaching to a hung master can hang until `run_net`'s `NET_TIMEOUT` (90s) fires — turning one bad connection into a per-cycle stall. A short `ControlPersist` bounds the blast radius; the exact value is the thing to test.
- **No leaked sockets or processes across app restarts.** `ControlPersist` leaves an ssh master alive after Notuvia quits. It must self-reap, and a stale socket must degrade to a fresh connection rather than an error.
- **Stay off when the user has set `GIT_SSH_COMMAND`,** exactly as the current default does.

## Testing

Needs a real throttled/proxied network to be worth anything — the failure it targets doesn't reproduce on a healthy connection.
