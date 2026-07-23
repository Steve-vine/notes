---
id: 01KXAN6KNK5VX3WR8R69Q2C9G0
created: 2026-07-12T07:55:50.835157694Z
updated: 2026-07-23T18:32:58.008381Z
type: task
title: analyse agent — AI-created Issues with evidence
project: 01KX671DATY39VW6GWK3M2T3DN
number: 37
sprint: syv1q8m
blocked_by:
- 01KXAN6FR3SF2G2SGM56A419Z7
comments:
- id: 01KXAYEFY5NAFAB7BFV1T6K43Z
  author: Steve Vine
  at: 2026-07-12T10:37:26.341014035Z
  text: 'Development complete on feature/ise-037-analyse-agent. PR #35: https://github.com/Steve-vine/ise/pull/35. The first agent with read-only tools + the first to write back into ISE. ai/tools.py: get_state_slices/get_slice_payload/list_open_findings over recorded state — the allow-list (no act tool exists anywhere → an analysis agent physically cannot mutate). ai/deps.py threads a DB session + system scope via RunContext; engine builds AgentDeps and passes deps to every run (deps_type=AgentDeps). ai/agents.py: analyse agent (AnalysisResult(issues[]) output, tools, evidence-citing prompt). ai/analysis.py: run_analysis = run_agent + DETERMINISTIC persistence of proposed issues as source=''ai'' Issues linked to the AgentRun, deduped against the system''s open AI issues, severity coerced to a valid value. tasks/ai/analyse.py: analyse_system + gated Beat dispatch-analyses (30min) — only systems whose open findings changed since last analysis, no-op without a provider key. POST /systems/{id}/analyse operator trigger. issue.source gains ''ai'' (migration 0009). No mutation (Phase 3). Tests: mypy/ruff clean, migration 0009 round-trips, 5 analyse tests (create+evidence links, dedup, healthy→none, read-only tool allow-list, due_for_analysis gating) + 2 trigger-endpoint tests (operator 202/enqueue, viewer 403), FULL SUITE 152 passed; frontend tsc clean + regenerated types. PR CI green. Merged to staging (f9b41c0); deploy-staging fully GREEN incl. smoke check; migration 0009 applied. AI already enabled on staging (Anthropic key in ise-env-overrides from ISE-36). DEPLOYED live check in progress: dispatch-analyses fires ~30min after beat restart; datadog has 13 open findings → due → real analyse run creating AI issues; background watcher tailing worker logs for the issues_created result. Awaiting that + merge clearance.'
- id: 01KXB0FXQMHT2XXN69B48CY5SH
  author: Steve Vine
  at: 2026-07-12T11:13:10.38866122Z
  text: 'DEPLOYED LIVE CHECK PASSED on staging. dispatch-analyses fired at 11:06 (30min after beat restart) and analysed both systems via the REAL Claude model using the read-only tools: g5/kubernetes (9dd4045f) → AgentRun 5e15f816 succeeded 12s, issues_created 1; datadog (d2bfb8d2) → succeeded, issues_created 7 (the model consolidated 13 open findings into 7 distinct issues — the judgement layer working, not 1:1 with findings). 8 source=''ai'' Issues now on staging, each linked to its AgentRun with cited evidence. Full deployed chain proven: Beat → gated dispatch-analyses → analyse_system → run_agent (real model + read-only tool loop) → deterministic issue persistence with dedup. KNOWN CHARACTERISTIC to watch: due_for_analysis gates on open-finding last_seen_at, which sync refreshes every 2min, so a system with steady findings is re-analysed each 30-min dispatch; dedup (exact title match vs open AI issues) prevents duplicate issues as long as the model''s titles stay stable — if titles drift, AI issues could accrue. Bounded + cheap + under the daily ceiling; a future refinement is to gate on actual finding-set change (hash of open source_keys) and/or dedup by a stable fingerprint. ISE-37 fully validated (local 152-test suite + deployed). Awaiting merge clearance.'
- id: 01KXB12T62Y1RXQ04SYN20MR98
  author: Steve Vine
  at: 2026-07-12T11:23:29.346133571Z
  text: 'Smoke tests passed. PR #35 merged to main (8a47579), branch deleted. Belt-and-braces main run green. Done. Deployed live check passed (8 AI issues created on staging by the real model). Dedup/gating refinement filed as ISE-44 (Sprint 0, low). Sprint 4: 3/9.'
assignee: steve
label: null
priority: medium
task_status: done
---
analyse task type (ai-engine brief): read-only connector tools + snapshot/finding lookups → structured list of Issues (title, severity, confidence, evidence refs). Persist as Issue rows with source='ai' (extend ISSUE_SOURCES) linked to the AgentRun (agent_run_id). Deterministic dedup/idempotency against existing open AI issues per system so the scheduled pass never spams duplicates. Scheduled Beat pass (per-system, gated) + POST /systems/{id}/analyse operator trigger. No mutation (Phase 3 analysis-only). Tests with a stubbed model asserting issue creation + dedup + evidence links + tool allow-listing (analysis agent cannot reach a mutating capability).