---
id: 01M3Z0XP26B0QDB85KD2T8VWDY
created: 2026-10-02T19:19:40.870068Z
updated: 2026-10-02T20:13:11.429815Z
type: task
title: 'CrossSync automatic sync: watch originals and the xsync folder'
project: 01KY6W9951TW0904DT0GGJVGE7
number: 494
sprint: sx287fa
blocked_by:
- 01M3Z0X0YPXCMK1VQ6APM9N45G
- 01M3Z0XBM7CANBGJJNTJS1X2VG
comments:
- id: 01M3Z3ZN6B2JS01FJ51C2DS0CS
  author: Steve Vine
  at: 2026-10-02T20:13:11.241572Z
  text: |-
    Built and merged (squash, PR #484), CI green. The branch is deleted.

    What landed:
    - New xsync_watch module: one debounced watcher over <vault>/xsync/ (recursive) and the parent folder of each linked original (non-recursive, filtered to the linked filenames). A symlinked dotfile's real target is watched too.
    - The watcher only reports that something changed. The app then runs xsync_sync_all, so the three-way rule decides what to copy and CrossSync's own copies lead to a pass that does nothing.
    - A pass runs on startup and when a vault is opened (enable_xsync_watch in start_runtime, after git-sync resumes), on window focus (request_sync), and on a watcher event. Each pass emits xsync-changed; the CrossSync view listens for it.
    - Copy-in touches git-sync, so it commits on the 4s debounce. Add, link, unlink and remove refresh the watched folders.
    - The MCP sidecar never enables the watcher.

    Decided on the fly:
    - Access events are ignored: a sync pass reads every file, and on platforms that report reads that would loop.
    - A whole pass (every linked file) runs per event batch, not just the affected entry. It is a handful of small hashes and keeps one code path.
    - The view's own focus refresh was replaced by the xsync-changed listener.
    - ADR 0067 gained a "When the rule runs" section. It adds detail only.

    Verification: 6 new watcher tests against the real filesystem (atomic save caught twice, unrelated file ignored, copy-out once with a backup then quiet, copy-in once, re-link moves the watch, conflict left alone). cargo test --workspace passes (458 core), fmt and clippy clean, npm test 513/513. Not run in the Tauri app.
assignee: steve
label:
- feature
priority: medium
task_status: done
tech: null
---
So that a change to a synced file on either side is picked up without pressing Sync. Builds on the core engine and the rail view.

## Agreed work

- [ ] Watch each linked original with `notify-debouncer-full`, as the vault watcher does. Watch the **parent folder** non-recursively and filter to the linked filenames, because editors that save atomically replace the file and kill a watch placed on it. One watch per distinct parent folder; watches are added and dropped as files are linked, unlinked and removed.
- [ ] Watch `<vault>/xsync/` recursively, so vault-side changes from a folder-sync app (Dropbox, iCloud) or a git pull are noticed.
- [ ] Every event just runs the engine's sync decision for the affected entry. The last-synced hash makes CrossSync's own copies a no-op, so copy-out followed by the original's watcher firing can't loop. A test proves this in both directions.
- [ ] Full check of every entry on startup, on window focus, and when the vault is switched.
- [ ] After a copy-in, call the runtime's `git_touch()` so the change is committed on the 4s debounce, not left for the 180s interval.
- [ ] Vault-side changes copy out automatically only for files already linked on this machine; the overwritten version is saved to `.notuvia/xsync-backups/<id>/` first, keeping the last few per file.
- [ ] Emit an `xsync-changed` event so the CrossSync view updates its statuses live.
- [ ] Conflicts are detected and shown as a status but not resolved here (see the conflicts task): neither file is overwritten.
- [ ] Tests: atomic-replace saves are caught, an unrelated file in the same parent folder is ignored, loop suppression, and the backup before an automatic copy-out.

## Notes

The watchers live with the vault runtime (`VaultRuntime::start`) so they stop and restart with it. The headless MCP sidecar does not run CrossSync: it syncs `xsync/` through git but never copies files out (ADR 0036).