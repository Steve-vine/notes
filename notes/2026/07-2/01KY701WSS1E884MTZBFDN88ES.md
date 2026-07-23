---
id: 01KY701WSS1E884MTZBFDN88ES
created: 2026-07-23T08:04:14.777131Z
updated: 2026-07-23T09:08:57.858799Z
type: task
title: Rename the notula-attachment:// URI scheme
number: 132
task_status: done
label: chore
assignee: steve
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
---
Rename the custom attachment protocol `notula-attachment://` → `notuvia-attachment://`. This is registered in Rust and consumed in the frontend, so it **must change in lock-step** or attachment rendering breaks (ADR 0015).

## Changes (all together)

* `src-tauri/src/lib.rs` — `register_uri_scheme_protocol("notula-attachment", …)` (line ~703) + the related comment (~252).
* `src/lib/NotePane.svelte` (~98), `src/lib/Editor.svelte` (~101), `src/lib/markdown.ts` (~319/330), `src/lib/markdown.test.ts` (~13/35/69).

## Verify before shipping

* Confirm whether any **persisted note content** embeds the literal `notula-attachment://` string. Per ADR 0015 attachments are referenced by vault-relative path and the scheme is only the protocol handler, so stored markdown should be unaffected — but check, and if any content does embed it, handle old → new (rewrite-on-read or migration).

## Done when

* Attachments render in read and edit modes via the new scheme.
* `markdown.test.ts` updated and passing; no `notula-attachment` reference remains.

---

Linear DEV-737 · Rebrand · created 2026-06-30 · done 2026-06-30