---
id: 01KY6ZHTKGXNCX0CKQ544XRYER
created: 2026-07-23T07:55:28.240433Z
updated: 2026-07-23T07:55:51.419388Z
type: task
title: Cascade attachment cleanup on note deletion
task_status: done
label: follow_up
assignee: steve
imported_from: linear
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 101
comments:
- id: 01KY6ZJ8WTBC3PSCRBVAXGW7JJ
  author: Steve Vine
  at: 2026-07-23T07:55:42.874017Z
  text: |-
    Steve Vine · 2026-06-26:

    **Scope agreed with Steve** — this expands from "wire the cascade" into building **note deletion + the attachment cascade**, since there's no existing delete path.

    **Behaviour:**
    - **Always confirm first.** Deleting a Memo / Task / childless Project → a simple "Delete this note?" confirm (Delete / Cancel).
    - **Deleting a Project that has Tasks** → notify ("This project has N tasks") and offer three choices: **Orphan tasks** (clear each child's `project` link + number, keep the tasks), **Delete tasks** (cascade-delete the child tasks and their attachments), or **Cancel**.

    **Backend** — `delete_note(id, delete_children)` command + `VaultRuntime::delete_note`:
    - Remove the note file, `index.remove_note(id)`, `attachment::remove_all(id)`, `git_touch` (deletion of note + attachments auto-commits, ADR 0013).
    - For a Project with children: `delete_children=false` → orphan (clear `project`/`number` on each child via `index.children_of`); `true` → recursively delete each child note + its attachments.

    **Frontend** — a trash button in the per-pane statusbar; on click, check child count (existing `project_tasks`) to pick the simple confirm vs the 3-option project dialog; on delete, close/clear the pane and emit `note-deleted` so other panes showing it react.

    Deletion is recoverable from git history when git-sync is on, gone otherwise — surfaced in the confirm copy. Building now.
- id: 01KY6ZJH7VFPX8YGGMBTMMHXJD
  author: Steve Vine
  at: 2026-07-23T07:55:51.418892Z
  text: |-
    Steve Vine · 2026-06-26:

    Built and opened [PR #91](https://github.com/Steve-vine/notula/pull/91). Branch `steve/dev-657-cascade-attachment-cleanup-on-note-deletion`.

    Built the note-deletion path and wired the attachment cascade through it, per the agreed behaviour.

    **Done:**
    - ✅ `delete_note(id, delete_children)` — removes the note file, index rows, and attachment folder (`attachment::remove_all`), auto-committed.
    - ✅ **Always confirm.** Memo/Task/childless Project → simple confirm. Project with N tasks → **Keep tasks (orphan)** / **Delete tasks too** / **Cancel**.
    - ✅ Orphan clears each child's `project`/`number` and keeps the Task (ADR 0006); cascade deletes children + their attachments.
    - ✅ Trash button in the pane statusbar; on delete the pane clears + closes and the search/browse/project lists refresh.

    **Decisions on the fly:**
    1. **Child-disposition is a runtime user choice** (your call), not a fixed policy.
    2. **No watcher-side cascade** for sync/external deletes — too risky to delete binaries from a background reconcile; in-app delete is the safe site. (This is the watcher concern I raised earlier; left as designed-out.)
    3. **A note open in a second pane** isn't force-cleared on delete (rare) — goes stale until re-selected. Minor; flag if you want it chased.

    **CI:** `cargo fmt --check`, `clippy -D warnings`, `cargo test` (132 ✓, +3), `npm run check` (0 errors), `npm test` (69 ✓), `npm run build` — green.

    **⚠️ Manual verify (UI):** delete a Memo; delete a Project-with-tasks both ways (orphan vs delete-tasks); confirm the note leaves the lists and its `attachments/<id>/` folder is gone. I couldn't drive the GUI from here.

    Moving to In Review for your check + merge call.
---
Surfaced during DEV-652 (orphan cleanup). The orphan-cleanup brief delivered **on-save reconciliation** (saving a note prunes attachments its body no longer references) and a ready-to-use `attachment::remove_all(vault, id)` helper — but **the app has no note-deletion path** (no in-app delete action, command, or UI), so the "remove a note's `attachments/<id>/` folder when the note is deleted" half of the ADR 0015 lifecycle has no call site to hook.

This follow-up wires the delete cascade once a note-deletion path exists:

* **If/when an in-app "delete note" action is added**, call `attachment::remove_all(&vault, &id)` alongside the note-file delete + index removal + git rm. That is the safe, explicit place to cascade.
* **Sync/external deletes** (a `git pull` or another machine removing a note file) are caught by the watcher, which reconciles the index. Cascading binary deletion from the watcher's background thread is deliberately **not** done here — it risks deleting attachments during transient states. If we want sync-deleted notes to shed their attachments, design that carefully (e.g. only after the deletion is confirmed stable) as part of this work.

Note: a note-deletion feature itself may warrant its own brief; this issue is specifically the attachment-cleanup wiring on top of it. The `remove_all` helper already exists and is tested, so the cascade is a one-line call at the right site.

Relates to ADR 0015 (attachment lifecycle) and ADR 0013 (sync).

---

Linear DEV-657 · Backlog · created 2026-06-26 · done 2026-06-27