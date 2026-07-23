---
id: 01KY6ZY8WGHNAJWVDKGH7639WS
created: 2026-07-23T08:02:16.0804Z
updated: 2026-07-23T12:25:00.327192Z
type: task
title: Make git-sync begin/end panic-safe so the syncing flag can't strand
priority: medium
comments:
- id: 01KY6ZYDX01J66T5XG9E1JD1WR
  author: Steve Vine
  at: 2026-07-23T08:02:21.215754Z
  text: |-
    Steve Vine · 2026-07-07:

    **Planned work (Claude, 2026-07-07):** exactly as the issue prescribes — an RAII scope guard around the sync cycle in `gitsync.rs` so the `end()` effect (syncing = false + notify) runs unconditionally, including on panic; a defensive `syncing = false` at the top of the worker loop as the belt-and-braces backstop; and poison-tolerant status locks (`lock().unwrap_or_else(|e| e.into_inner())`) so one panic can't break every later `git_sync_status` read. DoD covered by a test that injects a panic into a cycle and asserts the flag clears.
- id: 01KY6ZYMWEYN4JEAJ507ABKF4B
  author: Steve Vine
  at: 2026-07-23T08:02:28.366303Z
  text: |-
    Steve Vine · 2026-07-07:

    **Build complete — PR [#207](https://github.com/Steve-vine/notuvia/pull/207)**, single-file change in `gitsync.rs`, exactly per the issue's prescription:

    - `begin`/`end` replaced by an RAII `CycleGuard` — the end effect (refresh counts, `syncing = false`, notify) runs on drop, so no exit path can skip it. Both cycle functions share one guarded `run_cycle`.
    - `catch_unwind` inside `run_cycle` turns a panic into a recorded `last_error` ("sync cycle panicked: …") — the worker thread survives, so auto-sync/focus/Sync-now keep working with no git-sync toggle needed.
    - All status locks are poison-tolerant (`unwrap_or_else(|e| e.into_inner())`), so a panicked cycle can't break later `git_sync_status` reads.
    - Belt-and-braces: the idle worker loop clears a stranded flag defensively.

    **DoD met and tested:** `a_panicking_cycle_clears_the_flag_and_records_the_error` injects a `panic!` into a cycle and asserts the flag clears, the error is recorded, both notify edges fire, and a following clean cycle recovers; `lock_recovers_a_poisoned_status_mutex` proves the tolerant lock works through real poison. 222 backend tests pass, fmt/clippy clean.
label: null
task_status: done
assignee: steve
project: 01KY6W9951TW0904DT0GGJVGE7
number: 125
sprint: sx9znt9
---
Surfaced while fixing DEV-712 (network-hang). A **second**, independent way the "syncing" flag can get stuck on — not the cause of DEV-712, kept out of that PR per the brief discipline.

## Problem

In `gitsync.rs`, both `commit_and_push` (~:217) and `sync_full` (~:234) follow:

```
begin(status, notify);          // syncing = true
let result = (|| { ... })();    // sync work
end(vault, status, notify);     // syncing = false
```

`begin`/`end` are **not panic-safe**. If anything inside the closure panics (e.g. a `std::fs` write in `resolve_conflicts`, a `Note::parse`/`save`, or a poisoned-`Mutex` `.unwrap()`), `end()` is skipped, the worker thread dies, and `syncing` is left `true` with **no recovery** — the worker is gone, so neither the 180s auto-sync nor the flag-reset ever runs. Toggling git-sync off/on (which respawns the worker) is the only way out.

A poisoned `status` mutex compounds it: every later `status.lock().unwrap()` — including `status()` behind the `git_sync_status` command — then panics too.

## Fix

Make the flag reset unconditional:

* Wrap the cycle in a **scope guard** (RAII `Drop` that sets `syncing = false` + notifies), or `catch_unwind` around the closure, so `end()`'s effect runs even on panic.
* Consider resetting `syncing` defensively at the top of the worker loop as a belt-and-braces backstop.
* Optionally avoid `.unwrap()` on the status mutex (use `lock().unwrap_or_else(|e| e.into_inner())`) so one panic doesn't poison every later status read.

## DoD

A panic inside a sync cycle cannot leave `syncing` stuck true; the worker (or its flag) recovers without toggling git-sync off/on. Covered by a test that injects a panic into a cycle and asserts the flag clears.

---

Linear DEV-713 · Backlog · created 2026-06-29 · done 2026-07-07