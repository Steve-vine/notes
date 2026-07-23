---
id: 01KY72ER341BAAHKYMY0FQ9DJE
created: 2026-07-23T08:46:13.092355Z
updated: 2026-07-23T11:04:51.148783Z
type: task
title: 'Encrypted notes: plaintext history still reaches git-sync'
task_status: done
assignee: steve
imported_from: linear
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 288
comments:
- id: 01KY72EXJDZ1TFMRFW74Y1F9PV
  author: Steve Vine
  at: 2026-07-23T08:46:18.701576Z
  text: |-
    Steve Vine · 2026-07-11:

    Design settled per Steve's constraints, which reject both mitigations floated in the description:

    - **No forced encryption or secret-blocking** — not every vault syncs to GitHub, and plaintext passwords in notes are a legitimate use.
    - **No history rewriting** — the auto-squash idea would also break per-edit note rollback; nothing may touch git history, local or remote.
    - **Must recover from the current blocked state.**

    The only recovery satisfying all three is GitHub's own unblock mechanism, so PR #268 makes that first-class: the sync worker extracts the unblock URL(s) from the rejection into the sync status, Settings → Storage offers an "Open GitHub's unblock page" button (rotate the secret first), and the next sync completes and clears the state. The encrypt dialogs also gain a one-sentence note that pre-encryption versions remain readable in history — information, never enforcement. "Create-as-encrypted" remains a possible future feature but is out of scope here.
sprint: snnvjf1
---
Follow-up to DEV-940 (which only improved the error message). The structural exposure remains:

**The gap.** Git-sync commits edits in plaintext within the debounce window, so any secret typed into a note lands in git history immediately. Encrypting the note afterwards rewrites the file but not the history:

1. If the plaintext commits are unpushed, GitHub push protection blocks the next sync (now with a clear diagnosis, but the remedy is still a manual history squash).
2. If the secret isn't a format GitHub recognises — a password, someone's credentials, an unusual key — the push **succeeds silently** and the plaintext is on the remote permanently, even if the note is encrypted a minute later.

**Candidate mitigations** (roughly by value):

* **Squash unpushed history on encrypt**: when a note becomes encrypted, collapse the unpushed commits so its plaintext never leaves the machine. Must never rewrite pushed commits, and needs the sync worker paused/serialised around the reset. Fully closes case 1; helps case 2 only when encryption beats the next push.
* **Create-as-encrypted**: a new-note flow that takes the password *first*, so plaintext never touches disk or any commit. The only complete answer for born-sensitive notes; probably wants capture-window and canvas ("new encrypted sticky") entry points.
* (Weaker: a sync grace period after note creation — shrinks the race window at the cost of sync freshness for all notes.)

A history rewrite inside the sync loop is design-sensitive — likely wants an ADR alongside the implementation.

---

Linear DEV-941 · Editor and Sync · created 2026-07-11 · done 2026-07-11