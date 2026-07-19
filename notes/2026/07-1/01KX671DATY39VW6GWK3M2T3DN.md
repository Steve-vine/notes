---
id: 01KX671DATY39VW6GWK3M2T3DN
created: 2026-07-10T14:31:22.714867Z
updated: 2026-07-19T13:03:50.083980834Z
type: project
title: ISE
project_status: active
priority: medium
assignee: steve
identifier: ISE
due: 2026-08-31
next_task_number: 141
start: 2026-07-10
tech: null
sprints:
- id: sh9ng2k
  title: Application Scaffold
  description: 'Phase 0 — Foundations: an empty app that ships. Complete 2026-07-10.'
- id: sqtx330
  title: Core Platform
  description: Phase 1 — a logged-in shell over the domain model. Complete 2026-07-11 (11/11).
- id: sdm5e08
  title: State Sync
  description: Phase 2 — DataDog + Kubernetes read-only sync; the pane of glass shows real state. Deterministic, no AI. Complete 2026-07-12 (13/13).
- id: syv1q8m
  title: AI Analysis
  description: Phase 3 — ISE detects issues itself. Pydantic AI (ADR 0013); summarise-state / analyse / diagnose, read-only.
- id: sdcd2jr
  title: Remediation
  description: Phase 4 — tiered-approval remediation (ADR 0017); ISE gained WRITE credentials. Complete 2026-07-14 (15/15, incl. 7 exit-test defects). Default-deny; nothing auto-applies.
- id: syz8rn1
  title: Assist + Search
  description: Phase 5a — assist chat (SSE, ADR 0022; read-only DB boundary, ADR 0023) + global search behind a Cmd-K palette. Complete 2026-07-15 (13/13), released to main. Hardening moved to Sprint 8.
- id: syqgx3z
  title: Workflow Review & Polish
  description: 'Feature-complete after Sprints 1-6. Stop building; judge how the whole app WORKS and FEELS as one product. A structured end-to-end walkthrough on staging — sign in → estate → issue → diagnose → propose → approve → execute → audit, then assist and search — noting rough edges, cross-screen inconsistency, interaction friction, and empty/loading/error states. That review GENERATES the task list: targeted tweaks, not new architecture. Steve leads the feel judgement; Claude drives the walkthrough, captures findings, implements agreed changes. Tasks TBD.'
- id: s0v93ii
  title: Issue Loop
  description: |-
    Update the issue handling workflow to include a proper remediation loop.
    analyse -> diagnose -> propose -> approve -> execute -> (repeat)
- id: sd1gs0p
  title: Hardening
  description: |-
    Phase 5b — operational hardening deferred from Phase 5. ISE runs the full loop and holds WRITE credentials; make it survivable in prod. Gaps mapped in Sprint 6 exploration: Postgres backup/restore (CNPG single-instance, no backup today; MUST include the KEK or a restore yields undecryptable credentials); rate limits (only break-glass is limited — security-model.md already claims more than the code does); ISE→DataDog log shipping + self-monitoring (makes ADR 0015's break-glass ALERT real — today it's an ERROR line nothing collects); break-glass verification drill + last-used tracking + Settings→Access UI; NetworkPolicies; registry retention (Zot accumulates tags, ADR 0008 names the gap); golden-run eval fixtures as a manual/nightly job, never in the PR gate. Decisions taken: DataDog self-monitoring; evals nightly not gated. Likely 1-2 ADRs. Follow staging-first deploys. Completes Phase 5 + MVP operational readiness.

    NOTE (Sprint 10 review): deferred as a block behind the cost re-architecture (Sprints 11-14) — hardening a product whose viability is unproven is premature. Nothing obsoleted, nothing closed. ISE-73 (backup+KEK) pulled forward to Sprint 10 as catastrophic-loss insurance. ISE-80 (evals) a candidate to pull into the re-architecture as regression safety. ISE-74 (rate limiting) overlaps the new auto-investigation trigger caps.
- id: scxrykd
  title: Spend issues
  description: |-
    Having just come to use the system today, I managed to trigger 3 or 4 actions before running out of budget.  There seems to be an issue using up almost all of the budget while the system is idle.  Seeing as there are currently only 2 systems connected to ISE, that raises serious concerns over the viability of the way the product works.  In this sprint I want to analyse how the product currently works, and what changes need to be made to the functionality in order to make it viable from a cost perspective.  Seeing as the outcome of this could potentially end of with the product being shelved, I want to revisit some of the fundamental principles of the project including existing design decisions.

    OUTCOME: analysis produced the ISE Canon (target model) + a re-architecture roadmap across Sprints 11-15. This sprint now carries the immediate spend-relief work: prompt caching (ISE-107), model tiering (ISE-108), the DataDog idle-drain-leak fix, plus ISE-73 (backup+KEK) pulled forward.
- id: stgj737
  title: Signals & Incidents foundation
  description: 'Re-architecture spine (per the ISE Canon). Split detection into transient Signals — Alerts (from a source''s own detection layer) and Observations (ISE-detected where there is none) — flowing onto durable, human-owned Incidents; replace the 1:1 Finding→promotion→Issue mapping. Add the canonical severity ladder, a global auto-incident threshold + confidence bar, and a scoped severity-override layer. Reshape connectors to declared capabilities and cut DataDog to monitors-only Alerts (per-group) + evidence-on-demand, retiring metric/event detection (a large idle-spend cut). ADRs: Signals & Incidents; Severity, confidence & thresholds; Connector capability contract. The load-bearing spine — proves the cost thesis early.'
- id: sp5m61e
  title: Estate Knowledge Base
  description: 'The Estate Knowledge Base (per Canon): entities + integration aliases + typed edges + context annotations, in Postgres. Identity resolution — harvest cross-tags automatically, AI-proposed candidate matches, human-asserted aliases (sticky). Discovered-vs-authored reconciliation; graph-as-cache validated by the Obs Loop (drift surfaces as Observations). Conversational query / validate / enrich over the chat surface (audited internal writes, not infra actions). The join-spine that makes cross-integration investigation directed and cheap. ADR: Estate Knowledge Base.'
- id: sdv8hgy
  title: Incident Loop (learning)
  description: 'The Incident Loop learning layer (per Canon): wrap the existing diagnose→propose→execute→verify with Recall (memory + playbook retrieval) at the front and Update (write memory, playbooks, newly-learned structure) at the back. Two-phase incident signatures (trigger for retrieval, diagnostic for learning) built from stable attributes; memory hung off the entity graph; playbooks (six-part, referencing the governed action catalogue, efficacy-tracked, human-confirmed). Directed investigation via the knowledge base. Self-tiering — cost per incident falls as memory grows. ADR: Incident Loop + memory + playbooks.'
- id: srmqjcq
  title: Obs Loop & Observations
  description: 'Obs Loop & Observations (per Canon): a slow, per-integration scheduled detector loop — mostly cheap deterministic detectors + context-driven suppression, AI reserved for genuine novelty — producing Observations, a baseline of record, and knowledge-base drift checks. Kubernetes observation detectors (CrashLoopBackOff, OOMKill, pending pods, failing probes, cert expiry, resource saturation…). Retire the 15-/30-min summarise/analyse timers entirely. ADR: Obs Loop.'
- id: sehghhk
  title: Integration modularity
  description: 'Integration modularity (per Canon; downstream of viability — deliberately last). Harden the connector capability contract; a generic MCP-backed Integration Type for Evidence (and, with per-action classification, Actions); move toward independently-deployable integrations behind a versioned contract (out-of-process, MCP for tool capabilities, authorization stays in core, never the shared DB). Platform extensibility. ADR: Independently-deployable integrations.'
---
ISE (Infrastructure State Engine) is an internal platform that gives infrastructure operators a **single pane of glass** over the systems that run the organisation: it connects to them, pulls their state, detects issues, proposes (and — within strict limits — applies) fixes, and provides one governed place to make changes to sensitive core systems.

Sprints 1-7 defined initial MVP Roadmap, additional Sprints to follow.
 
