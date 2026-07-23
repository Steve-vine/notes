---
id: 01KY732AK814PPXP0T9Q9HZ1GZ
created: 2026-07-23T08:56:54.632046Z
updated: 2026-07-23T11:04:50.382624Z
type: task
title: No-op saves rewrite unchanged notes and create sync conflict surface
task_status: done
imported_from: linear
assignee: steve
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 342
---
Observed 2026-07-18 (the ISE-73 conflict-copy incident): the app wrote `01KXKTFR7TSRY6HSBXKNH4SEFD` three times in ten minutes — vault commits at 16:20:17, 16:28:54, and 16:29:37 — where each diff was **only the** `updated:` **timestamp**. No content changed. The likely writer is the editor's unconditional flush-on-close (ADR 0028's flush path), possibly also the properties panel's release-flush.

The 16:20:17 no-op save is what caused the conflict copy: a remote agent had pushed a real edit (a comment) to the same note at 16:20:15, the no-op save collided with it in the next git-sync merge, and keep-both split the note — putting the remote comment on a copy and leaving the original without it.

**Change:** a save should short-circuit before writing when the serialised note (ignoring `updated:`) is byte-identical to what's on disk — no write, no `updated` bump, no git commit. Every no-op save eliminated is conflict surface eliminated; a note merely opened and closed should never generate a vault commit.

---

Linear DEV-995 · created 2026-07-18 · done 2026-07-18