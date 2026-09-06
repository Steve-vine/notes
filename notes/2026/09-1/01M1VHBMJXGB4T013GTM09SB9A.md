---
id: 01M1VHBMJXGB4T013GTM09SB9A
created: 2026-09-06T14:18:33.9496Z
updated: 2026-09-06T14:18:55.685708Z
type: task
title: in light mode the calendar icon in a date field is invisible — native controls follow the OS, not the app
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 586
sprint: s2fcksg
assignee: steve
label:
- bug
priority: medium
task_status: backlog
---
With Compass in light mode, the calendar button in a date field is missing — actually drawn, but white on a white field. Every `<input type="date">` in the app is affected (18 of them: gaps, risks, decisions, content, recerts, vendor assessments, the report wizard).

## Why

`src/index.css` opens with:

```css
:root {
  color-scheme: light dark;
}
```

It is imported after `@mantine/core/styles.css` in `main.tsx`, and both declarations sit at the same specificity, so ours wins over Mantine's `color-scheme: var(--mantine-color-scheme)` — the one that tracks the scheme the user actually chose.

The result: every browser-drawn control follows the **operating system's** preference rather than Compass's. On an OS set to dark with Compass in light, Chrome paints the calendar picker indicator white. Not just the icon — scrollbars, native dropdown menus and autofill highlighting are all wrong whenever the two disagree, in both directions.

## Fix

- [ ] Delete the `:root { color-scheme: light dark }` block from `src/index.css`. Mantine already sets the property from the active scheme; nothing replaces it.
- [ ] Check the toggle both ways with the OS set the opposite way — the icon, the scrollbars, and a native `select`.

Cheap and self-contained; worth landing on its own rather than riding along with the light-mode surface work.

## Related

- COM-587 — panels have no surface colour of their own in light mode. Same testing session, same scheme, but that one is a design change.
