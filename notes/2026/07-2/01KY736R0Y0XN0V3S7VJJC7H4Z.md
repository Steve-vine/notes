---
id: 01KY736R0Y0XN0V3S7VJJC7H4Z
created: 2026-07-23T08:59:19.454776Z
updated: 2026-07-23T12:25:00.008903Z
type: task
title: One-shot vault normalisation to canonical form (ADR 0045 stage 2)
label: null
assignee: steve
task_status: done
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 360
---
Stage 2 of ADR 0045 — **blocked by** DEV-1012 **shipping on both peers** (an old writer would keep minting old-layout files and re-open the churn; the sidecar self-updates per ADR 0044).

A maintenance pass that rewrites **every** note into canonical form in one clearly-labelled commit (`notuvia: normalise note layout (ADR 0045)`), changing zero content — parse, re-serialise canonically, write only the files whose bytes differ, one git commit for the whole pass. After it, every future diff is exactly its edit.

Surfaces: a button under Settings → Storage, and a `notuvia-mcp normalise` subcommand (the vault has two writers; either peer can run it, exactly once is enough — the pass is idempotent, so twice is merely a no-op commit). Encrypted notes: envelope untouched, frontmatter normalised (the sealed body is opaque bytes, not YAML). The pass must not bump `updated` — layout is not an edit.

Guard rails: refuse to run with a dirty sync state (unpushed/unpulled work) so the big commit can't itself become a merge; report a summary (rewritten / already-canonical counts).

---

Linear DEV-1013 · created 2026-07-19 · done 2026-07-19