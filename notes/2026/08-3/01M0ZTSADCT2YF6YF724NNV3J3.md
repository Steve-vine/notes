---
id: 01M0ZTSADCT2YF6YF724NNV3J3
created: 2026-08-26T20:04:35.372487Z
updated: 2026-08-26T20:04:39.583839Z
type: task
title: The orange privilege pill is white-on-orange in dark mode — it needs black text
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 443
sprint: s5gwx0s
assignee: steve
company:
- moneypenny
label:
- bug
priority: medium
task_status: backlog
---
The orange shield pill that marks directory-role privilege renders white text on orange in dark mode, which is hard to read. It shows the role name on the Account details modal ("Compliance Administrator") and marks role-granting groups on the groups list.

It is the one pill in the app that exists to say *this is privileged* — the one that most needs to be readable at a glance.

## What changes for the reader

**Black text on the orange pill in dark mode.** The shield icon darkens with it. Light mode is fine and stays as it is.

## Scope

Two call sites render the same pill independently, and both need it:

- `access/UserDetailModal.tsx:77` — one badge per directory role name, on Account details.
- `access/GroupDetailModal.tsx:51` (`DirectoryRoleBadge`) — the "Grants Entra directory roles" badge, used on the groups list (`GroupsPage.tsx:218`) and in the group modal.

Both are a bare `<Badge color="orange" variant="filled">` with no contrast handling, so Mantine picks its own foreground and lands on white.

`StatusPill` already solved exactly this, for exactly this reason (DEV-730): in dark mode it renders filled with `autoContrast`, which chooses black or white from the background's luminance. Reach for that here rather than hard-coding a colour, so the pill stays right if the orange is ever retuned. Check the result against the actual shade — `autoContrast` only gives black text if the orange is light enough, and the answer wanted here is black.

Fold the two into one component while in there. `DirectoryRoleBadge` is already exported and already the shared privilege badge; the Account details one is a copy of it that drifted. One component means the next screen showing a directory role cannot get this wrong again — the outcome COM-441 is asking for in general.

## Tests

`theme.test.tsx` is the precedent for asserting a scheme-dependent style. Worth a test that the pill resolves to dark text in dark mode, but the real check is looking at Account details and the groups list with the theme toggled.