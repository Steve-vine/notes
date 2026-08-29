---
id: 01M16C5S8T7AAKCHRB1FVV5M3C
created: 2026-08-29T09:03:56.186266Z
updated: 2026-08-29T09:52:54.593021Z
type: task
title: Consider SSH connection multiplexing for git-sync
project: 01KY6W9951TW0904DT0GGJVGE7
number: 407
sprint: segj1dz
comments:
- id: 01M16EVXS4VGPY0TW4AVWQTCW4
  author: Steve Vine
  at: 2026-08-29T09:50:58.849049Z
  text: |-
    Done — PR #399 (branch `brief-407-ssh-multiplexing`).

    `run_net`'s default `GIT_SSH_COMMAND` now appends `-o ControlMaster=auto -o ControlPath=/tmp/notuvia-ssh-<user>/%C -o ControlPersist=30`, so a cycle's push reuses the fetch's connection.

    Measured against origin: first fetch 1.41s, second 0.54s — 2.6× faster, no second handshake. Socket confirmed at `srw-------` inside a `0700` directory, 63 bytes of the 104 available.

    All four constraints from the description are met, and two of them turned out to matter more than expected.

    **ControlPath length — the guard has to count `%C` expanded.** It's two characters written and forty bound. My first cut measured the literal and looked comfortable at 63 characters, while the path ssh would actually bind was 101 of macOS's 104 bytes. That's also what ruled out the OS temp dir: `/var/folders/dj/…/T/notuvia-ssh/%C` measures 101 expanded, so multiplexing would have been correctly declined on the primary platform and silently never engaged. Hence `/tmp/notuvia-ssh-<user>` — short by construction, with the user suffix so two accounts on one machine don't contend. There's a regression test that fails if the check ever reverts to measuring the literal.

    **A missing socket directory is fatal, not graceful.** I assumed ssh would skip multiplexing and carry on; it does not. Verified directly:

    ```
    unix_listener: cannot bind to path /tmp/…/<hash>: No such file or directory
    fatal: Could not read from remote repository.
    Please make sure you have the correct access rights…
    ```

    That's the push failing outright, wearing exactly the misleading credentials tail NOT-405 was written to suppress. So I dropped the `OnceLock` caching I'd planned and the directory is re-ensured on every network op — `/tmp` is swept by periodic cleaners, and "it existed at startup" isn't something to bet sync on. Costs a handful of syscalls against a network round trip.

    **Ownership is verified, not assumed.** `/tmp` is world-writable, so a directory of that name could belong to anyone. Creating it ourselves is proof we own it; finding it already there is not, so that branch checks `mode & 0o077 == 0` and compares the directory's uid against a probe file we just created — a file we made is owned by us, so its uid *is* ours, without needing a uid syscall. Anything that fails declines rather than tries to repair something that isn't ours.

    **ControlPersist = 30s.** Spans one cycle's fetch→push (seconds apart) and nothing more, which is what bounds both new failure modes: a wedged master poisons the cycle it happened in rather than every cycle after it, and a master outlives the app by seconds. Verified by watching the master (pid 30141) self-reap and remove its socket. First attempt at measuring that was wrong — I polled with `ssh -O check`, which attaches as a client and resets the idle timer, so the master looked immortal for 40s. Re-measured with `ps` only.

    Also declines on Windows (Win32 OpenSSH has no `ControlMaster`, so asking for it is an error not an optimisation), and still leaves a user-set `GIT_SSH_COMMAND` alone.

    No ADR — this is a transport implementation detail with its constraints recorded at the call site, not a decision that shapes later work. Same call as NOT-405.

    Verification: `cargo fmt --check`, `cargo clippy --workspace --all-targets -- -D warnings`, `cargo test --workspace` (453 tests) all green; 5 new tests. One clippy fix along the way — `assert!` on a constant became a `const _: () = assert!(…)`.

    Still untested, and it's the thing the task was actually about: whether this helps on the throttled corporate network. That needs the network that produced NOT-405.
assignee: steve
label:
- improvement
priority: low
task_status: done
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
