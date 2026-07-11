---
id: 01KX671DATY39VW6GWK3M2T3DN
created: 2026-07-10T14:31:22.714867Z
updated: 2026-07-11T13:50:32.558511Z
type: project
title: ISE
project_status: active
priority: medium
assignee: steve
identifier: ISE
due: 2026-10-31
next_task_number: 31
sprints:
- id: sh9ng2k
  title: Application Scaffold
  description: 'Phase 0 — Foundations: an empty app that ships. Complete 2026-07-10.'
- id: sqtx330
  title: Core Platform
  description: 'Phase 1 — Core platform: a logged-in shell over the domain model. Complete 2026-07-11 (11/11).'
- id: sdm5e08
  title: State Sync
  description: 'Phase 2 — State sync (DataDog + Kubernetes, read-only): the pane of glass shows real state. Connector interface + registry (ADR 0014), DataDog (MCP-first) and Kubernetes (native) connectors doing read-state/detect, scheduled sync via Beat with snapshot/finding persistence + staleness, and live UI (Overview cards, System detail, Issues queue). Deterministic loop only — no AI.'
---
ISE (Infrastructure State Engine) is an internal platform that gives infrastructure operators a **single pane of glass** over the systems that run the organisation: it connects to them, pulls their state, detects issues, proposes (and — within strict limits — applies) fixes, and provides one governed place to make changes to sensitive core systems.
