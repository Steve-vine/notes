---
id: 01M0W995XR7SZCG62RCBJMD5VF
created: 2026-08-25T11:00:57.400749Z
updated: 2026-08-29T08:27:55.5096Z
type: task
title: Sync retries only non-fast-forward — a dropped connection surfaces as a bogus auth error
project: 01KY6W9951TW0904DT0GGJVGE7
number: 405
sprint: segj1dz
assignee: steve
label:
- improvement
priority: medium
task_status: todo
---
A push from a corporate network (SSH routed over `ssh.github.com:443` because port 22 is blocked) failed with `Connection to ssh.github.com closed by remote host` — GitHub tearing down the session, most likely per-IP SSH throttling on a shared NAT or a TLS-inspecting proxy killing the 443 session. The transport failure itself is environmental and not ours, but Notuvia handles it badly in two ways.

**No retry.** `push_absorbing_remote` (`src-tauri/crates/notuvia-core/src/gitsync.rs:431`) retries only non-fast-forward rejections — `is_remote_moved` (`gitsync.rs:456`) excludes everything else by construction, and the doc comment states network failures "fail fast on the first attempt". A transient teardown that the very next attempt would survive instead becomes a user-visible error, waiting up to the 180s `DEFAULT_AUTO_SYNC` tick to clear.

**Misleading message.** `explain_push_error` (`gitsync.rs:607`) annotates push protection and passes everything else through raw, so the user sees git's generic tail — "Please make sure you have the correct access rights and the repository exists" — for what is a network blip. That reads as a broken deploy key and sends the user hunting for a credential problem that doesn't exist.

Not a 0.17.0 regression: `gitsync.rs` and `git.rs` are unchanged since NOT-387 (d17f50a), well before 0.16.0.

## Work

- [ ] Classify transient transport failures — `closed by remote host`, `Connection reset`, `Broken pipe`, `Operation timed out`, `kex_exchange_identification` — as retryable, distinct from `is_remote_moved` and from auth failures (`Permission denied`, `publickey`), which must still fail fast.
- [ ] Retry that class with exponential backoff (a plain re-push, no pull — the remote hasn't moved). Reuse the `PUSH_RETRIES` shape but with a longer, growing pause, since throttling needs real time to clear.
- [ ] Extend `explain_push_error` with a diagnosis for the class: name it as a connection/network problem, say the sync will retry, and drop the auth-flavoured tail. Mention the `ssh.github.com:443` path as a likely context.
- [ ] Consider SSH connection multiplexing in the `GIT_SSH_COMMAND` default (`src-tauri/crates/notuvia-core/src/git.rs:116`) — `ControlMaster=auto` + `ControlPersist` — so `fetch` and `push` in one cycle share a connection instead of opening two. Halves connection rate against a throttled IP. Must stay off when the user has set their own `GIT_SSH_COMMAND`, as today, and needs a per-vault `ControlPath` that survives app restarts without leaking sockets.
- [ ] Tests: the transient class retries and succeeds; auth failures still fail on the first attempt; a non-fast-forward still takes the pull-and-retry path.
