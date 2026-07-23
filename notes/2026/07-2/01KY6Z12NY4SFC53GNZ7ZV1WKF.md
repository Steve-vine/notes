---
id: 01KY6Z12NY4SFC53GNZ7ZV1WKF
created: 2026-07-23T07:46:19.454093Z
updated: 2026-07-23T11:00:29.728544Z
type: task
title: 'Search results: keyboard navigation'
comments:
- id: 01KY6Z18FFPXXB0H5TT78SZ6YZ
  author: Steve Vine
  at: 2026-07-23T07:46:25.390631Z
  text: |-
    Steve Vine · 2026-07-06:

    **Planned work (Claude, 2026-07-06):** all in `SearchSection.svelte` — a keyboard-highlight index driven from the search input's `onkeydown` (focus never leaves the box): Down/Up move the highlight through the results and **clamp** at the ends (the issue allowed wrap or clamp); Enter opens the highlighted hit via the existing `onOpenNote`, or the **top hit** when nothing is highlighted yet (quick-open idiom); Escape drops the highlight. The highlight resets when the query changes (live search), the row scrolls into view (`scrollIntoView({block:"nearest"})`), and it's styled distinctly from the existing `lastOpened` tint (inset accent bar). Handled keys stop propagation so the pane keymap is untouched. One branch + PR.
- id: 01KY6Z1E19MMSA05B4X4XAFQPM
  author: Steve Vine
  at: 2026-07-23T07:46:31.081237Z
  text: |-
    Steve Vine · 2026-07-06:

    **Build complete — PR [#199](https://github.com/Steve-vine/notuvia/pull/199)**, branch `steve/dev-609-search-results-keyboard-navigation`.

    All in `SearchSection.svelte` (47 lines): Down/Up move a highlight through the hits without leaving the search box, clamped at the ends and scrolled into view; Enter opens the highlighted hit — or the **top hit** when none is highlighted (type → Enter → done); Escape drops the highlight; the highlight resets on every new result set so it tracks live search. Keymap-safe: Alt/Cmd/Ctrl-modified keys pass through untouched (Alt+arrows still move pane focus), and only handled keys stop propagation. The keyboard highlight is an inset accent bar + hover wash, distinct from the last-opened tint.

    svelte-check clean, 129 tests pass, build OK. Manual pass: arrows/Enter/Escape in the search box, plain-Enter-opens-top-hit, and Alt+arrows still switching panes.
imported_from: null
task_status: done
assignee: steve
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 75
sprint: sx9znt9
label: null
---
Follow-up idea from M9. Let the user drive search entirely from the keyboard without leaving the search box:

* Up/Down arrows move a highlighted selection through the results list.
* Enter opens the highlighted result into the active pane.
* Selection visible/scrolled into view; wraps or clamps at the ends.
* Plays nicely with the existing live-as-you-type search and the pane keymap.

Parked backlog idea — not scheduled. Polish on top of the M9 search work.

---

Linear DEV-609 · Backlog · created 2026-06-24 · done 2026-07-06