---
id: 01M5WYNSXWBDC984PDDWP698B0
created: 2026-10-26T20:33:20.316831Z
updated: 2026-10-26T20:33:22.444037Z
type: task
title: When Polaris changes something, the page behind its window updates at once — a DDQ's answer count and progress bar move as each answer is saved, without navigating away and back
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1338
sprint: s4zhkvy
assignee: steve
label:
- bug
priority: high
task_status: todo
---
## What Steve saw

He had Polaris answer questions on a DDQ. The answer count and the progress bar didn't change; he had to navigate away and back to see them.

## Cause

The Polaris window refreshes only its own data when a turn moves on: the conversation list, the conversation and its status (`PolarisChatProvider.tsx`). Nothing tells the page underneath that Polaris has changed something, so the page keeps showing what it loaded before. This isn't specific to DDQs: any page that Polaris changes stays stale.

## Behaviour

- **After each change Polaris makes, the page behind the window refreshes what it shows.** This happens as each change lands, not only when Polaris finishes the turn. That covers:
  - the DDQ's answer count, progress bar, question list and statuses;
  - an open question;
  - the review cards;
  - the same on every other page Polaris can change things on: risks, gaps, incidents and so on.
- **Reading doesn't cause a refresh.** Only changes do, so asking questions doesn't make the page flicker.
- **What you're typing is safe.** If you're halfway through editing an answer and Polaris changes a different question, your form isn't reset. If Polaris changes the very question you have open, the form takes on the new version, as it does today when a new version is saved.
- **A change you allowed on its Allow / Deny card** refreshes the page the same way once it's made.

## Notes for the build

- **Backend:**
  - Add a field to the `activity` event saying whether the step was a change, e.g. `changed: true` when the tool isn't read-only and finished without error.
  - The engine already knows read-only from the registry.
  - This is an API change, so regenerate schema.d.ts. No migration is needed.
- **Frontend (`PolarisChatProvider`):**
  - On an activity event with `status: 'done'` and `changed`, call `qc.invalidateQueries({ predicate: q => !isPolarisKey(q.queryKey), refetchType: 'active' })`.
    - This refetches only the queries the page is showing.
    - Debounce it (around 300 ms), so a run of saves refetches once rather than once per save.
  - Also invalidate once on `done` if any change happened in the turn, as a backstop.
  - Use a broad invalidation rather than a map from tool name to query keys. A map would drift as tools are added, and refetching only active queries is cheap.
- **Form safety:**
  - Check `AnswerForm`: it is keyed on the answer id, so a new version re-mounts it. That's correct only for the question Polaris changed.
  - Confirm that a refetch of other questions doesn't re-key the open form.
- **Tests:**
  - a vitest test that an activity `done` + `changed` event invalidates active non-Polaris queries;
  - a read-only step doesn't;
  - the debounce collapses a burst of saves;
  - a backend test that the `activity` event carries `changed` correctly for a read tool, a write tool and an errored write.