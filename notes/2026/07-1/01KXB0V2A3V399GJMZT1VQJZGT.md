---
id: 01KXB0V2A3V399GJMZT1VQJZGT
created: 2026-07-12T11:19:15.523938763Z
updated: 2026-07-24T12:49:36.951293Z
type: task
title: AI analysis — gate on finding-set change + stable issue dedup
project: 01KX671DATY39VW6GWK3M2T3DN
number: 44
sprint: sdcd2jr
assignee: steve
priority: urgent
task_status: done
---
**DONE 2026-07-14** (PR #55, deployed). Confirmed working in production.

Found live during the ISE-53 exit test: **309 open AI issues on a TWO-system estate**, and 72 analyse runs in one day burning **98.5% of the $10 daily ceiling** re-deriving answers already on file — which is why ISE then **refused** the remediation a human had clicked ([[ise-57]]). The busywork starved the real work.

**1. The gate was a clock, not a change detector.**
`analyse` re-ran when any open finding's `last_seen_at` was newer than the last analysis — but sync refreshes `last_seen_at` every ~2 min on findings that have not changed at all, so any system with a steady finding was re-analysed on EVERY 30-min dispatch, for ever. `summarise-state` was worse: every sync writes a snapshot with a fresh `taken_at`, so it was ALWAYS due (144 runs/day, rewriting the same paragraph).

Both now gate on a **fingerprint of the content the agent would actually see** — the set of open findings (source_key, severity, kind; pointedly NOT last_seen_at), and the latest summary per state slice. *A finding that is still there is not news.* Runs record what they reasoned over, so a run with no fingerprint is analysed once and stamps one — self-healing, no backfill. Only SUCCESSFUL runs record one, so a failure cannot suppress the next attempt.

**2. Dedup matched prose, and prose drifts.**
Exact-title matching against a model that says "is fully down (0/2 ready)" one run and "is down: 0/2 replicas ready" the next matched nothing. The model was never wrong — the key was. `ProposedIssue` now carries a stable `key` tied to the affected resource, and the model is told the same problem must produce the same key however it words the title.

**Verified in production:** overnight the AI raised **31 open issues, 31 distinct dedup_keys, zero duplicates**. Yesterday the same code path produced 309.

**Cleanup:** 326 legacy duplicate issues deleted (backed up first). Deliberately kept the one legacy issue referenced by the executed `edit_resource` remediation — deleting it would have severed the provenance of the only change ISE has ever made in the real world.

Note for the record: the normalised-title fallback for legacy issues is much weaker than it looks (it collapsed 339 -> 333). Prose drift is in the WORDING, not the punctuation. Only the model-supplied key actually dedups; the fallback just stops the legacy rows being re-raised.