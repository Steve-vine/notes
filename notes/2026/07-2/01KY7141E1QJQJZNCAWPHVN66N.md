---
id: 01KY7141E1QJQJZNCAWPHVN66N
created: 2026-07-23T08:22:53.633905Z
updated: 2026-07-23T08:23:20.303782Z
type: task
title: Copy note ID it to clipboard
task_status: done
imported_from: linear
assignee: steve
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 199
comments:
- id: 01KY7145NQ1G5DT9ZXTZSAD4QG
  author: Steve Vine
  at: 2026-07-23T08:22:57.97469Z
  text: |-
    Steve Vine · 2026-07-06:

    **Planned work (Claude, 2026-07-06):** add a small copy icon button next to the existing ID row in the properties panel (`NoteProperties.svelte`, the `display_id` field shown for numbered tasks, e.g. `WEB-14`). Click copies the displayed ID to the clipboard via `navigator.clipboard`, with transient copied-tick feedback. New `copy` glyph in `Icon.svelte`. One branch + PR per the brief discipline.
- id: 01KY714ECJMRFJ76AYF8098S3N
  author: Steve Vine
  at: 2026-07-23T08:23:06.897602Z
  text: |-
    Steve Vine · 2026-07-06:

    **Build complete — PR [#196](https://github.com/Steve-vine/notuvia/pull/196)**, branch `steve/dev-847-copy-note-id-it-to-clipboard`.

    Copy button added next to the properties-panel ID row (`NoteProperties.svelte`): copies the displayed `display_id` (e.g. `WEB-14`) via `navigator.clipboard`, icon flips to a tick for 1.5s, half-opacity until hovered. New `copy` glyph in `Icon.svelte`. Note the ID row (and so the button) only appears on numbered tasks — that's the existing field the issue points at. svelte-check clean, 129 tests pass, build OK.
label: null
---
In the note properties panel add a copy icon next to the note ID field to copy it to clipboard.

---

Linear DEV-847 · Backlog · created 2026-07-05 · done 2026-07-06