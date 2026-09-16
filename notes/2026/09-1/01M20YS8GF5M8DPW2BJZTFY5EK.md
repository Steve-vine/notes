---
id: 01M20YS8GF5M8DPW2BJZTFY5EK
created: 2026-09-08T16:49:23.983462Z
updated: 2026-09-16T18:44:12.478214Z
type: task
title: When another process owns sync, the app says nothing — it just looks stopped
project: 01KY6W9951TW0904DT0GGJVGE7
number: 419
comments:
- id: 01M2N7C06RJ4AVDCKX55VRX3M7
  author: Steve Vine
  at: 2026-09-16T13:44:15.317505Z
  text: |-
    Done — PR #420 (`brief-419-sync-locked-by`).

    **All three agreed points are covered**, with the wording in one place (`src/lib/syncLock.ts`) so the surfaces can't drift:
    - **Sidebar pill** — "Synced elsewhere", muted with a hollow dot (deliberately *not* the error colour), disabled, reason in the tooltip.
    - **Alert card** — a second variant, "Sync is handled elsewhere". Not the "Sync failed" banner, per the constraint: its own title, its own copy, and its own dismissal key `locked:<pid>` since the existing key is the literal error string. It holds its dismissal rather than re-alerting every poll (the old `if (!last_error) dismissed = null` would have un-dismissed it on every 10s tick).
    - **Settings → Storage** — names the holder in place of "Last pushed …", and "Sync now" is disabled with the reason on the control rather than erroring on click.

    All three carry the reassurance that the edits still reach the remote, committed by the owning process on its next cycle. No timestamps are rendered while locked, per the second constraint.

    **One backend change was needed to make this honest.** `SyncStatus.locked_by` is an `Option<u32>` and the pid is unreadable in the window between another process taking the lock and stamping it — so "locked, pid unknown" and "sync is ours" were the same `null`. Branching on the pid would have left exactly the invisible state this task exists to fix. `SyncStatus` now carries `locked: bool` beside the pid; the UI branches on that and uses the pid only to name the holder. The NOT-417 test now asserts the flag on both the holder and the loser. This is the one thing that went beyond "the UI half" — flagging it because it's a (backward-compatible, additive) core change.

    **Verified visually**, as the task asked: rendered `SyncIndicator` + `SyncAlert` for real against a stubbed status and looked at four states — locked with a pid, locked without one, the existing failure case, light and dark. The failure path is visually unchanged. Screenshots shared in the session.

    `cargo fmt --check`, `clippy -D warnings`, `cargo test -p notuvia-core gitsync` (37), `npm run check`, `npm test` (329, +6 new). Still worth a pass in the real app via the repro in the description.
assignee: steve
label:
- bug
- follow_up
priority: medium
task_status: done
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
