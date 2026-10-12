---
id: 01M4QTEJNRY5HH5A8B48VFTHK5
created: 2026-10-12T10:27:35.225213Z
updated: 2026-10-12T12:13:27.619125Z
type: task
title: Move window management icons
project: 01KY6W9951TW0904DT0GGJVGE7
number: 538
sprint: sd52non
comments:
- id: 01M4R0DV3PSWDVDQ8AZ6RF4CN9
  author: Steve Vine
  at: 2026-10-12T12:12:02.549358Z
  text: |-
    Done on brief-538-fullscreen-chrome, PR #530 (squash `fb5a2cc`).

    In fullscreen the tab strip now reserves a band at its top (growing by it, so
    the 28px tabs keep their size) and drops the traffic-light gutter from 88px to
    the normal 10px. The revealed native title bar lands on empty chrome, every
    tab stays visible and clickable, and the tabs no longer start past a hole.
    Windowed is untouched.

    Decisions made on the fly:

    - **A standing band, not a hover-reactive one.** I looked at detecting the
      reveal (pointer at the screen's top edge) and insetting only while it shows.
      Rejected: the reveal can't be detected reliably from the web side, and tabs
      sliding up and down as the pointer brushed the top edge would be worse than
      the problem. ~28px of a full-screen height, never moving, is the better
      trade.
    - **The band is one token** (`--fs-reveal-band` in `theme.css`) rather than a
      number buried in the component, so a future macOS drawing a taller bar is a
      one-line correction.
    - **macOS only.** Windows and Linux keep their chrome when maximised, so
      there's nothing to dodge — the class is `isMac && isFullscreen()`.
    - **The store degrades to "windowed"** outside a Tauri window. `getCurrentWindow()`
      throws in a plain browser, which would have failed module load for a `npm run
      dev` in a browser or any test importing it; wrapped so it can't.
    - Tauri has no fullscreen event, so the state is re-read on window resize —
      entering or leaving fullscreen always resizes.

    Problems:

    - **28px is unverified on screen.** It's the standard NSWindow title-bar
      height, but screen capture isn't available to me, so I couldn't measure the
      revealed bar. If it still clips the tabs, or leaves more space than needed,
      that one token is the fix.
    - Entering/leaving fullscreen isn't exercised by hand either — the logic is
      simple but it wants your eyes.

    Not done, and worth knowing: the note pop-out windows have ordinary native
    decorations and no custom chrome, so they were left alone. Full local pre-push
    gate green including the cargo jobs; CI green.
assignee: steve
label:
- improvement
priority: medium
task_status: done
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
buttons still hide in fullscreen, which is the OS's rule, not ours.

- [x] Track the window's fullscreen state in the frontend
      (`fullscreen.svelte.ts`, re-read on window resize — Tauri has no
      fullscreen event) and put it on the tab strip as a class.
- [x] In fullscreen, the strip reserves the reveal band at its top, growing by
      it so the 28px tabs keep their size; the band carries the strip's own
      `--chrome`, so it reads as a slightly taller top bar.
- [x] In fullscreen, drop the 88px traffic-light gutter back to 10px.
- [x] Both revert on leaving fullscreen; macOS only.
- [x] `brief/ui.md`: the fullscreen chrome documented on the Tabs section.

Deliberately **not** an inset that appears and disappears with the hover: the
reveal can't be detected reliably from the web side, and tabs sliding about as
the pointer brushes the top edge would be worse than the problem.

## Verification

- [x] Windowed is untouched (the rule is `.strip.mac.fullscreen` only).
- [ ] **Needs Steve's eyes:** the band height. `--fs-reveal-band: 28px` is the
      standard NSWindow title-bar height but was never measured on screen —
      screen capture isn't available to Claude. If the revealed bar still
      clips the tabs, or leaves more room than it needs, that one token in
      `theme.css` is the correction.
- [ ] **Needs Steve's eyes:** entering and leaving fullscreen flips between
      the two layouts without a reload.

Out of scope: making the green button fill-as-a-window instead of entering
fullscreen (considered and rejected — it would keep the buttons visible but
cost native fullscreen and its Mission Control space), drawing our own window
buttons, and the note pop-out windows, which have ordinary native decorations
and no custom chrome to cover.

Shipped in PR #530 (squash `fb5a2cc`).
