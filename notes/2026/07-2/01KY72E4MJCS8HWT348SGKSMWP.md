---
id: 01KY72E4MJCS8HWT348SGKSMWP
created: 2026-07-23T08:45:53.170337Z
updated: 2026-07-23T12:24:59.879777Z
type: task
title: Sync Error
assignee: steve
comments:
- id: 01KY72EBJE08PJMAJH07T7HZKG
  author: Steve Vine
  at: 2026-07-23T08:46:00.270385Z
  text: |-
    Steve Vine · 2026-07-11:

    **What's going on:** GitHub's push protection scans **every commit being pushed**, not just the current file contents. Git-sync auto-commits your edits, so the note was committed in **plaintext** (with the secret) before you encrypted it. Encrypting rewrote the *file*, but the plaintext version is still sitting in an earlier commit in the unpushed history — that's what GitHub is rejecting. The encryption is working fine; the leak is in the git history.

    **How to fix your vault right now:**

    1. **Rotate/revoke the secret first.** It exists in plaintext in commits on this machine (and would be readable by anyone who ever gets that history).
    2. Then pick one:
       - **Squash the unpushed history** so the plaintext commit never leaves your machine. In the vault folder:
         ```
         git reset --soft origin/main   # or your branch name
         git commit -m "notuvia: vault update"
         ```
         That collapses everything unpushed into one commit containing only the *current* (encrypted) files, and the next sync will push clean.
       - **Or**, if the secret is rotated and you don't mind the ciphertext-era history, open the **unblock URL** GitHub printed in the error and allow the push once.

    **What I've changed in the app** (PR incoming): the sync error for this case was raw git noise. Push-protection rejections are now recognised and the sync status explains exactly this — the secret is in an earlier commit, encrypting now doesn't clear it — with the two remedies above, and GitHub's unblock URL kept in the details.
label: null
task_status: done
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 287
sprint: snnvjf1
---
I'm getting a sync error with a GitHub message saying it can't sync a note because it contains secrets, but the note is encrypted, what's going on?

---

Linear DEV-940 · Editor and Sync · created 2026-07-11 · done 2026-07-11