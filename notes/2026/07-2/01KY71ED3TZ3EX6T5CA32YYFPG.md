---
id: 01KY71ED3TZ3EX6T5CA32YYFPG
created: 2026-07-23T08:28:33.274224Z
updated: 2026-07-23T08:28:45.187634Z
type: task
title: Browse filter
imported_from: linear
task_status: done
assignee: steve
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 219
comments:
- id: 01KY71EJ8BFMBSA865KQ6W9RQE
  author: Steve Vine
  at: 2026-07-23T08:28:38.539296Z
  text: |-
    Steve Vine · 2026-07-07:

    **Planned work (Claude, 2026-07-07, agreed with Steve: narrow the whole tree):** the Browse "Filter values…" box currently just filters root folder labels client-side. It becomes a **note filter using the main search's logic** (fuzzy text + `key:value` syntax): the backend gains a reusable `search_note_ids(query)` (the `search_summaries` matcher without the 200-hit cap or snippets), and the browse queries — folder values/counts (`distinct_values`) and leaf note lists (`notes_with_summaries`) — take an optional query constraint intersecting with the matched notes. So while filtering: folders shrink to values containing matching notes, counts become matching-note counts, and expanded levels list only matching notes. The frontend passes the filter text through (debounced) and refetches the tree on change; placeholder updated to say it filters notes.
- id: 01KY71ERR3AGRGTV3HJ268E7VT
  author: Steve Vine
  at: 2026-07-23T08:28:45.187022Z
  text: |-
    Steve Vine · 2026-07-07:

    **Build complete — PR [#206](https://github.com/Steve-vine/notuvia/pull/206)**, branch `steve/dev-872-browse-filter`.

    The Browse filter box now filters notes with the main search's exact logic (fuzzy text + `key:value`), narrowing the whole tree as agreed: folders shrink to values containing matching notes, counts become matching-note counts, and expanded levels list only matches. Typing refetches the tree in place (debounced 250ms) so your expanded paths are kept; clearing restores the full tree. Backend: new `search_note_ids` (the search matcher, uncapped) constraining `distinct_values` + `notes_with_summaries`; counts aggregate in Rust to avoid SQL parameter limits. Encrypted bodies stay excluded, matching the main search.

    **Tests:** 220 backend (3 new) + 129 frontend; all gates clean. Manual pass: type plain text and a `type:task` filter in the Browse box, watch folders/counts narrow, expand a value, clear the box.
---
The Browse filter filters on taxonomies rather than notes, change the behaviour to filter on notes instead.  Use the same search logic as is used on the main search feature in the left hand pane.

---

Linear DEV-872 · Backlog · created 2026-07-07 · done 2026-07-07