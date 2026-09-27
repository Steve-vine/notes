---
id: 01M3HQE8MDC3P4MJEXSXBQ5PZG
created: 2026-09-27T15:23:50.797978Z
updated: 2026-09-27T15:24:07.940552Z
type: task
title: Emoji shortcodes (:smile:, :rocket:) in notes
project: 01KY6W9951TW0904DT0GGJVGE7
number: 457
sprint: sx9znt9
assignee: steve
label:
- feature
priority: low
task_status: backlog
tech: null
---
Split from NOT-450. `:smile: :rocket: :white_check_mark: :warning:` render as literal text in both Read and Live. Rendering GitHub-style shortcodes needs a shortcode → emoji table (a dependency or a bundled subset) in the read renderer and a matching inline replacement in Live.