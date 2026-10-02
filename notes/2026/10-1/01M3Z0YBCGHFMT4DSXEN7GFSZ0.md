---
id: 01M3Z0YBCGHFMT4DSXEN7GFSZ0
created: 2026-10-02T19:20:02.704052Z
updated: 2026-10-02T20:30:24.562334Z
type: task
title: CrossSync conflicts and safety UI
project: 01KY6W9951TW0904DT0GGJVGE7
number: 496
sprint: sx287fa
blocked_by:
- 01M3Z0XP26B0QDB85KD2T8VWDY
- 01M3Z0Y0N4TD1WRJ8X7MVAJ60F
comments:
- id: 01M3Z4Z63F37X6MYYHSR7JGNFY
  author: Steve Vine
  at: 2026-10-02T20:30:24.365173Z
  text: |-
    Built and merged (squash, PR #486), CI green. The branch is deleted.

    What landed:
    - Resolve panel: a conflicted row shows Resolve…, opening a line diff of the other version against this machine's file, with "Keep this machine's" and "Keep the other version".
    - xsync::resolve writes the chosen version to the local file and the vault copy, deletes the conflict copies, records the hash and commits. The losing version is saved to the previous versions first, whichever side it was on.
    - Previous versions: a history button on rows that have any; each backup shows its age and size with Restore. Restoring backs up the current file and syncs the restored one in.
    - Sync alert: a calm "CrossSync conflict" card with Open CrossSync. The sidebar sync indicator shows the same state.
    - Push protection: a flagged xsync/ path resolves to its entry; the alert names the file and offers Remove from CrossSync, with no encrypt-the-note advice for it.
    - The view warns when the vault's .gitignore excludes xsync/ (git check-ignore).

    Decided on the fly:
    - "The other version" is whichever of the vault copy and its conflict copies differs from this machine's file. That is right both on the machine that merged and on every other one, and for a folder-sync clash with no conflict copy.
    - Files that aren't UTF-8 or are over 512 KB can be resolved but show no diff.
    - The alert's conflict card yields to a sync failure and to "sync is handled elsewhere".
    - Entry rows carry a backups count so the history button only shows when there is something to restore.

    Verification: 8 new xsync tests and 2 new git-sync tests; 80 xsync and gitsync tests pass; npm test 516/516; fmt, clippy and npm run check clean. The resolve panel, ignore warning and previous-versions list were rendered in the UI lab. Not run in the Tauri app, and the sync alert's new variants were only typechecked, not rendered.
assignee: steve
label:
- feature
priority: medium
task_status: done
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