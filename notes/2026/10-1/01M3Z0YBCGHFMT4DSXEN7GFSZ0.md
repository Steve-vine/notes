---
id: 01M3Z0YBCGHFMT4DSXEN7GFSZ0
created: 2026-10-02T19:20:02.704052Z
updated: 2026-10-02T19:20:17.569485Z
type: task
title: CrossSync conflicts and safety UI
project: 01KY6W9951TW0904DT0GGJVGE7
number: 496
sprint: sx287fa
blocked_by:
- 01M3Z0XP26B0QDB85KD2T8VWDY
- 01M3Z0Y0N4TD1WRJ8X7MVAJ60F
assignee: steve
label:
- feature
priority: medium
task_status: backlog
tech: null
---
So that a clash between two machines' edits can be seen and settled in the app, and an unwanted overwrite can be undone. Builds on the automatic-sync and git-sync integration tasks.

## Agreed work

- [ ] A conflicted entry in the CrossSync view opens a resolve panel showing the two versions as a line diff: this machine's file against the other version (the vault copy, or the `.conflict-*` copy a pull left).
- [ ] Actions: Keep mine, Keep theirs. Either writes the chosen content to both the local file and the vault copy, deletes the `.conflict-*` copy, records the new hash, and triggers a git commit. The losing version goes to `.notuvia/xsync-backups/<id>/` first.
- [ ] A conflict resolved on one machine clears on the others when the deleted conflict copy syncs.
- [ ] Backups: a per-file "Previous versions" list from `.notuvia/xsync-backups/<id>/` with date and a Restore action (restoring is itself a local change, so it syncs out as normal).
- [ ] Sync alerts: CrossSync conflicts appear in `SyncAlert` / `SyncIndicator` with a link to the CrossSync view.
- [ ] Push protection: when GitHub rejects a push because of a secret in an `xsync/` file (ADR 0043), the alert names the file and offers "Remove from CrossSync" in place of the note-only "encrypt" option. It must not show the encrypt-the-note advice for a file.
- [ ] Warn in the view when the vault's `.gitignore` excludes `xsync/` content, since those files would quietly never sync.
- [ ] Tests: both resolutions, the backup written before each, restore, and the blocked-push alert for a file path.

## Notes

No merge editor in v1: it's one whole version or the other, with the loser kept as a backup. A visual pass needs Steve (no screen capture).