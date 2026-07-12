---
id: 01KX671DATY39VW6GWK3M2T3DN
created: 2026-07-10T14:31:22.714867Z
updated: 2026-07-12T07:55:56.839012179Z
type: project
title: ISE
project_status: active
priority: medium
assignee: steve
identifier: ISE
due: 2026-10-31
next_task_number: 40
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
---
ISE (Infrastructure State Engine) is an internal platform that gives infrastructure operators a **single pane of glass** over the systems that run the organisation: it connects to them, pulls their state, detects issues, proposes (and — within strict limits — applies) fixes, and provides one governed place to make changes to sensitive core systems.
