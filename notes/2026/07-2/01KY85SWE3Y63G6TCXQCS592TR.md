---
id: 01KY85SWE3Y63G6TCXQCS592TR
created: 2026-07-23T19:03:58.147815Z
updated: 2026-07-24T12:07:57.202097Z
type: task
title: Graph full-screen/popout height is guessed, not measured — ~10% dead strip below the canvas
project: 01KX671DATY39VW6GWK3M2T3DN
number: 237
sprint: s5khymf
comments:
- id: 01KY89Z21Z2HFZVD903CV00MMY
  author: Steve Vine
  at: 2026-07-23T20:16:42.047488Z
  text: |-
    Done on feature/ise-237-graph-flex-height (PR #220, stacked on #219).

    Replaced the viewport-arithmetic canvas height (calc(100vh - 210px)/140px) with real layout: the expanded modal (content + body via Modal styles) and the pop-out wrapper are full-height flex columns, the canvas sits in a flex:1; min-height:0 child, and EntityGraphView takes height:100% to measure against that sized parent. The canvas now fills exactly what the header/toolbar/breadcrumb leave — no ~10% dead strip, and no scrollbar when the toolbar wraps or the breadcrumb appears. In-page card keeps its fixed 480px.

    Frontend-only, no API. Pixel fill isn't assertable in jsdom so this leans on staging smoke for the visual (no dead strip, no scrollbar with breadcrumb + wrapped toolbar); the height-prop plumbing goes through tsc + the existing render path. Full suite (374) + build + lint green.
assignee: steve
priority: medium
task_status: done
---
Report (Steve, 2026-07-23): the graph's full-screen mode leaves an empty section at the bottom, about 10% of the screen.

Cause: the canvas height is hard-coded viewport arithmetic, not layout. `EstateGraphPanel.tsx` sets `canvasHeight = expanded ? 'calc(100vh - 210px)' : popout ? 'calc(100vh - 140px)' : 480`. The expanded modal's actual chrome (modal padding + header row + toolbar) is ~110px, so ~100px of the 210px allowance is dead space under the canvas — ~9% of a 1080p screen.

The guess also fails the other way: chrome height isn't constant. A narrow window wraps the toolbar to two lines, and re-rooting (ISE-232) adds the breadcrumb row — real chrome then exceeds the allowance and the canvas overflows the viewport with a scrollbar instead. The popout variant has the same fragility with a closer guess (140px).

Fix (frontend-only, no API):
- Make the expanded modal body and the popout wrapper a full-height flex column; canvas container gets `flex: 1; min-height: 0` so it fills exactly what the header/toolbar/breadcrumb leave — no magic numbers.
- `EntityGraphView` already takes a `height` prop — let it accept `100%` inside a sized parent (React Flow needs a definite-height container; verify it measures correctly on modal open and window resize).
- In-page card variant keeps its fixed 480px.

Test: hard to assert pixel fill in jsdom — cover the prop plumbing (canvas receives 100% in expanded/popout, 480 in card) and rely on staging smoke for the visual: no dead strip, no scrollbar with breadcrumb visible + wrapped toolbar.

Independent of ISE-233/234/235/236 but touches the same panel file — stack anywhere in the batch.

Done when: expanded and popout canvases reach the bottom of the viewport at any window size, with and without the breadcrumb, with no vertical scrollbar.