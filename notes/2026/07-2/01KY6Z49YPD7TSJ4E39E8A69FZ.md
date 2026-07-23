---
id: 01KY6Z49YPD7TSJ4E39E8A69FZ
created: 2026-07-23T07:48:05.207007Z
updated: 2026-07-23T12:24:56.89558Z
type: task
title: Fetch/pull + keep-both conflict resolution
label: null
assignee: steve
comments:
- id: 01KY6Z4KW7G9YHN6PA6PVEPS2Q
  author: Steve Vine
  at: 2026-07-23T07:48:15.367093Z
  text: |-
    Steve Vine · 2026-06-25:

    Done — PR opened: https://github.com/Steve-vine/notula/pull/76

    **What was done**
    - Worker now pulls (fetch + merge) on the interval, on window focus, and on manual Sync now — full commit → pull → push. The debounced edit path stays commit + push and self-heals by pulling only if a push is rejected.
    - Keep-both conflict resolution: same-note conflict keeps the local edit under its id and writes the remote version as a fresh sibling "conflict copy" (`rekey_as_conflict_copy`: new id, marked title, `conflict_of`). Merge failures abort cleanly.
    - `git.rs` fetch/behind/merge/stage primitives; `request_sync` command; window-focus listener; Settings → Storage lists conflict copies.

    **Dependency check (the one ADR 0013 flagged)** — Verified the M2 file-watcher in `watcher.rs` before relying on it: it watches `notes/` + vault root, reconciles every changed path, and fires the note/taxonomy reload callbacks. A `git pull` writes under `notes/`/`taxonomies.yaml`, so pulled changes reindex like any external edit. **No gap — no follow-up needed.**

    **Decisions made on the fly**
    - **Cheap edit path vs proactive pull:** debounced edits don't fetch (that'd be a network round-trip every time you pause typing); fetch happens on interval/focus/manual, and the edit path only pulls when a push is rejected. Keeps editing snappy while staying current.
    - **Conflict copy as a real note** (new id, `conflict_of`, marked title) so it's searchable/browsable immediately via the watcher — rather than a bespoke store. Count + titles surface in Settings and ride `git_sync_status` for DEV-616.
    - **Abort on unexpected merge failure** so the repo is never left mid-merge.

    **Verification** — verbatim gates green: check (0), build, npm test (58), fmt, clippy, **cargo test 83** (+2 — incl. an end-to-end two-clone keep-both conflict test: two repos diverge on one note, B pulls, B's edit preserved, A's becomes a conflict copy). `npm run tauri build` left to CI.

    **Known limitation (candidate follow-up)** — a conflict on a non-note file (e.g. `taxonomies.yaml`) is resolved keep-ours with no sibling copy, so the remote change to that file isn't merged. Rare; flagged for a future pass. Happy to file it as a `follow-up` if you want it tracked.

    Moving to In Review — merge call is yours. This is the last big technical brief; DEV-616 (status indicator) and DEV-617 (history/rollback) are lighter UI work on top.
task_status: done
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 80
sprint: stkh502
---
The read half of git-sync: detect remote changes, pull them, and resolve conflicts without losing data (ADR 0013).

## Sub-steps

- [ ] Fetch/check on app focus + on an interval + via manual Sync now; detect when local is behind.
- [ ] Pull remote changes; pulled file changes must flow through the existing file-watcher → incremental reindex. **Verify the M2 file-watcher / incremental reconcile actually exists and is reliable** before relying on it (named dependency in ADR 0013); if not, scope the gap as a follow-up.
- [ ] Conflict resolution = **keep both, never lose data**: auto-merge non-overlapping changes; on a true same-note conflict, keep local and write the remote version as a sibling conflict-note.
- [ ] Surface conflict-notes in the UI so the user can reconcile and delete the loser.

## Definition of done

Remote changes are pulled and reindexed automatically; same-note conflicts produce a sibling conflict-note (no data loss) and are visible for reconciliation.

---

Linear DEV-615 · M10 — Sync · created 2026-06-24 · done 2026-06-25