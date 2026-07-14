---
id: 01KXB0V2A3V399GJMZT1VQJZGT
created: 2026-07-12T11:19:15.523938763Z
updated: 2026-07-14T18:45:24.29814Z
type: task
title: AI analysis — gate on finding-set change + stable issue dedup
priority: urgent
task_status: backlog
assignee: steve
project: 01KX671DATY39VW6GWK3M2T3DN
number: 44
sprint: sdcd2jr
---
**CONFIRMED IN PRODUCTION during the ISE-53 exit test (2026-07-13). Promoted low -> URGENT.**

**There are 309 open AI issues on a TWO-SYSTEM estate.** The Issues queue — the primary surface of the product — is already unusable, and it got that way in days.

Two coupled defects, and together they are a self-inflicted denial of service.

**1. Wasted re-analysis.** In one day:

| task | runs | cost |
|---|---|---|
| analyse | **72** | **$9.85** |
| summarise-state | 144 | $0.31 |
| propose-remediation | 1 | **REFUSED — ceiling reached** |

72 analyse runs re-analysing the SAME UNCHANGED STATE burned 98.5% of the $10 daily ceiling on the top-tier model (~$0.14/run). Then the one run a human explicitly asked for — the remediation proposal, the whole point of Phase 4 — was refused because the budget was gone. **ISE spent its day's budget talking to itself about a problem it had already reported, then refused to help when a human asked.**

Root cause as predicted: `due_for_analysis` keys off open-finding `last_seen_at`, which sync refreshes every ~2 min even when nothing changed. Every 30-min dispatch re-analyses every system with any steady finding. 48 dispatches x 2 systems ~= 72 runs. Same for summarise-state (15-min dispatch, fresh `taken_at` every sync).

**2. Dedup by exact title cannot hold.** Each analyse run phrases the same problem differently, so each run creates NEW issues:

- "Deployment ise-acceptance/checkout-api down: 0/2 replicas ready due to ImagePullBackOff"
- "...is fully down (0/2 ready) due to ImagePullBackOff"
- "...is fully down (0/2 replicas ready) due to ImagePullBackOff"
- "checkout-api deployment in ise-acceptance is down (0/2 replicas ready)..."

...and 300+ more. The model is not wrong; the dedup key is.

Fix (both halves, urgent):
1. Gate `due_for_analysis` on an ACTUAL finding-set change: fingerprint the set of open finding source_keys (+ severities), store it on the last analyse AgentRun, re-analyse only when it changes. Same for summarise-state.
2. Dedup AI issues on a stable fingerprint — the underlying finding source_keys, or a model-provided stable key — never the prose title.
3. Clean up the existing 309.

Related: [[ise-57]] (the ceiling blocks operator-triggered runs, which turned wasted spend into a refusal to help) and [[ise-58]] (found in the same exit test).