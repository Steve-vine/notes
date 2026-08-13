---
id: 01KZK80PGZFNWAPP4KJCCDBVZ1
created: 2026-08-09T12:29:59.199353Z
updated: 2026-08-13T19:00:28.021526Z
type: task
title: Tab count badges on Discovered and Dismissed truncate to '8..' and '1..'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 626
sprint: sesjg7z
comments:
- id: 01KZKEYG3AB4AFXK1PCYC8GVG7
  author: Steve Vine
  at: 2026-08-09T14:31:07.114549Z
  text: |-
    BUILT 2026-08-09 — PR #570, `feature/ise-626-tab-count-badges`.

    **Both decisions taken:**

    - **`circle` dropped** on both badges. A pill sizes to its content and needs no width guessing.
    - **Thousands separator, yes.** `toLocaleString()`, which the record-range line on this same screen already uses — so the two numbers on the screen agree with each other.
    - **Cap: no.** The tab row reads fine at four figures, and `9,999+` would solve a problem nobody has. Left as noted rather than pre-empted.

    **How it is tested, which is the part worth reading.** jsdom does no layout, so it genuinely cannot see clipping — asserting "not truncated" would have been a test that passes on a broken screen. It asserts the two things that *caused* the clipping instead: the badge no longer carries `data-circle` (Mantine's `mod` output), and the full grouped number is rendered.

    It also waits for the counts to land before asserting. The tabs render immediately, badges and all, so every assertion would otherwise pass vacuously against a tab that has no badge yet — the same vacuous-pass trap as the ISE-629 table guard.
assignee: steve
label:
- bug
priority: medium
task_status: done
tech: null
---
Reported by Steve 2026-08-09 on the live Servers screen: the counts read `8..` and `1..` instead of the numbers.

**Cause.** Both badges in `ServersPage.tsx` are `<Badge size="sm" circle …>`. Mantine's `circle` prop forces a fixed circular badge — width equals height, padding zero — which fits one or two characters and clips anything longer. It was written when the queue held 51 rows and two digits was a safe assumption.

ISE-621 made that assumption wrong on the first deploy: Discovered now shows 1,164 and Dismissed grows every time somebody clears a page. So the one number that tells an operator whether a tab is worth opening is the one thing they cannot read.

**Fix.** Drop `circle` on both — a normal pill badge sizes to its content and needs no width guessing. Worth deciding at the same time:

- **Thousands separator.** `1164` reads as noise at badge size; `1,164` does not. The screen already uses `toLocaleString()` for the record-range line, so this would just be consistent.
- **A cap for very large counts.** If Dismissed can reach five figures, `9,999+` keeps the tab from stretching. Only worth doing if the tab row actually looks wrong at that width — do not solve it before it is a problem.

**Acceptance**: both badges show their full count at four figures without truncation, and the tab row still reads cleanly.