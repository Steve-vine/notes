---
id: 01KYS790QQTQ3BPPT3NY57166E
created: 2026-07-30T09:56:47.991892Z
updated: 2026-07-30T13:00:48.305244Z
type: task
title: Intermittent bug
project: 01KY6W9951TW0904DT0GGJVGE7
number: 381
order: 1.5
sprint: segj1dz
comments:
- id: 01KYSHSY9H66CQ7JJJT84FG06A
  author: Steve Vine
  at: 2026-07-30T13:00:48.304872Z
  text: |-
    Diagnosed and fixed: PR #372 (branch not-381-card-revert).

    Cause found: board moves are self-write-suppressed (no watcher echo), so if the moved card had an open buffer — which happens whenever you click a card before dragging it, because the properties panel holds its doc — that buffer silently kept the OLD status. Its next full-replace flush (deselecting the card, or any properties edit) wrote the old status back: the card "drifted home" a few seconds later. Your click-select → drag → next-card rhythm reverts them one by one — matching your report exactly. This is also the same root mechanism as the sticky-encryption wipe (NOT-375), just via a different flush path.

    Fix: after a board move, any live buffer for that note now catches up explicitly (clean → reload; dirty → the changed-on-disk guard). Also added a stale-response guard to the board fetch, so rapid moves can't have an older snapshot visually snap cards back.

    Between this and PR #367 the revert should be gone; a live soak (click a card, drag it, click the next, repeat) is the real test since it was timing-dependent.
assignee: steve
label:
- bug
priority: medium
task_status: review
---
There is an intermittent bug that causes cards to move back to the previous column a few seconds after moving them.  I’ve been unable to determine the exact actions required top replicate this, but usually I’ll move 3 or 4 cards from one column to another, then notice one has moved back to where it was, then another.  I doesn’t happen every time I move something but often enough to be noticeable.