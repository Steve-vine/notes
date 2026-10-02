---
id: 01M3Z0Y0N4TD1WRJ8X7MVAJ60F
created: 2026-10-02T19:19:51.716861Z
updated: 2026-10-02T20:20:56.216415Z
type: task
title: 'CrossSync git-sync integration: pull notifications and keep-both conflicts'
project: 01KY6W9951TW0904DT0GGJVGE7
number: 495
sprint: sx287fa
blocked_by:
- 01M3Z0X0YPXCMK1VQ6APM9N45G
comments:
- id: 01M3Z4DV2V3F9WRRP6RCADVBX7
  author: Steve Vine
  at: 2026-10-02T20:20:56.024833Z
  text: |-
    Built and merged (squash, PR #485), CI green. The branch is deleted.

    What landed:
    - resolve_conflicts handles xsync/<id>/<file> before the "ours" fallback. Both sides edited: ours stays, theirs is written beside it as <filename>.conflict-<hash> and staged into the merge commit.
    - A conflict copy marks the entry as conflicted: xsync::sync copies nothing either way while one exists, and the list shows Conflict.
    - One side removed the entry and the other edited it: the edit is kept, and the files the merge deleted cleanly (usually meta.yaml) are restored from the surviving side.
    - meta.yaml conflicts merge key by key against the base; a key both changed keeps ours.
    - PullApplier fires a new on_xsync_pulled callback when a pull changed anything under xsync/. The app runs a CrossSync pass in response.
    - SyncStatus.xsync_conflicts counts entries with an unresolved copy, read from the vault so it clears when they are resolved.
    - New binary-safe git helpers: show_stage_bytes, file_bytes_at, tree_files.

    Decided on the fly:
    - The conflict copy's suffix is a hash of the remote content, not the remote commit as the task said, so resolving the same collision twice writes the same file.
    - The app's pull callback runs the pass on its own thread. The sync worker is joined under the runtime lock when git-sync is turned off, so waiting on that lock from the worker could deadlock.
    - GitSync::start and enable_git_sync keep their signatures and delegate to new _with_xsync variants, so the sidecar and the existing tests are untouched.

    Verification: 6 new git-sync tests over two clones of a bare remote, 3 new xsync tests; all 43 gitsync tests pass, fmt and clippy clean, npm run check 0 errors.

    Left as is: attachments and other non-note files still resolve to "ours" on a conflict.
assignee: steve
label:
- feature
priority: high
task_status: done
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