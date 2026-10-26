---
id: 01M5VNKKW7C21XYT18NXG6VFND
created: 2026-10-26T08:35:36.967035Z
updated: 2026-10-26T12:02:20.03132Z
type: task
title: The Polaris button and window — a north-star button beside your initials; a full-width window slides up over the page, resizes from a grip at its top middle, and stays open as you move around Compass
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1332
sprint: s9ls6e7
blocked_by:
- 01M5VNJ79TGJJBDA8YQAQGZREK
comments:
- id: 01M5W1E3DJY1RBRNBARTK6W6JS
  author: Steve Vine
  at: 2026-10-26T12:02:19.186201Z
  text: |-
    Done — merged to main (PR #1349).

    - **The Polaris button** sits left of your initials, with a north-star symbol drawn for Compass.
      - It shows only with Use Polaris and while Polaris is switched on, and updates as soon as an administrator switches it.
      - The tooltip reads "Polaris", and the button looks pressed while the window is open.
    - **The window** is full width and slides up over the page, starting at a quarter of the screen.
      - It stays open, at the same height, as you move between pages.
      - It never appears in the portals.
    - **The grip** at its top middle drags it up to just below the top bar, or down until only the grip shows.
      - Double-click collapses it, or restores the last height.
      - From the keyboard: arrow keys, PageUp/PageDown, Home and End.
      - Esc closes it while you're in it.
    - **The page stays usable.** You can scroll, click and type behind the window. The page gains space at its foot as tall as the window, so its last rows always scroll into view above it.
    - **Whether it was open, and how tall**, is remembered per browser.

    My calls (beyond the task):
    - **The window sits above modals but below menus.** So a DDQ's question window behind it stays reachable ("draft this one"), but the Polaris window covers the bottom of a modal until you shrink it.
    - **Esc only closes it while focus is inside it**, so Esc on the page or in a modal still belongs to the page.
    - **Full width means the whole screen**, so it covers the bottom of the sidebar too.
    - **Mouse-drag resizing can't be tested automatically.** Please try it during your smoke test.
assignee: steve
label:
- feature
priority: high
task_status: review
---
## Behaviour

- **The button.**
  - It sits in the top bar, to the left of your initials, with the Polaris symbol: a four-pointed north star drawn to sit with the Compass mark.
  - Only people who hold *Use Polaris* see it, and only while Polaris is switched on.
  - The tooltip reads "Polaris". The button looks pressed while the window is open.
- **Opening.**
  - Clicking it slides a full-width window up from the bottom of the screen, over the page.
  - It starts at a quarter of the screen's height.
  - Clicking the button again (or the window's ✕) slides it away.
- **The page stays usable.**
  - You can scroll the page behind the window, and click and type on it.
  - The page gains space at its foot as tall as the window, so its last rows can always be scrolled into view above it.
- **Resizing.**
  - A grip at the top middle of the window can be dragged up as far as the top bar, or down until only the grip bar is showing.
  - Double-clicking the grip toggles between that and the last height.
- **It follows you.** Moving to another page keeps the window open, at the same height, in the same conversation.
- **It remembers.** Whether it was open, and how tall, is kept for you in this browser.
- **The inside of the window:**
  - a **status bar** across the top, for context (filled in the context-bar task);
  - the **conversation**, which scrolls;
  - the **prompt box** at the foot.

  This task builds the frame; the conversation task fills it.
- It works in light and dark, and from the keyboard: the button is focusable, the grip can be moved with the arrow keys, and Esc closes the window.

## My calls (awaiting Steve)

- I draw the north-star symbol, unless you have one.
- Esc closes the window.
- Double-clicking the grip collapses or restores it.
- The open/closed state and height are per browser, not saved to your account.

## Notes

- **Independent** of migrations, but needs the `polaris.use` permission and the "Polaris on" flag from the Admin task in schema.d.ts. Branch after that task merges.
- Mount it once in `AppLayout`, not per page, so it survives navigation. Not in `PortalLayout`.
- The foot padding comes from a CSS variable set on the scroll container from the window's height.
- Follow `brief/information-architecture.md` → *Screen conventions*.
- Run the screen-conventions test in the full Vitest run ([[screen-conventions-test]]). Check the result in a real browser too, because resizing and overlay are layout behaviour ([[headless-chromium-layout-harness]]).
