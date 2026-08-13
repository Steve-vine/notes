---
id: 01KZTSNXN29HDDN3WN8CS2KRRC
created: 2026-08-12T10:53:21.442071Z
updated: 2026-08-13T19:00:08.029712Z
type: task
title: Tag Dictionary - Standard Values
project: 01KX671DATY39VW6GWK3M2T3DN
number: 661
comments:
- id: 01KZVADSANQGW4C3ZD3ZQN9VTN
  author: Steve Vine
  at: 2026-08-12T15:46:00.660999Z
  text: |-
    Fixed in PR #620 (commit 23f1655), merged to main. Stacked on #619 (ISE-659) — both touch `TagDictionaryCard.tsx`.

    Cause: the modal, and the `ValueEditor` inside it, were handed `editing` — the `TagKey` object captured into state at the moment the Edit button was clicked. 'Add' POSTs the value and invalidates the `tag-dictionary` query, so the table behind the modal updated, but the frozen snapshot the modal renders from was never re-read. Closing and re-opening worked because that took a new snapshot from the refreshed list.

    Fix: derive the row from the live query data each render — `keys.find((k) => k.id === editing.id) ?? editing`. The fallback to the snapshot keeps the modal's identity (title, and the create-vs-edit branch) if the row disappears from the dictionary while it is open. The draft for the key's own fields still initialises once on mount, so a refetch cannot clobber an unsaved edit to the name or description.

    Test: `a standard value shows up in the open modal that added it` — the fetch stub appends the POSTed value to the row it serves, and the test asserts the value appears without the modal being closed. Verified failing before the fix.
assignee: steve
label:
- bug
priority: medium
task_status: done
tech: null
---
When adding a standard value to a tag in the tag dictionary, after filling in the fields and clicking ‘Add’ the new values don’t appear on the modal. You have to close and re-open it to see them.