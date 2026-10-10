---
id: 01M4JM1D3SNX4XBK36K8PA1RYM
created: 2026-10-10T09:59:19.929314Z
updated: 2026-10-10T11:35:08.886183Z
type: task
title: The other five request windows take the move window's layout
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 899
sprint: sme8esk
blocked_by:
- 01M4JM0ZMN04ZXGMZD88X47N2V
comments:
- id: 01M4JPK0WJSESR5YR3WFTN3TTF
  author: Steve Vine
  at: 2026-10-10T10:43:54.386052Z
  text: |-
    Done 2026-10-10 — PR #885, merged to main as 10d4e638. Not on staging yet (waiting for Steve's say-so).

    What landed
    - All six requests are raised in the same window (access/requestWindow.tsx): title + one line, numbered sections, summary on the right, expedited warning and buttons in a fixed bottom bar. The old Modal path is gone.
    - New joiner(s): a numbered section per joiner with Clear / Reset / remove beside its heading; fields as many to a row as fit. Summary: each joiner's name, primary role, where the account is created, how many additional roles.
    - Leaver: Who is leaving · What this removes (role-given groups as Removing pills) · Access this leaves as it is ("Other groups", folded, with a count — was one run-on line) · When it runs · Justification. Summary: account, when it runs, kept or deleted after, −N managed groups, N other groups unchanged.
    - Change access: Who it is for · Groups (Joining | Leaving) · Shared mailboxes (Gaining | Losing) · Reason. Summary: people, +/− per kind.
    - Create a security group: The group · Who owns it · Business role · Justification. Delete a group: Which group · Justification. Both at 920px; the other four at 1180px.
    - The layout is written into brief/information-architecture.md → Screen conventions, including why a request window is the one place a title has a line under it.

    Decisions
    - "Submit expedited" is a plain text button in every window, as the design has it (it was red-outlined).
    - A leaver's "Other groups" pills are plain — no box. Say if they should open like a mover's.
    - The summary for a new group shows the owner's name only once they've been picked from a search in this window.

    Checked
    - vitest src/access + screen-conventions: 45 files, 637 tests; new RequestWindows.test.tsx (what all six share; leaver; change access; both group windows). One unrelated DevicesPage test flaked under load locally and passes alone; CI green.
    - Headless Chromium, dark and light: all six windows.
    - eslint, tsc -b, prettier, semgrep clean.

    Not checked: Safari; the real estate's data; submitting each kind end to end against the real directory (nothing about what is sent changed, and the existing tests that assert each request's payload still pass).

    Next: COM-896 (Escape closes the popup, not the window) and COM-897 (ask before discarding) now build on this window — one place to do each.
- id: 01M4JSGVAPK897B5FQX4310EEK
  author: Steve Vine
  at: 2026-10-10T11:35:08.885756Z
  text: On staging 2026-10-10 (dd049cdb, image staging-20261010-1133). "Submit expedited" is red-outlined again (COM-900).
assignee: steve
priority: medium
task_status: review
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