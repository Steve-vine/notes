---
id: 01KY6Z5RCW8CJNGV6HSD6BD9KW
created: 2026-07-23T07:48:52.764478Z
updated: 2026-07-23T09:08:57.44639Z
type: task
title: Per-note history & rollback UI
task_status: done
assignee: steve
comments:
- id: 01KY6Z5ZCXSQACBKADRSF5RZ1H
  author: Steve Vine
  at: 2026-07-23T07:48:59.933379Z
  text: |-
    Steve Vine · 2026-06-25:

    Done — PR opened: https://github.com/Steve-vine/notula/pull/78

    **What was done**
    - A History button in the note pane status bar opens a modal: lists the note's commits (newest first), previews a selected version read-only (rendered markdown), and restores either "in place (overwrite current)" or "as a new note".
    - Backend: `git.rs` `file_log`/`file_at`; runtime `note_history`/`note_version`/`restore_note`/`restore_note_as_new`; `note.rs` `shard_rel` + `rekey_as_restored_copy`. New commands wired.

    **Decisions made on the fly**
    - **Gated history on "is a git repo", not the auto-commit toggle.** History is a property of the repository; this is strictly more useful (works even if you've toggled auto-commit off) and still satisfies the brief's "graceful empty state when off" via the not-a-repo empty message.
    - **Restore in place writes the old content verbatim** as a new commit — reversible since history is preserved. After it, the pane reloads from disk (reusing the existing `reloadFromDisk`).
    - **Restore as new note** mints a fresh id, stamps `created`/`updated` to now, and marks the title `(restored)` so it's findable and distinct from the live note; then opens it.
    - Both restores go through the normal write path → index reconcile + git_touch, so search/browse and git-sync stay consistent.

    **Verification** — verbatim gates green: check (0 errors, 0 warnings), build, npm test (58), fmt, clippy, **cargo test 84** (+1 end-to-end history/restore test: two commits → history lists both → old version reads back → in-place restore and restore-as-new both verified). `npm run tauri build` left to CI.

    Moving to In Review — merge call is yours. **This is the last brief in M10 — Sync.**
label: brief
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 82
---
Turn the git history into a usable per-note time machine (ADR 0013).

## Sub-steps

- [ ] From an open note, view its commit history (`git log` scoped to the note's path).
- [ ] View a previous version of the note (`git show <rev>:<path>`), read-only.
- [ ] Restore offers **both**: "Restore (overwrite current)" — writes the old content as a new commit — and "Restore as a new note" — creates a fresh note (new id) from the old content.
- [ ] Restores route through the normal write path so the index updates.
- [ ] Graceful empty state when git-sync mode is off or the note has a single commit.

## Definition of done

For any note, the user can browse its history, view an old version, and restore it either in place or as a new note.

---

Linear DEV-617 · M10 — Sync · created 2026-06-24 · done 2026-06-25