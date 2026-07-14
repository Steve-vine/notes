---
id: 01KX671DATY39VW6GWK3M2T3DN
created: 2026-07-10T14:31:22.714867Z
updated: 2026-07-14T19:26:56.475366Z
type: project
title: ISE
project_status: active
priority: medium
assignee: steve
identifier: ISE
due: 2026-08-31
next_task_number: 60
start: 2026-07-10
sprints:
- id: sh9ng2k
  title: Application Scaffold
  description: 'Phase 0 — Foundations: an empty app that ships. Complete 2026-07-10.'
- id: sqtx330
  title: Core Platform
  description: 'Phase 1 — Core platform: a logged-in shell over the domain model. Complete 2026-07-11 (11/11).'
- id: sdm5e08
  title: State Sync
  description: 'Phase 2 — State sync (DataDog + Kubernetes, read-only): the pane of glass shows real state. Connector interface + registry (ADR 0014), DataDog (MCP-first) and Kubernetes (native) connectors doing read-state/detect, scheduled sync via Beat with snapshot/finding persistence + staleness, and live UI (Overview cards, System detail, Issues queue). Deterministic loop only — no AI. Complete 2026-07-12 (13/13).'
- id: syv1q8m
  title: AI Analysis
  description: 'Phase 3 — AI analysis: ISE detects issues itself. AI engine on Pydantic AI (ADR 0013) — per-task-type model config, AgentRun recording, budgets/ceilings. Task types summarise-state / analyse / diagnose (read-only tools, no mutation). AI-created Issues with evidence; agent-run viewer; AI summaries + run-analysis/diagnose actions; model-config + spend UI. Exit test: scheduled analysis produces a correct evidenced Issue from a real anomaly; Claude↔OpenAI switch is config-only.'
- id: sdcd2jr
  title: Remediation
  description: |-
    Phase 4 — Remediation with tiered approval (ADR 0017): the loop closes. ISE gained WRITE credentials for the first time. Complete 2026-07-14 (15/15 — 8 planned + 7 defects the exit test found).

    EXIT TEST PASSED: AI proposed an edit_resource fix citing rollout history as evidence -> Steve approved in the UI -> the executor patched the Deployment -> pods went ready, the issue resolved -> full audit chain. T3 leg: delete_resource refused against kube-system AND ise ('no approval can override this'), then executed against the disposable namespace with the manifest captured as the rollback substrate.

    DELIVERED: connector act() + real JSON-Schema parameter catalogues; risk-policy engine (raise-only tiers, default-deny auto-apply, protected-targets blast-radius guard, ADR 0021); ProposedChange state machine with separation of duties; deterministic executor (FOR UPDATE lock, no model in the loop); propose-remediation agent (drafts, cannot fire — boundary asserted in a test); Approvals queue UI; proposal flow + execution results.

    SEVEN DEFECTS THE EXIT TEST FOUND, ALL FIXED — and every one of them passed its unit tests:
    - ISE-54 the blast-radius guard was INERT (default_policy() was never called; ADR 0021 documented a control the code did not have)
    - ISE-59 the UI was stricter than the server and DEADLOCKED EVERY T3 CHANGE (the test asserted the bug)
    - ISE-58 read-state too thin to remediate — the agent could see THAT a workload was broken, never WHAT to change it to, and correctly refused to guess
    - ISE-44 309 duplicate AI issues; 72 wasted analyse runs burning 98.5% of the daily budget
    - ISE-57 the spend ceiling refused the human it existed to serve
    - ISE-56 the credential UI could not express a credential, or rotate one
    - ISE-55 sync and the executor shared one identity

    END STATE: nothing auto-applies (default-deny + a near-empty T0 band = zero autonomous write capability, by design); every system is unchangeable until an admin grants write on purpose; on g5, ise-connector-ro reads the cluster and changes nothing, ise-connector-rw changes ise-acceptance and cannot see anything else.
---
ISE (Infrastructure State Engine) is an internal platform that gives infrastructure operators a **single pane of glass** over the systems that run the organisation: it connects to them, pulls their state, detects issues, proposes (and — within strict limits — applies) fixes, and provides one governed place to make changes to sensitive core systems.

Sprints 1-7 defined initial MVP Roadmap, additional Sprints to follow.
 
