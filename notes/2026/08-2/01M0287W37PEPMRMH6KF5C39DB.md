---
id: 01M0287W37PEPMRMH6KF5C39DB
created: 2026-08-15T08:22:30.759633Z
updated: 2026-08-15T17:17:18.08206Z
type: task
title: The answer jumps down the screen the moment it finishes rendering
project: 01KX671DATY39VW6GWK3M2T3DN
number: 730
sprint: sevhjex
comments:
- id: 01M02VJ1763ZXJWR3VT69QQ5CC
  author: Steve Vine
  at: 2026-08-15T14:00:06.630476Z
  text: |-
    Done — PR #679, merged to main 2026-08-15.

    **Measured in a headless-Chromium rig**, before and after `active` falls false:

    ```
    before settle: scrollTop=1020  scrollHeight=1688  spacer=600  question y=0
    after  settle: scrollTop=488   scrollHeight=1088  spacer=0    question y=532
    ```

    The question the operator was reading fell **532px down the screen**. With the fix it moves **0px** and the reservation shrinks 600 → 532 rather than to zero. Reverting the fix and re-running the rig reproduced the 532px drop exactly.

    **Your diagnosis was right about the effect but understated the cause.** The reservation was not merely *cleared* on settle — the element carrying it **unmounts**, because the tail wrapper renders only while `showPending || turn.status !== 'idle'`. So a min-height living on the tail could only ever vanish in one frame; that is why neither of your two shapes worked as written.

    So the first change is structural: the reserved room now lives in **its own always-mounted spacer after the tail**. That is what makes a gradual release possible at all.

    **Then "shrink to fit" — your first option — but computed against the scroll, not the content.** `release()` keeps exactly the height still holding the current scroll position up, never grows back within a turn, and melts to nothing as the reader scrolls up. A long answer needs none of it and the whole reservation goes at once.

    **Scroll compensation, your second option, cannot work.** The two states genuinely have different *maximum* scroll positions, so no same-frame `scrollTop` adjustment can hide the difference — you cannot both remove the room and keep the question at the top. Worth recording so it is not tried again.

    One arithmetic subtlety found while testing: the naive "how much is still needed" formula over-reserves at `scrollTop === 0`, because a feed too short to scroll needs no room at all to keep 0 a legal position. It now tests where the browser *would* clamp to.

    **On "this cannot be proven in vitest" — half right, and the half that is wrong is useful.** jsdom can never see the jump. But the decision the fix turns on is *arithmetic over geometry*, and geometry can be stubbed — so the guard tests the fix itself rather than a proxy, and both new tests fail against the old clear-to-null. That had its own trap: my first stub reported a `scrollHeight` that did not include the spacer's own contribution, so the release was being checked against a geometry the DOM could never have, and the test passed for the wrong reason. `relayout()` now models it, with a comment saying why.

    The rig (vite harness + dockerised playwright, per the recipe) was throwaway and is not committed.
assignee: steve
label:
- bug
priority: medium
task_status: done
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