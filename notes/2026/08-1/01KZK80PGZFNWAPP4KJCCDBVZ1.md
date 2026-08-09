---
id: 01KZK80PGZFNWAPP4KJCCDBVZ1
created: 2026-08-09T12:29:59.199353Z
updated: 2026-08-09T12:30:14.159615Z
type: task
title: Tab count badges on Discovered and Dismissed truncate to '8..' and '1..'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 626
sprint: sesjg7z
assignee: steve
label:
- bug
priority: medium
task_status: todo
---
Reported by Steve 2026-08-09 on the live Servers screen: the counts read `8..` and `1..` instead of the numbers.

**Cause.** Both badges in `ServersPage.tsx` are `<Badge size="sm" circle …>`. Mantine's `circle` prop forces a fixed circular badge — width equals height, padding zero — which fits one or two characters and clips anything longer. It was written when the queue held 51 rows and two digits was a safe assumption.

ISE-621 made that assumption wrong on the first deploy: Discovered now shows 1,164 and Dismissed grows every time somebody clears a page. So the one number that tells an operator whether a tab is worth opening is the one thing they cannot read.

**Fix.** Drop `circle` on both — a normal pill badge sizes to its content and needs no width guessing. Worth deciding at the same time:

- **Thousands separator.** `1164` reads as noise at badge size; `1,164` does not. The screen already uses `toLocaleString()` for the record-range line, so this would just be consistent.
- **A cap for very large counts.** If Dismissed can reach five figures, `9,999+` keeps the tab from stretching. Only worth doing if the tab row actually looks wrong at that width — do not solve it before it is a problem.

**Acceptance**: both badges show their full count at four figures without truncation, and the tab row still reads cleanly.