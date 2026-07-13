---
id: 01KXB0V2A3V399GJMZT1VQJZGT
created: 2026-07-12T11:19:15.523938763Z
updated: 2026-07-13T17:59:43.293158292Z
type: task
title: AI analysis — gate on finding-set change + stable issue dedup
priority: high
task_status: backlog
assignee: steve
project: 01KX671DATY39VW6GWK3M2T3DN
number: 44
---
**CONFIRMED IN PRODUCTION during the ISE-53 exit test (2026-07-13). Promoted low -> high: this is not quality-of-life, it is a self-inflicted denial of service.**

What actually happened on a TWO-system estate in one day:

| task | runs | cost |
|---|---|---|
| analyse | **72** | **$9.85** |
| summarise-state | 144 | $0.31 |
| propose-remediation | 1 | **REFUSED — ceiling reached** |

The analyse agent ran 72 times, re-analysing the SAME UNCHANGED STATE, and burned 98.5% of the $10 daily ceiling on the top-tier model (~$0.14/run). Then the one run a human explicitly asked for — the remediation proposal, the whole point of Phase 4 — was refused because the budget was gone.

**ISE spent its entire day's budget talking to itself about a problem it had already reported seven times, then refused to help when a human actually asked.**

Root cause, as originally predicted: `due_for_analysis` keys off open-finding `last_seen_at`, which the sync engine refreshes every ~2 min even when nothing changed. So every 30-min dispatch re-analyses every system with any steady finding. 48 dispatches x 2 systems ~= 72 runs. Same for summarise-state (ISE-36), which re-summarises on every 15-min dispatch because snapshots always get a fresh `taken_at`.

The dedup half of this task is confirmed too: SEVEN near-duplicate AI issues for one broken deployment, titles drifting run to run ("...is fully down (0/2 ready)...", "...is fully down (0/2 replicas ready)...", "checkout-api deployment in ise-acceptance is down..."), plus three duplicates of a DataDog issue. Exact-title dedup cannot hold. The Issues queue — the primary surface of the product — fills with noise, and an operator's trust in it decays with it.

Fix (both halves, now urgent):
1. Gate `due_for_analysis` on an ACTUAL finding-set change: hash the set of open finding source_keys (+ severities), store it on the last analyse AgentRun, and only re-analyse when the fingerprint changes. Same for summarise-state.
2. Dedup AI issues on a stable fingerprint (normalised title, a model-provided stable key, or the underlying finding source_keys) rather than exact title.

Related: [[ise-57]] — the ceiling blocks operator-triggered runs, which is what turned wasted spend into a refusal to help.