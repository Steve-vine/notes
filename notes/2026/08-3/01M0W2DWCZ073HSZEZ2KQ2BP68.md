---
id: 01M0W2DWCZ073HSZEZ2KQ2BP68
created: 2026-08-25T09:01:11.455257Z
updated: 2026-08-25T11:31:17.102482Z
type: task
title: Checkboxes are clickable on surfaces that can't save them
project: 01KY6W9951TW0904DT0GGJVGE7
number: 404
sprint: segj1dz
assignee: steve
label:
- follow_up
priority: medium
task_status: backlog
---
Follow-up from NOT-402 (the Live-view checkbox fix), found while tracing it.

`renderMarkdown` emits task checkboxes as live, non-disabled `<input>`s on every
surface, but only the note pane implements a toggle. Everywhere else the click
flips the input natively, writes nothing, and is wiped on the next render — a
control that lies.

Affected:

- **Stickies** (`WorkspaceView.svelte`, `stickyHtml`) — a checklist on a canvas
  is exactly the "tick things off a list" case, so this is the one that matters.
  It has no `data-task` handler at all.
- **Comments** (`NoteComments.svelte`) — same, and comment text is editable, so
  a toggle could be made real.
- **History** and **release notes** — legitimately read-only, but their
  checkboxes still appear interactive.

Two decisions to make:

1. Make stickies (and possibly comments) actually toggle. The shared `DocHandle`
   is the natural route — `acquire`/`toggleTaskMarker`/`flush`/`release` — which
   also keeps any open pane on the same note in step. A sticky only holds a
   handle while being edited today, so it needs one on demand.
2. Have `renderMarkdown` render checkboxes **disabled unless the caller opts
   in**, so a surface can never again ship a checkbox with no handler behind it.
   Safer default than the current always-live.