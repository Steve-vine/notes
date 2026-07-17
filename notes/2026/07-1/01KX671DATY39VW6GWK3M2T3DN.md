---
id: 01KX671DATY39VW6GWK3M2T3DN
created: 2026-07-10T14:31:22.714867Z
updated: 2026-07-17T18:59:10.941442Z
type: project
title: ISE
project_status: active
priority: medium
assignee: steve
identifier: ISE
due: 2026-08-31
next_task_number: 106
start: 2026-07-10
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
  description: 'Phase 5b — operational hardening deferred from Phase 5. ISE runs the full loop and holds WRITE credentials; make it survivable in prod. Gaps mapped in Sprint 6 exploration: Postgres backup/restore (CNPG single-instance, no backup today; MUST include the KEK or a restore yields undecryptable credentials); rate limits (only break-glass is limited — security-model.md already claims more than the code does); ISE→DataDog log shipping + self-monitoring (makes ADR 0015''s break-glass ALERT real — today it''s an ERROR line nothing collects); break-glass verification drill + last-used tracking + Settings→Access UI; NetworkPolicies; registry retention (Zot accumulates tags, ADR 0008 names the gap); golden-run eval fixtures as a manual/nightly job, never in the PR gate. Decisions taken: DataDog self-monitoring; evals nightly not gated. Likely 1-2 ADRs. Follow staging-first deploys. Completes Phase 5 + MVP operational readiness.'
- id: scxrykd
  title: Spend issues
  description: Having just come to use the system today, I managed to trigger 3 or 4 actions before running out of budget.  There seems to be an issue using up almost all of the budget while the system is idle.  Seeing as there are currently only 2 systems connected to ISE, that raises serious concerns over the viability of the way the product works.  In this ses
---
ISE (Infrastructure State Engine) is an internal platform that gives infrastructure operators a **single pane of glass** over the systems that run the organisation: it connects to them, pulls their state, detects issues, proposes (and — within strict limits — applies) fixes, and provides one governed place to make changes to sensitive core systems.

Sprints 1-7 defined initial MVP Roadmap, additional Sprints to follow.
 
