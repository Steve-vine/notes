---
id: 01KY6Z1WBZEE3A2ZYRTNPDZV3Z
created: 2026-07-23T07:46:45.759779Z
updated: 2026-07-23T09:08:57.411762Z
type: task
title: Land git-sync design — ADR 0013 + CLAUDE.md
comments:
- id: 01KY6Z22S4QMW3EMH79GPD1G3N
  author: Steve Vine
  at: 2026-07-23T07:46:52.323741Z
  text: |-
    Steve Vine · 2026-06-24:

    Done — PR opened: https://github.com/Steve-vine/notula/pull/72

    **What was done**
    - Wrote `decisions/0013-git-sync-optional-layer.md` (Accepted) capturing the full agreed design: relocatable user-owned vault; default bring-your-own file sync; opt-in git-sync mode only when the vault is a repo; shell out to system `git` with auth delegated to the OS; git wire protocol only (no REST API → no rate-limit concern); commit-on-change vs batched push; index stays local/gitignored; keep-both conflict resolution; per-note history/rollback; git-lfs deferred.
    - Updated `CLAUDE.md`: sync moved from "Still open" into the Locked list pointing at ADR 0013.

    **Decisions made on the fly**
    - The git mechanism fork (system `git` vs libgit2 vs gitoxide) was settled with you as **system `git`**; recorded in the ADR with a note to revisit a bundled lib only if wider distribution demands it.
    - ADR also notes the M11 (mobile) bearing — system `git` isn't available on iOS, so mobile sync can't reuse this directly; left uncommitted, consistent with the existing deferral.

    **Notes**
    - Docs-only change; CI's gates (check/build/test, cargo fmt/clippy/check/test, tauri build) don't inspect markdown, so no local CI run was meaningful. CI still runs on the PR.
    - The remaining M10 work is split into briefs DEV-612 through DEV-617.

    Moving to In Review — merge call is yours.
assignee: steve
label: chore
task_status: done
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 76
---
Commit the sync design decision so M10's code briefs have an authoritative reference.

`decisions/0013-git-sync-optional-layer.md` and the `CLAUDE.md` "Locked" line were drafted directly (per agreement). This chore lands them on `main` via PR.

## Sub-steps

- [ ] PR with ADR 0013 (`decisions/0013-git-sync-optional-layer.md`) + the `CLAUDE.md` edit closing the "Still open: sync mechanism" note.
- [ ] Verify the ADR captures: relocatable vault folder; default BYO file-sync; opt-in git-sync only when vault is a repo; shell out to system `git`; auth delegated to OS; no REST API; commit-on-change vs batched push; index stays gitignored/local; keep-both conflict resolution; per-note history/rollback; git-lfs deferred.

## Definition of done

ADR 0013 accepted and on `main`; `CLAUDE.md` no longer lists sync as open.

---

Linear DEV-611 · M10 — Sync · created 2026-06-24 · done 2026-06-24