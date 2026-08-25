---
id: 01KZ5RFR1XV98DT7A4A0QABTXN
created: 2026-08-04T06:48:27.453962Z
updated: 2026-08-25T09:01:11.580933Z
type: task
title: Syncing of task status
project: 01KY6W9951TW0904DT0GGJVGE7
number: 387
sprint: segj1dz
comments:
- id: 01KZ8B8V0JXW2B18HKKKFV9RMQ
  author: Steve Vine
  at: 2026-08-05T06:55:12.909286Z
  text: |-
    Done on branch not-387-sync-status-reindex — PR #379 (commit 5f53cb0).

    Cause: pulled changes only reached the index via the file-watcher. A pull that lands a lot of files at once can collapse into a pathless "rescan this directory" signal from the OS that carries no per-file paths, so those notes stayed stale in the index — cards sitting in their old columns. That also explains why Sync now didn't help (the pull had already happened, so there was nothing left to pull) and only a restart did (start-up rebuilds the index from the files).

    Fix: the pull now reconciles what it changed itself rather than depending on the watcher noticing. pull_remote records HEAD before the merge and diffs it against the new HEAD (plus any conflict copies, which the merge commit doesn't carry), and the sync worker reconciles those note paths through its own index connection — same arrangement the watcher uses, WAL so it never blocks reads, opened lazily so a push-only vault pays nothing. The reconciled ids are then emitted as note-changed, the signal the board/search/open panes already refresh on, so a pull updates the UI live without a manual re-select. Runs outside the sync cycle and unconditionally, so a cycle that pulls and then fails to push still lands those notes. Headless notuvia-mcp gets the reconcile too.

    Verified: new two-peer test with no watcher running (only the pull path can update the index) — confirmed it fails without the fix. cargo test --workspace 429 pass; fmt + clippy -D warnings clean.

    Testing note: this prevents the drift rather than repairing an index that already drifted, so the shape to check is — leave this build running here, do a batch of status changes on the other laptop, and the cards should land in the right columns here without a restart. Moving to Review.
- id: 01KZ8DV58MWF97S6HP9NJJGMDF
  author: Steve Vine
  at: 2026-08-05T07:40:10.386215Z
  text: 'Shipped: PR #379, released in 0.14.0. Moving to Done.'
assignee: steve
label: null
priority: medium
task_status: done
---
Sometimes if Notuvia is left running on one laptop and I do a lot of work on another one, when I come back, the last statuses haven’t all been updated and cards appear in the wrong columns in the planner. Manually clicking sync doesn’t help, I have to close and reopen Notuvia, at which point they appear in the right place.