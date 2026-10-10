---
id: 01M3HQE8MDC3P4MJEXSXBQ5PZG
created: 2026-09-27T15:23:50.797978Z
updated: 2026-10-10T16:50:58.135478Z
type: task
title: Emoji shortcodes (:smile:, :rocket:) in notes
project: 01KY6W9951TW0904DT0GGJVGE7
number: 457
sprint: s9peyxr
comments:
- id: 01M4KBK35Y0QKE864TZ2AP0GM3
  author: Steve Vine
  at: 2026-10-10T16:50:56.830422Z
  text: |-
    Done in PR #515 (branch brief-457-emoji-shortcodes).

    What was done: GitHub-style shortcodes render as emoji in Read (a marked inline extension) and Live (a Lezer Emoji inline node that live-preview swaps for the character off-cursor; the cursor on the line reveals the raw :name:). The table is the gemoji package (data only, GitHub's own list), consulted through a small src/lib/emoji.ts so both views agree. A :word: whose name isn't in the table stays literal, so times (10:30:45) and URLs are untouched; code spans are consumed before either parser runs. Unit tests cover the helpers and the renderer.

    Decisions: a dependency rather than a bundled subset, so the list is complete and matches GitHub exactly; names are case-sensitive as on GitHub.

    Not run in the app: a visual pass is owed (type :smile: in Live, leave the line, return to it; check Read).
assignee: steve
label:
- feature
priority: low
task_status: review
tech: null
---
Split from NOT-450. `:smile: :rocket: :white_check_mark: :warning:` render as literal text in both Read and Live. Rendering GitHub-style shortcodes needs a shortcode → emoji table (a dependency or a bundled subset) in the read renderer and a matching inline replacement in Live.