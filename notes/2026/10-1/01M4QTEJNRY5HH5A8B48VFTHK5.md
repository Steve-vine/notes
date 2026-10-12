---
id: 01M4QTEJNRY5HH5A8B48VFTHK5
created: 2026-10-12T10:27:35.225213Z
updated: 2026-10-12T11:39:17.312829Z
type: task
title: Move window management icons
project: 01KY6W9951TW0904DT0GGJVGE7
number: 538
sprint: sd52non
assignee: steve
label:
- improvement
priority: medium
task_status: active
tech:
- svelte
---
On the Mac, when the window is maximised the Close, minimise, maximise buttons move off the window and instead only appear when the pointer is moved to the top of the screen where they appear on a separate menu that appears at the top and covers the top tabs.
On other Mac native applications like Safari, the three buttons stay on the main menu bar, can this be done on Notuvia?

## What's actually happening

`tauri.conf.json` sets `titleBarStyle: "Overlay"` with `hiddenTitle: true` and
puts the native traffic lights at x14/y21 — floating over our own 42px tab
strip, which reserves an 88px left gutter for them. In **native macOS
fullscreen** the OS withdraws the title bar altogether: the lights go with it,
the 88px gutter becomes dead space, and hovering the top edge slides the native
bar back in *over* the tab strip.

An app cannot keep native traffic lights visible in fullscreen — macOS owns
that. Safari behaves as described when *zoomed* (filling the screen as a
window), not in true fullscreen.

## Agreed approach (Steve's call)

Keep native fullscreen working; stop the reveal covering anything. The three
buttons will still hide in fullscreen, which is the OS's rule, not ours.

- [ ] Track the window's fullscreen state in the frontend and put it on the
      app shell as a class, so the chrome can react in CSS.
- [ ] In fullscreen, the tab strip reserves the reveal band at its top (the
      native bar's height) so the tabs sit below it — the revealed bar lands on
      empty chrome instead of over the tabs. The band carries the strip's own
      `--chrome` background, so it reads as a slightly taller top bar rather
      than a gap.
- [ ] In fullscreen, drop the 88px traffic-light gutter back to the normal
      10px — there are no lights to dodge, so the tabs start at the left edge
      like every other row.
- [ ] Both revert on leaving fullscreen.
- [ ] `brief/ui.md`: a line on the fullscreen chrome.

Deliberately **not** a fixed inset that appears and disappears with the hover:
the reveal can't be detected reliably from the web side, and tabs sliding up
and down as the pointer brushes the top edge would be worse than the problem.
A permanent band in fullscreen is ~28px of a full-screen height and never
moves.

## Verification

- Fullscreen: hovering the top reveals the native bar over empty chrome; every
  tab stays visible and clickable.
- Fullscreen: no 88px hole at the left of the tab strip.
- Windowed: completely unchanged — lights at x14/y21 over the strip, 88px
  gutter.
- Entering and leaving fullscreen flips between the two without a reload.

Out of scope: making the green button fill-as-a-window instead of entering
fullscreen (considered and rejected — it would keep the buttons visible but
cost native fullscreen and its Mission Control space), and drawing our own
window buttons in fullscreen.
