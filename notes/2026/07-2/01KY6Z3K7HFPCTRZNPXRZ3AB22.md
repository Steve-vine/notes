---
id: 01KY6Z3K7HFPCTRZNPXRZ3AB22
created: 2026-07-23T07:47:41.937576Z
updated: 2026-07-23T09:16:53.007766Z
type: task
title: Auto-commit on change + manual "Sync now"
assignee: steve
label:
- brief
comments:
- id: 01KY6Z3VWKV3FX0SKZ96CMW5P9
  author: Steve Vine
  at: 2026-07-23T07:47:50.802932Z
  text: |-
    Steve Vine · 2026-06-24:

    Done — PR opened: https://github.com/Steve-vine/notula/pull/75

    **What was done**
    - New `gitsync` module: a debounced background committer thread. The runtime touches it after every write (note save/update, status/card moves, taxonomy persistence); it commits ~8s after the last edit, then pushes to origin if one exists. Manual "Sync now" commits + pushes immediately.
    - `git.rs` gained `commit_all` + `push` primitives; Settings → Storage gained a "Sync now" button + last-synced time + last-error display.
    - Commands `sync_now`, `git_sync_status`.

    **Decisions made on the fly**
    - **Commit vs push split** as the ADR calls for: commit on-change (debounced, local), push after commit + periodic retry on failure. Push failures are recorded as `last_error`, surfaced in the UI, and never block editing.
    - **Worker lifecycle owned by the runtime:** started on enable (live toggle) or resumed at startup from the persisted flag; on disable/relocate the `GitSync` is dropped, which **joins** the thread so an in-flight commit finishes and two committers never race. To make startup-resume clean, `start_runtime` took a `resume_git_sync` flag (true only from the setup path; `open_vault` passes false since a new vault starts git-off).
    - **Fallback commit identity** (`Notula <notula@localhost>`) injected via `-c` only when the machine has no `user.name`/`user.email` — a configured identity is respected.
    - **Touch points** are the 5 write chokepoints; bulk ops (value rename rewriting N notes) fire one touch and the single debounced `git add -A` captures everything.

    **Verification** — verbatim gates green locally: `npm run check` (0), `npm run build`, `npm test` (58), `cargo fmt --check`, `cargo clippy -D warnings`, `cargo test` (**81**, +8 new — incl. a bare-remote push test and a real debounced auto-commit test). `npm run tauri build` left to CI.

    **Scope boundary** — write side only. A push rejected because the remote is ahead surfaces as an error here; **pull + keep-both conflict resolution is DEV-615**, which makes that recoverable.

    Moving to In Review — merge call is yours.
task_status: done
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 79
sprint: stkh502
---
The write half of git-sync: commit local changes automatically and push on a gentle cadence (ADR 0013).

Commit and push are deliberately separate cadences — commit is local/cheap/frequent, push is batched/network.

## Sub-steps

- [ ] Debounced auto-commit (~5–10s after the last edit) via system `git add`/`commit`; sensible auto-generated commit messages.
- [ ] Push cadence: debounced/batched + periodic, only when an `origin` remote exists.
- [ ] Manual **"Sync now"** action (commit + push) in the UI.
- [ ] Push failures (offline, auth, rejected) surface clearly and never block editing; retry on next cadence.
- [ ] Commit only vault content (`taxonomies.yaml`, `notes/`, `attachments/`); never `.notula/`.

## Definition of done

Edits are committed locally without user action and pushed to the remote on cadence and on demand; failures are visible and non-blocking.

---

Linear DEV-614 · M10 — Sync · created 2026-06-24 · done 2026-06-25