---
id: 01M20YS8GF5M8DPW2BJZTFY5EK
created: 2026-09-08T16:49:23.983462Z
updated: 2026-09-08T16:49:39.228371Z
type: task
title: When another process owns sync, the app says nothing — it just looks stopped
project: 01KY6W9951TW0904DT0GGJVGE7
number: 419
assignee: steve
label:
- bug
- follow_up
priority: medium
task_status: todo
tech:
- svelte
- git-sync
---
The UI half of ADR 0059, deliberately left out of NOT-417 (shipped in 0.24.0)
because it wants a visual check rather than a guess.

Since 0.24.0 a git-sync worker must hold the vault's advisory lock, and the rule
is symmetric — the app takes it on the same terms as the sidecar. So if a
`notuvia-mcp --git-sync` process started first, the app runs no worker at all.
Before, both ran.

The backend reports this honestly. `SyncStatus.locked_by` carries the holder's
pid, and `vault.ts` mirrors it as `locked_by: number | null`. Nothing reads it.
So in the app the state is invisible: the sync pill never lights, timestamps
never move, "Sync now" returns an error naming the owner but only if you press
it. Sync looks broken rather than delegated.

ADR 0059 names this as a known consequence of what shipped. This task closes it.

## Agreed work

- [ ] Surface `locked_by` where the user already looks for sync state:
      `SyncAlert.svelte` (bottom-right card) and/or the Settings → Storage sync
      panel, which already renders `last_pushed` and friends.
- [ ] Copy should say sync is being handled elsewhere, not that it failed —
      including that the user's edits still reach the remote, committed by the
      owning process on its next cycle. Name the pid.
- [ ] Sync-state affordances that can't work while locked out ("Sync now")
      should say why rather than erroring on click.

## Constraints worth knowing before starting

- **Don't reuse the "Sync failed" banner.** `SyncAlert` is keyed off
  `last_error` and titled "Sync failed"; this isn't a failure and mislabelling
  it as one is worse than saying nothing. It needs its own variant — and its
  own dismissal key, since `dismissed` is currently compared against the exact
  error string.
- Nothing else in `SyncStatus` moves while `locked_by` is set, so any panel
  that renders timestamps needs to not read as "last synced eight hours ago"
  when the truth is "another process is syncing this, fine, right now".
- The condition is easy to reproduce by hand: run
  `notuvia-mcp --vault <vault> --git-sync` in a terminal, then start the app on
  the same vault. The app loses. `<vault>/.notuvia/git-sync.lock` holds the
  winner's pid.

## Why it isn't urgent

It only bites where the app and a sidecar share one vault — a configuration
ADR 0036 already discouraged and ADR 0059 doesn't recommend. The headless box,
which is what all of this came from, has no app on it at all.
