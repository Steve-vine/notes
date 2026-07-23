---
id: 01KY71ASCV7EN0Y6XX4QHEXVS9
created: 2026-07-23T08:26:34.779224Z
updated: 2026-07-23T11:03:36.282421Z
type: task
title: Add Comment section to all notes.
imported_from: linear
assignee: steve
task_status: done
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 213
comments:
- id: 01KY71B0WPWHV8VBRT8MC16MTZ
  author: Steve Vine
  at: 2026-07-23T08:26:42.454168Z
  text: |-
    Steve Vine · 2026-07-06:

    **Agreed work (planned with Claude, 2026-07-06)**

    Comments section at the bottom of every note (memo/task/project), each comment in its own box with author, date, and text.

    - **Storage (ADR 0029):** `comments:` frontmatter list of `{id, author, at, text}` objects (the sprints precedent) — ULID ids, RFC3339 timestamps, author stored as a label snapshot at write time. Sequence-of-mapping entries are already skipped by the indexer → **not searchable** (as agreed). Plaintext frontmatter, so comments work on encrypted-body notes too.
    - **Author:** the assignee value ticked as "me" (DEV-846), falling back to the pool default (DEV-860), else "Me".
    - **Writes:** dedicated single-field commands (`note_comments`, `add_comment`, `update_comment`, `remove_comment` — the `set_blocked_by` pattern) so a pending autosave can't clobber a comment; comments never ride the doc buffer/`update_note`.
    - **UI:** new `NoteComments.svelte` mounted at the bottom of the note pane in read mode and under the locked-encrypted placeholder (not in Live/Source editing modes, same rule as Sprints). Boxes show bold author + formatted date, quiet edit (pencil → textarea, save/cancel) and delete (×) buttons; composer textarea + Comment button at the bottom, Cmd/Ctrl+Enter submits.
    - **Docs:** ADR 0029 + `brief/data-model.md` core-field entry.

    Full add/edit/delete as agreed; edits keep the original author/date.
- id: 01KY71B887CDK2T392Z7PRHF2C
  author: Steve Vine
  at: 2026-07-23T08:26:49.991077Z
  text: |-
    Steve Vine · 2026-07-06:

    **Build complete — PR [#198](https://github.com/Steve-vine/notuvia/pull/198)**, branch `steve/dev-866-add-comment-section-to-all-notes`.

    Built exactly as agreed:
    - `comments:` frontmatter list (`{id, author, at, text}`), backend-stamped ULID ids + RFC3339 dates, author = write-time label snapshot ("me" tick → pool default → "Me").
    - Four dedicated commands on the single-field write path — comments never touch the editor buffer, autosaves pass them through untouched (test-verified).
    - Excluded from search; plaintext and fully usable on locked encrypted notes (envelope verified byte-for-byte untouched).
    - `NoteComments.svelte` at the bottom of the note pane in read mode and under the locked placeholder: boxes with bold author + local-formatted date, pencil edit (in place, Esc cancels, author/date kept), × delete, composer with Cmd/Ctrl+Enter.
    - ADR 0029 + data-model.md updated.

    **Decisions on the fly:** comment writes bump `noteRev` so a second pane on the same note refreshes; unparseable hand-edited comment entries are skipped rather than failing the note; deleting the last comment removes the field to keep frontmatter clean.

    **Tests:** 212 backend (5 new) + 129 frontend, fmt/clippy/svelte-check/build all clean. Manual visual pass needed (screen capture unavailable): comment/edit/delete on each type, locked-note commenting, search exclusion.
sprint: sx9znt9
label: null
---
For tasks, memos and projects, add a section at the bottom to leave comments.

Entered comments should appear in their own box with the default assignees name, date and comment.

---

Linear DEV-866 · Backlog · created 2026-07-06 · done 2026-07-06