---
id: 01M0287W37PEPMRMH6KF5C39DB
created: 2026-08-15T08:22:30.759633Z
updated: 2026-08-15T08:38:12.484378Z
type: task
title: The answer jumps down the screen the moment it finishes rendering
project: 01KX671DATY39VW6GWK3M2T3DN
number: 730
sprint: sevhjex
assignee: steve
label:
- bug
priority: medium
task_status: todo
tech: null
---
Ask a question on an incident: the question anchors to the top of the viewport and the answer streams in below it, correctly. The instant the answer finishes, the whole thing **drops down to the bottom of the screen**. Jarring if you were reading as it rendered — the paragraph you were on moves out from under you. Reported 2026-08-15.

**Cause.** `useQuestionAnchor` (`lib/useQuestionAnchor.ts`) reserves one full viewport of room below the question — `anchorMinHeight = el.clientHeight` — so the scroll target is reachable at all. Without it the browser clamps `scrollTop` at `scrollHeight - clientHeight` and the question stays pinned to the bottom, which is the bug the hook exists to fix (ISE-558).

The reservation is then dropped in a single frame when the turn settles:

```tsx
useEffect(() => {
  if (!active) {
    anchored.current = false
    setAnchorMinHeight(null)
  }
}, [active])
```

Clearing it collapses the spacer, `scrollHeight` shrinks, the browser re-clamps `scrollTop`, and everything below jumps up — which the reader experiences as the answer dropping.

**It cannot simply be left in place.** The reservation must go, or every settled turn leaves a viewport of dead whitespace at the end of the conversation and the next `anchor()` measures against a stale spacer. The requirement is to release it **without moving what the reader is looking at**.

**Two workable shapes**
- **Shrink to fit, not to zero** — on settle, set the min-height to the tail's actual rendered height rather than `null`. It stops being a spacer and nothing reflows, because the content is already that tall. Simpler, and no frame-timing risk.
- **Compensate the scroll** — measure `scrollHeight` before and after the clear and adjust `scrollTop` by the difference within the same frame.

Also worth holding the release until the reader is idle or has scrolled themselves, so it never fires mid-read even if the reflow is perfect.

**This cannot be proven in vitest.** jsdom does no layout — `clientHeight` and `scrollHeight` are always 0 — so no unit test can see the clamp or the jump. The hook's own docstring says exactly this about the original bug: *"jsdom does no layout, so no unit test can catch that clamp — hence the loud contract."* Prove it in the Playwright rig with an answer long enough to actually scroll, or it will regress unnoticed. See [[ise-graph-canvas-measurement-trap]] for the same trap on the graph canvas.

Related: the scroll-anchor min-height trap from Sprint 50 (ISE-557..562) — same hook, opposite end of its lifecycle.