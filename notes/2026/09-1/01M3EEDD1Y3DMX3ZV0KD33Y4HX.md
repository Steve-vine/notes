---
id: 01M3EEDD1Y3DMX3ZV0KD33Y4HX
created: 2026-09-26T08:48:22.078998Z
updated: 2026-09-26T12:39:20.309404Z
type: task
title: Read now shows it's reading — the Shared mailboxes tab says so until the read finishes
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 756
sprint: s3nfes0
comments:
- id: 01M3EM3X1W5C94BMRTFG6DY5A4
  author: Steve Vine
  at: 2026-09-26T10:28:02.236486Z
  text: |-
    Done — PR #767, merged to main (7710e26).

    What changed:
    - Once a shared-mailbox read is running, the Shared mailboxes tab says "Reading shared mailboxes… (started HH:MM)". That applies whether Read now or the hourly schedule started it.
    - While the read runs the tab checks every few seconds, so the list appears when the read finishes, with no reload. When nothing is running it checks once a minute, so it notices when the hourly read starts.
    - If the last read failed, the tab says "The last read failed", with the time and the reason.
    - An empty tab now says "Not read yet" (never read) or "No shared mailboxes found" (a read found none). If the first read is under way, it says so.
    - On Admin ▸ Integrations, the Exchange card shows the same "Reading…" line, and Read now is disabled until the read finishes.

    Note: Read now itself stays on Admin ▸ Integrations; the tab doesn't have its own Read now button. "Running" uses the same rule the worker uses to decide whether a pass is already in flight, so a read presumed dead after 30 minutes stops showing as running.
assignee: steve
label:
- improvement
priority: medium
task_status: done
---
Found on staging, 2026-09-26. After **Read now**, the Shared mailboxes tab gave no sign anything was happening. The first read of the tenant's 270 shared mailboxes took about 4½ minutes, and for that whole time the tab looked empty, as if nothing had been found.

**Behaviour wanted.**
- Once a read is running, whether started by Read now or by the hourly schedule, the tab says **Reading shared mailboxes… (started HH:MM)**. Read now is disabled while a read runs.
- When the read finishes, the list appears (or refreshes) without a page reload.
- If the read fails, the tab says so, with the reason, instead of going quiet.
- An empty tab that has never been read says **Not read yet**, which is different from **No shared mailboxes found**.

**Notes.** The pass already records its start on the one-row ledger (`tasks/mailbox_sync.py`: a pass older than the stale bound is presumed dead). So this is mostly exposing "running since" on the read API, plus polling on the tab while a read runs. Reuse the React Query cache rather than adding a second fetch path.