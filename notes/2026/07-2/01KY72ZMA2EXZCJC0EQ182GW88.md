---
id: 01KY72ZMA2EXZCJC0EQ182GW88
created: 2026-07-23T08:55:26.274126Z
updated: 2026-07-23T12:25:00.39793Z
type: task
title: 'git-sync: concurrent task creation mints project conflict copies (next_task_number)'
number: 331
assignee: steve
label: null
task_status: done
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
---
Two machines creating tasks in the same project between syncs reliably duplicate the project note.

## Incident (2026-07-14 ~19:34)

Three "ISE (conflict copy)" project notes were created within ~40 seconds by three consecutive git-sync merges. Each merge conflicted on the ISE project note, and the two sides differed **only** in:

* `next_task_number` (e.g. ours 67 / theirs 69 — both machines were allocating Sprint 7 task numbers concurrently)
* `updated`

The bodies, sprints, dates, and taxonomy values were byte-identical. The conflict policy materialised the losing side as a full conflict-copy note each time → three duplicate projects. An earlier incident (2026-07-12) did the same to a task note (ISE-14), where the copy ended up the only surviving record.

(Vault has been cleaned up by hand: copies trashed, ISE-14 retitled.)

## Root cause

The sync merge treats every frontmatter difference as a content conflict. `next_task_number` and `updated` are counters/clocks with an obvious automatic resolution — they should never trigger a conflict copy on their own.

## Proposed fix

Field-aware merge in notuvia-core's git-sync conflict handling, before falling back to the conflict-copy path:

* `next_task_number`: take **max** of the two sides (allocation-safe: numbers already handed out on either side stay below it; a same-number collision would already have happened pre-merge and is a separate, rarer race)
* `updated`: take max
* If, after resolving those fields, the two sides are identical → no conflict copy at all (today's case)
* Only a residual body/metadata difference should still mint a conflict copy

Worth a look at the same time: whether task-number collision (both machines allocating the same `number` from the same counter) needs a repair pass on merge — today's incident happened to heal (counter 73, max used 72, no duplicate numbers), but that looks like luck, not design.

---

Linear DEV-984 · created 2026-07-14 · done 2026-07-14