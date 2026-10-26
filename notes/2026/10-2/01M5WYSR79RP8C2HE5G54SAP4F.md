---
id: 01M5WYSR79RP8C2HE5G54SAP4F
created: 2026-10-26T20:35:29.641201Z
updated: 2026-10-26T22:10:07.335071Z
type: task
title: With the Polaris window open, the left-hand menu makes room for it — you can scroll to its last item, as the page already can
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1339
sprint: s4zhkvy
assignee: steve
label:
- bug
priority: medium
task_status: active
---
## What Steve saw

With the Polaris window open over part of the screen, he couldn't scroll to the bottom of the left-hand menu. Its last items stay hidden behind the window.

## Cause

When the window opens it publishes its height (`--polaris-height`, set in `PolarisWindow.tsx`). The page content uses that height as bottom padding (`ShellFrame.tsx`), so the page can scroll clear of the window. The left-hand menu (`SidebarNav.tsx`: `AppShell.Navbar` with a `ScrollArea` section) doesn't, so its scroll ends behind the window.

## Behaviour

- **The menu scrolls clear of the window:**
  - With the window open, you can scroll the menu until its last item sits just above the window's drag bar.
  - Anything pinned at the bottom of the menu is lifted above the window too, rather than covered.
- **Resizing the window adjusts the room as you drag.** Closing the window gives the space back.
- **On a phone-width screen**, the menu drawer behaves the same.
- The vendor portal and the trust centre have no Polaris, so they don't change.

## Notes for the build

- Apply `paddingBottom: 'var(--polaris-height, 0px)'` to the navbar, `AppShell.Navbar` in `SidebarNav`/`ShellFrame`, so that the whole navbar, including any footer section, sits above the window and the `ScrollArea` section shrinks to fit.
  - The scroll section alone would leave a footer covered.
- Check the collapsed (icon-only) menu, and the mobile drawer (Burger).
- Tests:
  - vitest that the navbar carries the variable as its bottom padding;
  - a real-browser look, because jsdom has no layout. Use the headless Chromium harness, or Steve's smoke test.
- Independent: no API change and no migration. It can merge whenever it's green.