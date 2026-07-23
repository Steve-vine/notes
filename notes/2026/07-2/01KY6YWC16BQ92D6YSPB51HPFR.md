---
id: 01KY6YWC16BQ92D6YSPB51HPFR
created: 2026-07-23T07:43:45.190614Z
updated: 2026-07-23T11:04:51.258682Z
type: task
title: 'Code blocks: copy button + optional line numbers via fence options'
task_status: done
number: 69
imported_from: linear
assignee: steve
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
sprint: sr2wq8c
---
Extend fenced code blocks in the note reader with options after the language, comma-separated:

```
```yaml,copy=false,num=true
```

* **First section** = language (as today).
* **copy** = whether the copy button is shown; omitted → **true**.
* **num** = line numbers, true/false; omitted → **false**.

Add a copy-to-clipboard button (shown by default) and an optional line-number gutter that doesn't break copy (copies the raw code only). Rendered in `markdown.ts`; copy handled via the existing `.markdown` click delegation in NotePane.

---

Linear DEV-602 · M8 - Styling · created 2026-06-23 · done 2026-06-23