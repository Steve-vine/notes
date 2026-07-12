---
id: 01KX671DATY39VW6GWK3M2T3DN
created: 2026-07-10T14:31:22.714867Z
updated: 2026-07-12T21:29:16.379554Z
type: project
title: ISE
project_status: active
priority: medium
assignee: steve
identifier: ISE
due: 2026-08-31
next_task_number: 55
start: 2026-07-10
sprints:
- id: sh9ng2k
  title: Application Scaffold
  description: 'Phase 0 — Foundations: an empty app that ships. Complete 2026-07-10.'
  duration_days: 2
- id: sqtx330
  title: Core Platform
  description: 'Phase 1 — Core platform: a logged-in shell over the domain model. Complete 2026-07-11 (11/11).'
  duration_days: 2
- id: sdm5e08
  title: State Sync
  description: 'Phase 2 — State sync (DataDog + Kubernetes, read-only): the pane of glass shows real state. Connector interface + registry (ADR 0014), DataDog (MCP-first) and Kubernetes (native) connectors doing read-state/detect, scheduled sync via Beat with snapshot/finding persistence + staleness, and live UI (Overview cards, System detail, Issues queue). Deterministic loop only — no AI. Complete 2026-07-12 (13/13).'
  duration_days: 2
- id: syv1q8m
  title: AI Analysis
  description: 'Phase 3 — AI analysis: ISE detects issues itself. AI engine on Pydantic AI (ADR 0013) — per-task-type model config, AgentRun recording, budgets/ceilings. Task types summarise-state / analyse / diagnose (read-only tools, no mutation). AI-created Issues with evidence; agent-run viewer; AI summaries + run-analysis/diagnose actions; model-config + spend UI. Exit test: scheduled analysis produces a correct evidenced Issue from a real anomaly; Claude↔OpenAI switch is config-only.'
  duration_days: 2
- id: sdcd2jr
  title: Remediation
  description: 'Phase 4 — Remediation with tiered approval (ADR 0017): the loop closes. ISE gains WRITE credentials for the first time. Connector act() + parameter schemas; risk-policy engine (policy may raise a tier, never lower) with default-deny auto-apply and a protected_targets blast-radius guard; ProposedChange state machine with separation of duties (proposer != approver for T2/T3); deterministic executor on the actions queue (no model in the loop); propose-remediation agent (drafts parameters, cannot fire them); Approvals queue UI. ADR 0016 names the approval state machine the top testing priority in the product. Exit test: AI proposes a fix → approver approves in UI → executor applies it → issue resolves → complete audit chain.'
  duration_days: 2
---
ISE (Infrastructure State Engine) is an internal platform that gives infrastructure operators a **single pane of glass** over the systems that run the organisation: it connects to them, pulls their state, detects issues, proposes (and — within strict limits — applies) fixes, and provides one governed place to make changes to sensitive core systems.

Sprints 1-7 defined initial MVP Roadmap, additional Sprints to follow.
 
