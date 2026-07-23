---
id: 01KY6YWJ74CQ0PN2Z210GX0TCF
created: 2026-07-23T07:43:51.524356Z
updated: 2026-07-23T09:08:57.365046Z
type: task
title: 'Read view: preserve blank lines between paragraphs'
assignee: steve
label: brief
task_status: done
number: 70
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
---
Adding multiple blank lines (carriage returns) between two lines had no effect in the read view — markdown collapses a run of blank lines into a single paragraph break, so the lines stayed directly below each other.

Fix: in `markdown.ts`, `preserveBlankLines()` keeps one blank line as the paragraph break and renders each *additional* blank line as a real blank line (a non-breaking-space line, which `breaks: true` turns into a `<br>`-separated line). Fenced code blocks are left untouched. Unit-tested.

---

Linear DEV-603 · M8 - Styling · created 2026-06-23 · done 2026-06-23