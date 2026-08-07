---
id: 01KZ8F9JAFBAZTF1H0MM2AS638
created: 2026-08-05T08:05:31.087538Z
updated: 2026-08-07T11:55:20.892891Z
type: task
title: Platform log visibility
project: 01KX671DATY39VW6GWK3M2T3DN
number: 550
sprint: skxht3g
comments:
- id: 01KZ8NKMJN0064KNBXW4D7ZSHD
  author: Steve Vine
  at: 2026-08-05T09:55:52.533709Z
  text: |-
    Done — PR #466 (feature/ise-550-log-json-wrap), CI green.

    Cause: an expanded occurrence renders its message and `extra` in a Mantine `Code block` — a `<pre>` — and that sits in a table cell. `white-space: pre` sizes the cell to the longest line, so a pretty-printed `extra` or a multi-line stack-trace message pushed the whole table off the right of the page. The table has no scroll container, so there was nothing to scroll: the diagnosis was rendered but unreadable.

    Fix: both blocks wrap (`pre-wrap`), with `break-word` for the unbreakable tokens — URLs, ARM ids — that wrapping alone would still let overflow.

    Guard asserts the style property rather than geometry (jsdom does no layout, so a width assertion would pass either way); verified failing without the fix.

    To smoke on staging: Platform log → expand any group with `extra` (e.g. an AWS/Cloudflare warning) and confirm the JSON wraps inside the row with no horizontal page scroll.
assignee: steve
priority: medium
task_status: done
---

On the log screen, when expanding the log entry to view the JSON, the text goes off the right hand side of the screen with no horizontal scroll bar, JSON log text should wrap around so that it can be viewed.