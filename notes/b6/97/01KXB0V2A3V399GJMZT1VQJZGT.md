---
id: 01KXB0V2A3V399GJMZT1VQJZGT
created: 2026-07-12T11:19:15.523938763Z
updated: 2026-07-12T11:19:15.523938763Z
type: task
title: AI analysis — gate on finding-set change + stable issue dedup
priority: medium
task_status: backlog
assignee: steve
project: 01KX671DATY39VW6GWK3M2T3DN
number: 44
---
Refinement to ISE-37's analyse scheduling/dedup (noted during its live check). Two coupled improvements:

1) Scheduling gate: due_for_analysis currently keys off open-finding last_seen_at, which the sync engine refreshes every ~2min even when nothing changed — so a system with steady findings is re-analysed every 30-min dispatch. Gate instead on an ACTUAL finding-set change: e.g. a hash/fingerprint of the set of open finding source_keys (+ maybe severities), stored on/derived from the last analyse AgentRun; only re-analyse when that fingerprint changes. Same idea would help summarise-state (ISE-36), which re-summarises on every 15-min dispatch because snapshots always get a fresh taken_at.

2) Issue dedup: AI-issue dedup is currently exact-title match vs the system's open AI issues. If the model's titles drift run-to-run, near-duplicate issues could accrue. Dedup by a stabler fingerprint (normalised title, or a model-provided stable key, or embedding similarity) rather than exact title.

Bounded + cheap today (under the daily spend ceiling), so low priority — quality-of-life to cut wasted model calls and avoid slow issue accrual as the estate grows. No behaviour change to correctness.