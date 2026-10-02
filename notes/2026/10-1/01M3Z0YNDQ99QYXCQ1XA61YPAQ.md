---
id: 01M3Z0YNDQ99QYXCQ1XA61YPAQ
created: 2026-10-02T19:20:12.983796Z
updated: 2026-10-02T20:38:06.406823Z
type: task
title: Edit CrossSync files in Notuvia
project: 01KY6W9951TW0904DT0GGJVGE7
number: 497
sprint: sx287fa
blocked_by:
- 01M3Z0XBM7CANBGJJNTJS1X2VG
- 01M3Z0XP26B0QDB85KD2T8VWDY
comments:
- id: 01M3Z5D93TMNX62CR8VDS6X0S6
  author: Steve Vine
  at: 2026-10-02T20:38:06.199634Z
  text: |-
    Built and merged (squash, PR #487), CI green. The branch is deleted.

    What landed:
    - The file name in the CrossSync list opens the file in the main panel, with a back button to the list.
    - PlainTextEditor.svelte: a small CodeMirror setup for config files (monospace, line numbers, active line, no wrapping, Tab indents, the note editor's find/replace panel).
    - xsync_read_file and xsync_write_file take the entry id; the backend resolves the path from the machine-local map. Writes are atomic, go through symlinks and keep the file's mode.
    - Autosave on the notes' 800 ms debounce with a Saved / Edited / Saving… indicator. Each save is followed by a sync of that entry.
    - Changed on disk: every save names the hash the buffer last read or wrote and the backend refuses a write that no longer matches. A clean buffer reloads on xsync-changed; a dirty one shows Reload from disk / Keep mine and stops autosaving until chosen.
    - Files that aren't UTF-8 or are over 1 MB show a message; they still sync.
    - An entry not linked on this machine opens the vault copy read-only, with Link… going back to the list's link form.

    Decided on the fly:
    - The editor is a separate small component, not a new mode of Editor.svelte as the task said. That component is about 900 lines of markdown behaviour and a plain mode would have meant guarding most of it.
    - No backup is taken for the user's own edits; backups are for files CrossSync replaces.
    - Tab indents in this editor (Esc then Tab moves focus), unlike the note editor, because config formats can need a literal tab.
    - Closing with unsaved edits flushes them, except when a changed-on-disk choice is still open.

    Verification: 5 new xsync tests and the reload-rule tests; 42 xsync Rust tests pass; npm test 520/520; fmt, clippy and npm run check clean. Rendered in the UI lab: typing produced exactly one autosave, the changed-on-disk strip and the read-only vault copy both render, long lines scroll. Not run in the Tauri app.

    Possible follow-up, not filed: syntax highlighting by file type.
assignee: steve
label:
- feature
priority: medium
task_status: done
tech: null
---
So that a synced file can be opened and edited inside Notuvia like a note. The edit is made to the original file at its local path on this machine, not the vault copy; the normal sync then carries it into the vault. Builds on the rail view and automatic sync.

## Agreed work

- [ ] Selecting a linked entry in the CrossSync view opens it in the main panel in a plain-text editor pane.
- [ ] The pane reuses `Editor.svelte`'s CodeMirror setup in a new plain-text mode: no markdown language, live preview, slash menu, table widget or attachment handling (`noteId` null). Monospace, line numbers, the app's theme.
- [ ] New commands `xsync_read_file` and `xsync_write_file`, taking the entry id, never a path from the WebView: the backend resolves the path from the machine-local map, so the WebView can't be used to read or write arbitrary files.
- [ ] Autosave on the same 800ms debounce as notes, written atomically, through symlinks, keeping the file's mode.
- [ ] If the file changes on disk while open (edited elsewhere, or an incoming sync), reload it when the buffer is clean; when there are unsaved edits, keep the buffer and offer Reload or Keep mine.
- [ ] Refuse to open files that aren't valid UTF-8 or are over a size limit (1 MB), with a message; they still sync.
- [ ] An entry that isn't linked on this machine opens the vault copy read-only, with a prompt to link it.
- [ ] Tests: read/write by id, the refusal of binary and oversized files, and the external-change reload rule.

## Notes

This is a separate small pane and buffer, not `NotePane` / `noteDocs`, which are keyed by note id and save through `update_note`. Syntax highlighting by file type is a possible follow-up, not in this task.