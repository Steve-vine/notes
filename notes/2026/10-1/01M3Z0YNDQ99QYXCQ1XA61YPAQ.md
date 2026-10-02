---
id: 01M3Z0YNDQ99QYXCQ1XA61YPAQ
created: 2026-10-02T19:20:12.983796Z
updated: 2026-10-02T19:20:20.409862Z
type: task
title: Edit CrossSync files in Notuvia
project: 01KY6W9951TW0904DT0GGJVGE7
number: 497
sprint: sx287fa
blocked_by:
- 01M3Z0XBM7CANBGJJNTJS1X2VG
- 01M3Z0XP26B0QDB85KD2T8VWDY
assignee: steve
label:
- feature
priority: medium
task_status: backlog
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