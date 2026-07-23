---
id: 01KY6YB19E7YYYDYN67HSFFNQQ
created: 2026-07-23T07:34:17.134897Z
updated: 2026-07-23T09:08:57.13094Z
type: task
title: Concurrent edits to the same note in two panes overwrite each other
task_status: done
label: bug
assignee: steve
number: 25
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
---
Surfaced via split panes (DEV-516): the same note can be opened in two panes and edited in both. **Last save wins — it silently overwrites the other pane's changes (lost update).**

**Repro**

1. Open note N in pane A, split, open the same note N in pane B
2. Edit in A → Save; edit in B (from its stale copy) → Save
3. B's save overwrites A's changes; A's edits are lost with no warning

**Root cause:** `update_note` (DEV-515) is load-modify-write with **last-write-wins** — each pane holds its own in-memory copy and writes the whole note back; there's no concurrency check, and two panes showing the same note aren't kept in sync.

**Fix options (decide when picked up)**

* **Optimistic concurrency:** capture the note's `updated` (or file mtime) at load; on save, re-read and refuse/warn if it changed since (conflict) instead of clobbering.
* And/or **keep same-note panes in sync** (broadcast a note-changed event so other panes showing N reload — ties into the watcher/reconcile already in place).
* Minimum acceptable: **no silent data loss** — a conflicting save is detected and the user is told, rather than overwriting.

**Done when:** editing the same note in two panes can't silently lose edits — a conflicting save is detected (and ideally the panes stay in sync).

Pick up in M4. No new ADR expected.

---

Linear DEV-529 · M4 — Main UI · created 2026-06-20 · done 2026-06-20