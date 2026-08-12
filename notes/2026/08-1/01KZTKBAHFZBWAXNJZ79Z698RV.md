---
id: 01KZTKBAHFZBWAXNJZ79Z698RV
created: 2026-08-12T09:02:42.735568Z
updated: 2026-08-12T15:46:05.081206Z
type: task
title: New dictionary key bug
project: 01KX671DATY39VW6GWK3M2T3DN
number: 659
comments:
- id: 01KZVADKA9GN36S4JPP5CPGJZ6
  author: Steve Vine
  at: 2026-08-12T15:45:54.505839Z
  text: |-
    Fixed in PR #619 (commit 7b3764b), merged to main.

    Cause: the key modal is rendered unconditionally so it can animate shut, and it was keyed only on the row being edited (`editing?.id ?? 'new'`). Closing it only flips `opened` — the component instance is never unmounted, so its `useState` draft survives, and the `useState` initialiser never runs again. The next 'New key' therefore reused the previous draft. A page refresh cleared it because that remounted everything.

    Fix: a `session` counter incremented on every open, folded into the modal's React key. Each open mounts a fresh instance with a freshly initialised draft, while the modal stays mounted long enough to animate closed.

    Same fault applied to editing an existing key — cancel a change to `env` and re-open it and you saw the abandoned draft rather than the stored row. That is fixed by the same change.

    Tests: two in `TagDictionary.test.tsx` (a second 'New key' opens blank; a cancelled edit does not persist into the next open). Both verified failing before the fix.
assignee: steve
label:
- bug
priority: medium
task_status: review
---
In the tag dictionary when clicking ‘New key’ to add a new key, a blank form is provided in the modal and a new key is created. If ‘New key’ is clicked a second time, the modal is already populated with the previously entered details. Refreshing the page does clear this, and the modal is blank again.