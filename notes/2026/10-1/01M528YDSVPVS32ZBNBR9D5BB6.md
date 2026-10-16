---
id: 01M528YDSVPVS32ZBNBR9D5BB6
created: 2026-10-16T11:53:18.907845Z
updated: 2026-10-16T15:01:52.561311Z
type: task
title: Mermaid Diagram flicker
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1010
sprint: s2ufsxd
assignee: steve
label:
- bug
priority: medium
task_status: active
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
