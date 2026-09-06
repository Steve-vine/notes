---
id: 01M1VXR15W5TVB1Z55WYYHYQKQ
created: 2026-09-06T17:55:02.972511Z
updated: 2026-09-06T19:31:26.078382Z
type: task
title: The list behind the list icon — everything everyone has suggested
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 601
sprint: scx5myr
blocked_by:
- 01M1VXQJNRF5WRYTNJ7RKDGHGN
comments:
- id: 01M1W38FZ2D9WRZHZ9GH8K0A1Y
  author: Steve Vine
  at: 2026-09-06T19:31:25.282339Z
  text: |-
    Done — PR #610 merged to main (7303e9d).

    - suggestions/SuggestionsList.tsx: the dialog's second view. Newest first; per row the title in full, a status pill, who wrote it and when (dimmed, small; a deleted author reads "Someone who has since left"), and the description under a three-line clamp that opens on click. EmptyState "No suggestions yet" with a line pointing back at the form. It scrolls inside the dialog.
    - statusColors.ts: new (neutral grey) and planned (blue); under_review, done and declined reuse the amber, teal and grey already there.
    - Tests assert the pill's resolved --badge-bg / --badge-color, not the prop (white text on the deep dark-mode fills, black on amber).

    Smoke-test: bulb → list icon → rows; click a long description to expand; back arrow returns to the form with anything typed still there. Try it in dark mode too — the pills should stay legible.
assignee: steve
label:
- feature
priority: medium
task_status: review
---
The list icon in the dialog's top-right corner turns the form into the list, and a back arrow in the same corner turns it back. One dialog, two views — not a second dialog on top of the first, and not a page: the reader opened this from wherever they were and should still be there when they close it.

## What it shows

Every suggestion anyone has made, newest first. Per row:

* the **title**, in full;
* the **status** as a pill — New, Under review, Planned, Done, Declined;
* **who** wrote it and **when**, dimmed and small;
* the **description**, expandable. A three-line clamp with the row opening on click, so twenty rows are still scannable but nothing is hidden behind another click-through.

Empty state: the `EmptyState` component, "No suggestions yet" and a line pointing back at the form.

## Status colours

Add the five to `statusColors.ts` rather than inlining them; Done green, Declined grey, Planned blue, Under review amber, New neutral. Per *Screen conventions* in `brief/information-architecture.md`, **a pill never truncates** — the container gives way, not the label. If a colour is set by name, give it a shade (`blue.6`, not `blue`), or Mantine's `autoContrast` silently does nothing and light-on-light happens in one theme only.

## Scrolling

The list scrolls **inside** the dialog, not the page — the same fix COM-596 made for the decision editor. A dialog whose body grows past the viewport takes its own header off screen with it.

## Tests

- [ ] The list icon shows the list; the back arrow returns to the form with anything already typed still in the fields.
- [ ] Rows render newest first, with author and status.
- [ ] The empty state renders when there are none.
- [ ] A pill's resolved colour is asserted, not the prop passed to it.

## Related

- COM-600 — the dialog this is a second view of. Blocked on it, and shares its file.
- COM-602 — editing a row, which lands on top of these rows.
