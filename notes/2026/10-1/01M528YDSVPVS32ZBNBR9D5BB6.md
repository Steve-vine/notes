---
id: 01M528YDSVPVS32ZBNBR9D5BB6
created: 2026-10-16T11:53:18.907845Z
updated: 2026-10-16T16:38:19.214562Z
type: task
title: Mermaid Diagram flicker
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1010
sprint: s2ufsxd
comments:
- id: 01M52N1NWPGBG6G8DQG77HJEZJ
  author: Steve Vine
  at: 2026-10-16T15:24:48.406064Z
  text: 'Done in PR #998 (main 9a505dc4). The cause: once a text diagram was drawn, it kept redrawing itself about three times a second for as long as the editor was open, and each redraw briefly added a hidden copy at the bottom of the page to measure it — so the page grew and shrank and the scroll bar came and went. Now a diagram is drawn only when its text changes (after a short pause in typing), and it''s measured in a hidden box off the page, so drawing never changes the page''s size. Test: main''s code drew the same diagram 4 times in 1.2 seconds; now once.'
assignee: steve
label:
- bug
priority: medium
task_status: done
---
Found in Steve's smoke test of sprint 71 (COM-994), 2026-10-16: "When adding a mermaid diagram into a section, the whole browser display area appears to flicker. This seems to be because the right hand scroll bar is constantly appearing and disappearing, even though the page content doesn't scroll off the bottom."

## What is wrong

Once a text diagram has been drawn, the editor keeps redrawing it, about three times a second, for as long as the page is open, even when nothing has changed. Each redraw briefly puts a hidden copy of the diagram at the bottom of the page to measure it, so the page grows and shrinks, and the scroll bar comes and goes. That's the flicker.

## What people see

- A diagram is drawn when its text changes (after a short pause in typing), and not otherwise. Nothing flickers while you type, or after you stop.
- Drawing a diagram never changes the page's size or its scroll bar.

## Technical

- `content/richtext/DiagramView.tsx`: the drawing effect lists `svg` in its dependencies, and every render makes a new SVG string (the id in it changes), so `setSvg` re-triggers the effect forever. Drop `svg` from the dependencies (track "drawn yet" in a ref), so it only redraws on a source/editability/selection change.
- `content/richtext/mermaid.ts`: give `mermaid.render` its own off-screen, fixed-position, hidden container, so its temporary measuring element never sits in the page flow. Empty it after each render.
- Test (Vitest, mermaid mocked): a diagram renders once for one source, not repeatedly; a source change renders again.

## Done when

- [ ] Adding or editing a text diagram doesn't make the page flicker, and the scroll bar stays put.
