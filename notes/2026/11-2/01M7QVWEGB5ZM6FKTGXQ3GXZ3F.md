---
id: 01M7QVWEGB5ZM6FKTGXQ3GXZ3F
created: 2026-11-18T17:39:43.755133Z
updated: 2026-11-19T00:38:38.551009Z
type: task
title: 'The Library page offers a width: Normal, Wide or Full width'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1971
sprint: s2q1gxe
blocked_by:
- 01M7QP5TK69FYSTHWZ2DG3Z6Z7
- 01M7QV18EEP76MSWB8XSZ5F814
comments:
- id: 01M7RKVCQ9CJRQ9TVH64S62Y0K
  author: Steve Vine
  at: 2026-11-19T00:38:34.98544Z
  text: |-
    Merged: PR #1977, sha 25f02b9c. No migration. API: library_view.page_width in the person's preferences.

    What changed: a width control in the Library page's header offers Normal (as before, 1040 px), Wide (1560 px) and Full width (the whole browser, keeping the usual side margin). It applies on the home, in a folder, in Not in a folder and in search results. Card grids fit more cards per row as the page widens, and the cards keep their size. The choice is remembered per person on any browser, separately from the reader's width. The reading pane keeps its own width.

    For Steve to overturn: cards are at least 300 px wide, so three to a row at Normal (as before) and one on a phone.
assignee: steve
label:
- improvement
priority: medium
task_status: review
---
Steve, testing the Library on staging (18 Nov): the Library page gets the same width choice as the reader (COM-1962).

**Today:** the Library page (home, a folder, "Not in a folder" and search results) sits in a fixed column, 1040 px wide, centred.

**What a person sees**
- A small width control in the Library page's header, beside New folder where that shows, with three choices:
  - **Normal:** as now, 1040 px. This is the default.
  - **Wide:** 50% wider (1560 px).
  - **Full width:** the whole width of the browser, keeping the page's usual side margin.
- The current choice is marked, and the control works from the keyboard.
- As the page widens, the card grids fit more cards per row. Cards keep their size rather than stretching.

**Choices, for Steve to overturn**
- The same three names in both places. The reader's first choice is called "Normal" too, rather than "Original", so COM-1962 changes to match.
- The Library page's width and the reader's width are two separate choices, each remembered for the person and following them to any browser. Setting one doesn't change the other.
- The reading pane keeps its own width whatever the page's width.

**Done when**
- Normal, Wide and Full width apply on the home, in a folder, in "Not in a folder" and in search results. The choice survives moving between them, reloading and signing in elsewhere.
- No choice causes sideways scroll. On a window narrower than the choice, the page fits the window.
- Section title bars, including COM-1970's sort icons, and the search box line up with the page at every width.
- Tests cover the three widths and the remembered choice. The e2e Library crawl still passes.

Builds on COM-1962 (the width choice and how it's remembered) and COM-1967 (the home's sections). Frontend, plus one more personal preference.