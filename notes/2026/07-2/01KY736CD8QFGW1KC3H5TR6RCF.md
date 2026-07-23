---
id: 01KY736CD8QFGW1KC3H5TR6RCF
created: 2026-07-23T08:59:07.560675Z
updated: 2026-07-23T11:04:50.184567Z
type: task
title: Canonical note serialisation + exact no-op guard (ADR 0045 stage 1)
imported_from: linear
task_status: done
assignee: steve
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 359
---
Stage 1 of ADR 0045 (from the DEV-1011 investigation).

`Note::to_string` emits one canonical form from every write path in every writer: fixed frontmatter field order — core fields (`id`/`created`/`updated`/`type`/`title`), then managed fields (project link, identifier, number, dates, milestones/sprints, milestone/sprint, order, favourite, encrypted, trashed, conflict_of, comments), then user taxonomy keys in a stable order — and fixed timestamp precision for stamps the core mints. `update_note`'s clear-then-set no longer changes layout, because layout no longer depends on mutation order.

With serialisation canonical, the DEV-995 no-op guard becomes exact by construction — the DEV-1011 reorder finding (opening an MCP-authored note rewrites it; app and sidecar ping-pong reorder writes) dies here. Add a regression test: load a note written in a foreign field order, echo it through `update_note`, assert no write.

Both peers must ship this before stage 2 (the one-shot normalisation) runs. No proactive rewriting of existing notes in this stage — old-layout files are read fine and only rewrite on a genuine edit.

---

Linear DEV-1012 · created 2026-07-19 · done 2026-07-19