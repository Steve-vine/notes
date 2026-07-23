---
id: 01KY7348VBP9PABAJM6C0XMHGV
created: 2026-07-23T08:57:58.379685Z
updated: 2026-07-23T11:03:35.123042Z
type: task
title: 'Git-sync: one push retry is too few during concurrent write bursts'
assignee: steve
imported_from: null
task_status: done
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 351
---
Observed 2026-07-19 ~10:18: a sync error flashed during a rapid write burst, with no actual damage — the vault ended fully in sync, clean, no conflict copies, and the next cycle cleared the error.

**Mechanism.** The edit path (`commit_and_push` in `gitsync.rs`) handles a rejected push by pulling (keep-both) and retrying **once**. When the other machine is writing continuously — an agent session on the ISE box makes this routine — the remote moves again inside that window, the second push is also rejected, and the error propagates to the sync indicator. The vault reflog for the burst shows the dance: commit 10:18:14 → merge 10:18:17 → commit → merge, four merges in ~2 minutes, all resolving cleanly. The failure is cosmetic but reads as scary, and it will recur whenever two writers are active at once.

**Change:** retry the pull-and-push loop 2–3 times, ideally with a small jittered backoff between attempts, before surfacing anything; only an error that survives the retries reaches `last_error`. Genuine failures (auth, push protection — see `explain_push_error`) should fail fast rather than retry, so the loop should distinguish "rejected because remote moved" from other push errors.

Related: DEV-997 (auto-resolve timestamp-only conflict sides) reduces what those pulls have to merge; DEV-995 removed the no-op saves that used to amplify write bursts.

---

Linear DEV-1004 · created 2026-07-19 · done 2026-07-19