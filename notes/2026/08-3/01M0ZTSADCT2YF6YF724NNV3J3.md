---
id: 01M0ZTSADCT2YF6YF724NNV3J3
created: 2026-08-26T20:04:35.372487Z
updated: 2026-08-27T16:47:40.727431Z
type: task
title: The orange privilege pill is white-on-orange in dark mode — it needs black text
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 443
sprint: s5gwx0s
comments:
- id: 01M11RMM74GZ760X81K33AE0Z6
  author: Steve Vine
  at: 2026-08-27T14:05:33.284379Z
  text: |-
    Fixed and merged — PR #442.

    The trap worth recording: autoContrast alone does not fix this, and it fails silently. Mantine resolves a bare color="orange" through parseThemeColor without a colour scheme, so it falls back to "light" and always measures the light-mode shade — orange.7, luminance 0.29, too dark to take black text. The flag changes nothing in dark mode. I verified this: a version with autoContrast added and nothing else still renders white text.

    Naming the shade makes the measurement honest. orange.4 (luminance 0.50) is already what dark mode renders — it is the theme's primaryShade.dark — so the background is unchanged and only the text flips. The shield inherits the text colour via currentColor and darkens with it. Light mode keeps orange.7 and its white text, which was always fine.

    Folded the two call sites into one component at access/DirectoryRoleBadge.tsx: PrivilegeBadge (a named role someone holds) and DirectoryRoleBadge (the group summary, built on it, unchanged for its callers). The Account details copy had drifted into a bare Badge, so fixing DirectoryRoleBadge alone would have left it white. That also makes COM-445's "the pill becomes a link" one change rather than two.

    Tests assert the resolved text colour rather than the props — asserting autoContrast is set would pass while the pill stayed white. Confirmed both the original code and the autoContrast-only version fail with white text. Also covered: the shield inherits currentColor (a hard-coded fill would pass the colour assertions and still leave a white shield), and the null-roleNames state still reads as "unresolved" rather than "none".

    For smoke testing, with the theme toggled to dark: Account details on a user with a directory role, and Access Control > View Groups for a role-granting group. Both pills should read black-on-orange, shield included. Light mode should look exactly as before.
assignee: steve
company:
- moneypenny
label:
- bug
priority: medium
task_status: done
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