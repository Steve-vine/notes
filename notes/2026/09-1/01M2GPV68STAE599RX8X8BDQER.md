---
id: 01M2GPV68STAE599RX8X8BDQER
created: 2026-09-14T19:38:29.529035Z
updated: 2026-09-16T13:16:45.900945Z
type: task
title: Removable date range
project: 01KY6W9951TW0904DT0GGJVGE7
number: 420
comments:
- id: 01M2N5SNEC6MR7WR3EZX5YFAZ6
  author: Steve Vine
  at: 2026-09-16T13:16:45.9005Z
  text: |-
    Done — PR #418 (`brief-420-clearable-dates`).

    **What shipped.** Every date row in the properties pane now has an explicit clear button: the native `type="date"` input plus a small `x`. It writes `""`, which the autosave flush already turns into a null date (`noteDocs.svelte.ts`, `.trim() || null`), so nothing new was needed on the save path. Covers Start and Due/End on notes and projects, and both dates on a schedule's Target Properties. The four inputs collapsed into one `dateField` snippet.

    **Decisions on the fly.**
    - The button keeps its box when there's nothing to clear (`visibility: hidden`, not `display: none`) so the input doesn't shuffle sideways as dates come and go; it drops out of the tab order while hidden.
    - Swapped `bind:value` for `value` + `onchange` so the snippet owns both write paths (picker and clear) and calls `markEdited()` once in each.
    - The sprint editor's start dates are in a project's *body*, not this pane, and already clear to "Linked" by typing — left alone.

    **Why it was needed at all:** WebKit's date input offers no route back to empty once a date is set, so an accidental date was permanent.

    `npm run check`, `npm test` (323), `npm run build` all clean. Wants a quick visual check in the app — the `x` next to the date box, light and dark.
assignee: steve
priority: medium
task_status: review
tech: null
---
Add a clear button to the start and end dates on the properties pane to allow clearing of a tasks dates. 