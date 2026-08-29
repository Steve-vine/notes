---
id: 01M0W995XR7SZCG62RCBJMD5VF
created: 2026-08-25T11:00:57.400749Z
updated: 2026-08-29T09:16:13.965036Z
type: task
title: Sync retries only non-fast-forward — a dropped connection surfaces as a bogus auth error
project: 01KY6W9951TW0904DT0GGJVGE7
number: 405
sprint: segj1dz
comments:
- id: 01M16CENGJZ19DFFDY9R0RD2F6
  author: Steve Vine
  at: 2026-08-29T09:08:47.249657Z
  text: |-
    Done — PR #397 (branch `brief-405-sync-transient-retry`). Four of the five checklist items delivered; the fifth split out as NOT-407, see below.

    What was done:
    - **Classification.** `is_transient_transport` recognises a dead connection by *positive* evidence — `closed by remote host`, `connection reset`, `broken pipe`, `operation timed out`, `connection timed out`, `kex_exchange_identification` — matched case-insensitively, since macOS says "Operation timed out" where Linux says "Connection timed out". Deliberately not the complement of `is_remote_moved`, so an unfamiliar failure still fails fast rather than being retried blindly. `AUTH_MARKERS` (`permission denied` / `publickey` / `authentication failed`) veto the class, for a message that somehow carries both.
    - **Retry.** The class re-pushes unchanged (nothing moved, so nothing to pull) with a 1s/3s/9s backoff against the moved-remote path's 250/500/750ms. Worst case ~13s added to a cycle that was going to fail anyway — cheap against a bogus error standing for a full `DEFAULT_AUTO_SYNC` tick.
    - **Message.** `explain_push_error` gains a branch that names the network as the cause, says the commits are safe on this machine and the next sync will push them, mentions the `ssh.github.com:443` path, and strips git's "correct access rights" line. A real `Permission denied (publickey)` still passes through untouched, tail and all.
    - **Tests.** Three new ones covering the classifier (both directions, plus the other two failure classes), the retry policy per class including budget exhaustion, and the message.

    Decisions made on the fly:
    - Extracted the retry policy into `push_retry(err, round) -> PushRetry`, a pure function returning `PullAndRetry(Duration)` / `WaitAndRetry(Duration)` / `Fail`, leaving `push_absorbing_remote` owning only the loop. That's what makes the task's test checklist ("the transient class retries", "auth fails on the first attempt", "non-fast-forward still pulls and retries") testable at all — none of it is reachable without a real network otherwise.
    - Only git's "correct access rights" line is stripped from the raw output, not the whole tail. `fatal: Could not read from remote repository` isn't auth-specific and is real evidence, so it stays.
    - No ADR. This is a bug fix within an existing mechanism (DEV-1004's retry loop), not a decision that shapes later work.

    The multiplexing item: considered, not folded in — **filed as NOT-407** with the analysis carried over in full. It's a connection-*rate* optimisation sitting on top of this fix rather than part of it; it introduces a shared-state failure mode the sync engine doesn't have today (clients attaching to a wedged `ControlMaster` can hang until the 90s `NET_TIMEOUT`, turning one bad connection into a per-cycle stall); and the `ControlPath` length limit, `ControlPersist` reaping and stale-socket behaviour can only be judged against a real throttled network. Folding it in would have expanded a bug fix into an untestable one.

    Problems encountered: one bug caught in review of my own change — the first cut lowercased the error before calling `is_push_protection`, whose marker is upper-case `GITHUB PUSH PROTECTION`, so the guard was half-dead. Now checked against the original string before lowercasing.

    Verification: `cargo fmt --check`, `cargo clippy --workspace --all-targets -- -D warnings`, and `cargo test --workspace` (411 tests) all green. Worth noting the real-world case can't be reproduced locally — the classifier and policy are tested against the exact message shapes, but confirmation that a throttled push now recovers has to come from the network that produced the original report.
assignee: steve
label:
- improvement
priority: medium
task_status: done
---
A push from a corporate network (SSH routed over `ssh.github.com:443` because port 22 is blocked) failed with `Connection to ssh.github.com closed by remote host` — GitHub tearing down the session, most likely per-IP SSH throttling on a shared NAT or a TLS-inspecting proxy killing the 443 session. The transport failure itself is environmental and not ours, but Notuvia handles it badly in two ways.

**No retry.** `push_absorbing_remote` (`src-tauri/crates/notuvia-core/src/gitsync.rs:431`) retries only non-fast-forward rejections — `is_remote_moved` (`gitsync.rs:456`) excludes everything else by construction, and the doc comment states network failures "fail fast on the first attempt". A transient teardown that the very next attempt would survive instead becomes a user-visible error, waiting up to the 180s `DEFAULT_AUTO_SYNC` tick to clear.

**Misleading message.** `explain_push_error` (`gitsync.rs:607`) annotates push protection and passes everything else through raw, so the user sees git's generic tail — "Please make sure you have the correct access rights and the repository exists" — for what is a network blip. That reads as a broken deploy key and sends the user hunting for a credential problem that doesn't exist.

Not a 0.17.0 regression: `gitsync.rs` and `git.rs` are unchanged since NOT-387 (d17f50a), well before 0.16.0.

## Work

- [x] Classify transient transport failures — `closed by remote host`, `Connection reset`, `Broken pipe`, `Operation timed out`, `kex_exchange_identification` — as retryable, distinct from `is_remote_moved` and from auth failures (`Permission denied`, `publickey`), which must still fail fast.
- [x] Retry that class with exponential backoff (a plain re-push, no pull — the remote hasn't moved). Reuse the `PUSH_RETRIES` shape but with a longer, growing pause, since throttling needs real time to clear.
- [x] Extend `explain_push_error` with a diagnosis for the class: name it as a connection/network problem, say the sync will retry, and drop the auth-flavoured tail. Mention the `ssh.github.com:443` path as a likely context.
- [ ] ~~Consider SSH connection multiplexing in the `GIT_SSH_COMMAND` default~~ — considered and **split out as NOT-407**. It's a connection-rate optimisation on top of this fix rather than part of it, it introduces a shared-state failure mode (a wedged master stalling every later session), and it can only be validated on a real throttled network. The analysis — `ControlPath` length limits, `ControlPersist` reaping, stale-socket degradation — is carried over in full.
- [x] Tests: the transient class retries and succeeds; auth failures still fail on the first attempt; a non-fast-forward still takes the pull-and-retry path.
