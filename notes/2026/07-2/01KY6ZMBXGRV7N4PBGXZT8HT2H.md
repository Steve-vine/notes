---
id: 01KY6ZMBXGRV7N4PBGXZT8HT2H
created: 2026-07-23T07:56:51.50498Z
updated: 2026-07-23T11:03:34.462281Z
type: task
title: ADR 0017 — hybrid editing engine (CodeMirror 6, three modes)
assignee: steve
task_status: done
number: 105
imported_from: linear
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
sprint: st23znm
---
Pin the editing engine for M13 before the feature briefs are built (knowledge-before-work, as ADRs 0014/0015 did for their milestones).

**Decision:** CodeMirror 6, with a three-mode per-pane model — **Read / Live / Source**.

* **Why CM6, not WYSIWYG (TipTap/ProseMirror):** CM6 keeps the in-memory buffer the *literal markdown string*; the visual layer is decorations painted over the text, with no serialize/parse round-trip. That keeps markdown lossless and diff-clean (ADR 0003 files-are-truth, ADR 0013 git sync) and drops straight into the existing shared per-note buffer + autosave (ADR 0010) — we swap the `<textarea>` for a CM6 view bound to the same `handle.doc.body`. WYSIWYG would make a rich doc-tree the de-facto source of truth and pay a permanent round-trip / noisy-diff tax. Obsidian (the brief's stated reference) is itself CM6.
* **Three modes:** Read = rendered HTML (today's reading view, unchanged); Live = CM6 + live-preview decorations (new default edit mode); Source = CM6 + markdown syntax highlighting (raw/power-user).
* **Image width syntax:** `![alt|width](ref)`, Obsidian-compatible, plain-text — keeps resize lossless within the markdown (parsed by the renderer; no new on-disk machinery, consistent with ADR 0015).
* **Relationship to ADR 0010:** the shared buffer and autosave are unchanged; only the *view widget* over the buffer changes.

Deliverable: `decisions/0017-hybrid-editing-engine.md` in the Date/Status/Context/Decision/Consequences format. Lands alongside Brief 1 (foundation).

---

Linear DEV-686 · M13 - Hybrid Edit Mode · created 2026-06-27 · done 2026-06-28