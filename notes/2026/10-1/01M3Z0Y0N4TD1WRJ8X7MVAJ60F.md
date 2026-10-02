---
id: 01M3Z0Y0N4TD1WRJ8X7MVAJ60F
created: 2026-10-02T19:19:51.716861Z
updated: 2026-10-02T19:20:16.59242Z
type: task
title: 'CrossSync git-sync integration: pull notifications and keep-both conflicts'
project: 01KY6W9951TW0904DT0GGJVGE7
number: 495
sprint: sx287fa
blocked_by:
- 01M3Z0X0YPXCMK1VQ6APM9N45G
assignee: steve
label:
- feature
priority: high
task_status: backlog
tech: null
---
So that CrossSync files are safe under git sync. Today a pull that conflicts on any non-note file keeps the local version and throws the remote edit away (`checkout_ours` in `gitsync.rs`), which would silently lose one machine's change to a synced file. Builds on the core engine.

## Agreed work

- [ ] In `resolve_conflicts`, handle paths under `xsync/` before the "ours" fallback: keep the local version as the file, and write the remote version beside it as `xsync/<id>/<filename>.conflict-<short-remote-commit>`. Nothing is discarded (ADR 0013's "never lose data").
- [ ] A conflict on `meta.yaml` takes the remote version if only one side changed a given key, else keeps ours; it is small, rarely edited metadata.
- [ ] Delete/modify conflicts under `xsync/` (one machine removed the entry, the other edited it) resolve to keeping the edited file.
- [ ] The conflict copy is a normal vault file, so it is committed and reaches every machine. The engine reports an entry with a `.conflict-*` sibling as "conflict" and does not copy it out until it is resolved.
- [ ] `PullApplier` passes the pulled paths under `xsync/` to a new callback, and the app runs the CrossSync check for those entries straight after a pull instead of waiting on the folder watcher.
- [ ] `SyncStatus` carries CrossSync conflicts separately from note conflict copies, since `ConflictCopy` identifies notes by id.
- [ ] Tests against throwaway git repos (git spawned via `git::command()`): both sides edit the same file, edit versus remove, a clean fast-forward of an `xsync/` file, and that note conflict handling is unchanged.

## Notes

Attachments and other non-note files keep today's "ours" behaviour; changing that is out of scope here. The resolution UI is the conflicts and safety task.