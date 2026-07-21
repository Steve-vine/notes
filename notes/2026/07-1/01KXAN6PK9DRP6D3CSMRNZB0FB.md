---
id: 01KXAN6PK9DRP6D3CSMRNZB0FB
created: 2026-07-12T07:55:53.83387892Z
updated: 2026-07-21T15:30:34.671723Z
type: task
title: diagnose agent — root-cause narrative on an Issue
project: 01KX671DATY39VW6GWK3M2T3DN
number: 38
sprint: syv1q8m
blocked_by:
- 01KXAN6FR3SF2G2SGM56A419Z7
comments:
- id: 01KXBC6JYK146Y8W5FQZ3D88QK
  author: Steve Vine
  at: 2026-07-12T14:37:47.3478731Z
  text: |-
    Dev complete — PR #38 green, merged to staging, deployed (staging-20260712-1432).

    Live-validated on staging with real runs (visible in the Agent runs viewer):
    - g5 (finding-promoted k8s issue): succeeded, 26.9k in / 2.4k out, $0.19, 38s. Correctly diagnosed the ise-api readiness-probe churn, cited the promoted finding + issue history across 4 pod IPs, ruled out node/DNS, gave 4 remediation options with trade-offs.
    - datadog (AI-created issue): succeeded, 90k in / 2.4k out, $0.51, 44s. Isolated the Chinwag UK exception stream as UK-specific (US monitor OK, UK infra monitors OK), noted the 15+ promote/resolve flaps, and was honest that it cannot pin the exception because logs aren't in ISE and service_map is empty.

    Persistence verified in prod: promoted issue got its diagnosis + agent_run_id (was null), promotion evidence preserved; AI issue kept its CREATING analyse run in agent_run_id while the diagnosis landed in evidence.diagnosis. A budget_exceeded run left its issue untouched — degrade-never-block confirmed live.

    BUG FOUND AND FIXED during the live check: the first datadog diagnosis died budget_exceeded in 12s (145,877 tokens vs the 100k ceiling). Cause was the tool, not the budget — DataDog's `metrics` slice is ~180KB / 4,014 metric names (~45k tokens), so one get_slice_payload call swallowed half the run. Tool responses are now capped (100 → 25 → 5 items until they fit) and declare the truncation so the agent never reports a sample as the complete set. Re-ran: succeeded.

    FOLLOW-UP TO CONSIDER: the fixed datadog run used 90k of the 100k per-run token ceiling — only ~10% headroom. Context accumulates across tool round-trips, so a chattier run could still trip. Tightening the tool cap further would degrade answer quality (the run reasoned across all 90 monitors). Better lever is raising ai_run_max_tokens (the daily spend ceiling remains the real cost control). Steve's call.
assignee: steve
label: null
priority: medium
task_status: done
---
diagnose task type (ai-engine brief): triggered when an operator diagnoses an Issue. Read-only tools scoped to the involved system(s) → root-cause narrative + evidence chain + remediation OPTIONS (descriptive only — NO ProposedChange in Phase 3; proposals are Phase 4). Result attached to the Issue via its AgentRun (agent_run_id / outcome). POST /issues/{id}/diagnose operator trigger. Tests with a stubbed model. Read-only tool set allow-listed per task type.