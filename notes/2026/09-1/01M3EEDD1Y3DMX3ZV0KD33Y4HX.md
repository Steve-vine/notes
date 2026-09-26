---
id: 01M3EEDD1Y3DMX3ZV0KD33Y4HX
created: 2026-09-26T08:48:22.078998Z
updated: 2026-09-26T08:48:25.47853Z
type: task
title: Read now shows it's reading — the Shared mailboxes tab says so until the read finishes
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 756
sprint: s3nfes0
assignee: steve
label:
- improvement
priority: medium
task_status: todo
---
Found on staging, 2026-09-26. After **Read now**, the Shared mailboxes tab gave no sign anything was happening. The first read of the tenant's 270 shared mailboxes took about 4½ minutes, and for that whole time the tab looked empty, as if nothing had been found.

**Behaviour wanted.**
- Once a read is running, whether started by Read now or by the hourly schedule, the tab says **Reading shared mailboxes… (started HH:MM)**. Read now is disabled while a read runs.
- When the read finishes, the list appears (or refreshes) without a page reload.
- If the read fails, the tab says so, with the reason, instead of going quiet.
- An empty tab that has never been read says **Not read yet**, which is different from **No shared mailboxes found**.

**Notes.** The pass already records its start on the one-row ledger (`tasks/mailbox_sync.py`: a pass older than the stale bound is presumed dead). So this is mostly exposing "running since" on the read API, plus polling on the tab while a read runs. Reuse the React Query cache rather than adding a second fetch path.