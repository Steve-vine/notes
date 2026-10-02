---
id: 01M3Z0XP26B0QDB85KD2T8VWDY
created: 2026-10-02T19:19:40.870068Z
updated: 2026-10-02T19:20:15.679704Z
type: task
title: 'CrossSync automatic sync: watch originals and the xsync folder'
project: 01KY6W9951TW0904DT0GGJVGE7
number: 494
sprint: sx287fa
blocked_by:
- 01M3Z0X0YPXCMK1VQ6APM9N45G
- 01M3Z0XBM7CANBGJJNTJS1X2VG
assignee: steve
label:
- feature
priority: medium
task_status: backlog
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