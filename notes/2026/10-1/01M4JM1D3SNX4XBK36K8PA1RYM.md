---
id: 01M4JM1D3SNX4XBK36K8PA1RYM
created: 2026-10-10T09:59:19.929314Z
updated: 2026-10-10T10:34:24.461184Z
type: task
title: The other five request windows take the move window's layout
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 899
sprint: sme8esk
blocked_by:
- 01M4JM0ZMN04ZXGMZD88X47N2V
assignee: steve
priority: medium
task_status: active
---
## What Steve asked (2026-10-10)

"…then adapt the design for each of the other requests so that all 6 requests share the same design principles and layout." Follows COM-898 (the move window, and the shared pieces in `access/requestWindow.tsx`).

## The principles carried over

- A title with one line under it; the title bar and the buttons stay put, the middle scrolls.
- Numbered sections in outlined boxes, in the order the request is thought about: who → what changes → what is left alone → why.
- A summary on the right that says, in a few lines, what the request will do — and drops underneath in a narrow window.
- Changes read as "Adding" / "Removing" pills; what is left alone is folded away with a count.
- The expedited warning sits in the bottom bar beside the buttons.

## Each window

- **New joiner(s)** — "Create accounts for new starters, with their roles and details." One numbered section per joiner (roles first, then who they are), "Add another joiner" under them, then Justification. Summary: each joiner's name, primary role and where the account is created; how many additional roles.
- **Leaver** — "Disable a person's account and take away what their roles gave them." 1 Who is leaving · 2 What this removes (disabled, sessions revoked, managed memberships as Removing pills) · 3 What is left as it is (unmanaged groups, folded) · 4 When it runs (Run at, delete afterwards) · 5 Justification. Summary: the account, how many groups go, when it runs, whether it is deleted.
- **Change access** — "Add or remove groups and shared mailboxes for one or more people." 1 Who · 2 Groups (Joining, Leaving) · 3 Shared mailboxes (Gaining, Losing) · 4 Reason. Summary: how many people, +/− per kind.
- **Create a security group** — "Ask for a new security group, with a description and an owner." 1 The group · 2 Owner · 3 Business role (optional) · 4 Justification. Summary: name, owner, role.
- **Delete a group** — "Ask for a security group to be deleted." 1 Which group · 2 Justification. Summary: the group and how many members lose it.

## Decisions

- **Width**: new joiner, move, leaver and change access are the full 1180px; create and delete a group are the same layout at 920px — a one-box form does not need the full width.
- No change to what any request does or sends: no backend change, no migration, no ADR.

## Build

- `RaiseRequestModal.tsx`: every kind renders in `RequestWindow`; the old `Modal` path and `WIDE_KINDS` go.
- `JoinerBlocks.tsx`: each block becomes a `RequestSection`.
- New `RequestSummaries.tsx` (or beside each form) for the five summaries.

## Done when

- All six windows share the frame, the numbered sections, the summary and the bottom bar.
- Each still raises exactly the request it raised before (existing tests, updated only where they address the layout).
- Checked in a real browser at 1180 / 920 / narrow, light and dark.

## Smoke test (Steve — Safari)

Open each of the six from Access → Raise. For each: numbered boxes on the left, summary on the right that follows what you fill in, buttons fixed at the bottom; fill it in and submit one of each as before.