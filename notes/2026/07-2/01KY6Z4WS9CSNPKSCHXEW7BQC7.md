---
id: 01KY6Z4WS9CSNPKSCHXEW7BQC7
created: 2026-07-23T07:48:24.489129Z
updated: 2026-07-23T09:16:54.873379Z
type: task
title: Sync status indicator
task_status: done
assignee: steve
comments:
- id: 01KY6Z533MGAEBZF5NK9CD3T77
  author: Steve Vine
  at: 2026-07-23T07:48:30.963707Z
  text: |-
    Steve Vine · 2026-06-25:

    Done — PR opened: https://github.com/Steve-vine/notula/pull/77

    **What was done**
    - New `SyncIndicator` component in the sidebar footer (next to the settings cog). Polls status every 10s and derives a single state — syncing / error / conflicts / unpushed / behind / synced — as a colour-coded dot + label. Tooltip shows last-synced time or the error; clicking runs Sync now. Hidden when git-sync is off.
    - Backend: added `ahead`/`behind` counts + a `syncing` flag to `SyncStatus`, refreshed by the worker each cycle; `git.rs` gained `ahead_count`.

    **Decisions made on the fly**
    - **State priority** is syncing → error → conflicts → unpushed → behind → synced, so the most actionable condition wins.
    - **Counts maintained by the worker** (not recomputed per poll) so `git_sync_status` stays an in-memory read — the indicator polls cheaply. `ahead` is exact; `behind` reflects the last fetch (refreshes on the interval/focus pull).
    - No remote configured → ahead/behind are 0, so a local-only git vault reads "Synced" once committed.

    **Verification** — verbatim gates green: check (0), build, npm test (58), fmt, clippy, cargo test (83). No new automated tests — it's presentational + trivial status fields, and the worker logic is covered by DEV-614/615. `npm run tauri build` left to CI.

    Moving to In Review — merge call is yours. Last brief left in M10 is DEV-617 (per-note history & rollback).
- id: 01KY6Z57DV6SC4BYVW20GV17JX
  author: Steve Vine
  at: 2026-07-23T07:48:35.3866Z
  text: |-
    Steve Vine · 2026-06-25:

    Revised per review (same PR #77): simplified the indicator so it reads **"Sync"** always and conveys state by colour — it **lights up** (accent + pulsing dot) while a sync is actually running and turns **red** on failure (error or unreviewed conflicts), neutral at rest. The ahead/behind counts and last-synced time moved into the tooltip rather than the label.
- id: 01KY6Z5BFQ82RFZYKCVKSPTGRG
  author: Steve Vine
  at: 2026-07-23T07:48:39.543039Z
  text: |-
    Steve Vine · 2026-06-25:

    Bug fix (same PR #77): the indicator wasn't lighting up on each sync because it **polled every 10s** while a sync cycle finishes in under a second — the poll almost always missed the `syncing` window (you'd see the timestamp move but no light).

    Fixed by making it **event-driven**: the worker fires an `on_change` callback at the start and end of every cycle, which emits a `git-sync-changed` event; the indicator listens and lights up immediately, holding the lit state ~900ms so even a sub-second sync is visible. The 10s poll stays only as a freshness fallback for error/conflict/count state.
label:
- brief
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 81
sprint: stkh502
---
A small, always-visible read-out of git-sync state so the user trusts what's happening (ADR 0013).

## Sub-steps

- [ ] Indicator showing state: clean / committing / ahead (unpushed) / behind (unpulled) / syncing / conflict / error / offline.
- [ ] Show last-synced time and surface the most recent error on demand.
- [ ] Hook the manual "Sync now" action off the indicator.
- [ ] Hidden or shown-as-off when git-sync mode is disabled.

## Definition of done

The user can tell at a glance whether the vault is in sync, ahead/behind, conflicted, or errored, and can trigger a sync from it.

---

Linear DEV-616 · M10 — Sync · created 2026-06-24 · done 2026-06-25