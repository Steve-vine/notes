---
id: 01KY71MDDKNXPXSK6MN9KFKRN4
created: 2026-07-23T08:31:50.195662Z
updated: 2026-07-23T11:03:35.915754Z
type: task
title: 'notuvia-mcp: comments on notes (add_comment tool)'
assignee: steve
imported_from: linear
task_status: done
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 231
sprint: sndmea4
label: null
---
Expose the existing note-comments capability over MCP. There is no comment surface in notuvia-mcp today — the only workaround is a full-body rewrite via `update_note`, which is the wrong mechanism: comments are not body text.

The design and core implementation already exist (ADR 0029): comments are a `comments:` frontmatter list (ULID id, author snapshot, RFC3339 timestamp, text), and `notuvia-core`'s runtime has `note_comments`, `add_comment`, `update_comment`, `remove_comment` using the single-field write path (ADR 0026) so comment writes can't clobber body edits.

Scope — MCP tools wrapping the core commands:

* `add_comment(id, text)` — author resolved by the backend per ADR 0029 (the "me" assignee value, else the default, else "Me").
* Optionally `update_comment` / `remove_comment` for the full CRUD, and surfacing comments in `get_note` output.
* Works on encrypted notes — comments are plaintext frontmatter and stay writable while locked (ADR 0029), unlike body updates.
* Comments stay out of FTS, per the ADR.

Context: surfaced while assessing whether a project could be managed end-to-end via notuvia-mcp instead of Linear — this and sprint/milestone writes (see sibling issue) were the two blocking gaps.

---

Linear DEV-884 · MCP Server · created 2026-07-07 · done 2026-07-07