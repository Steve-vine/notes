---
id: 01KZDP7GR6CEAPK5J1KR1B63ZM
created: 2026-08-07T08:42:56.134933Z
updated: 2026-08-07T08:58:14.998246Z
type: memo
title: ISE Role Matrix
project: 01KX671DATY39VW6GWK3M2T3DN
---
Status: **draft for review** (2026-08-07, Assist sprint planning). Defines every ISE interface as a row in one capability matrix, replacing per-surface hand-curated tool lists. To be adopted as an ADR once agreed.

## The three interfaces

- **Assist** — quick read-only Q&A over the estate. Surfaces information; can never act.
- **Incident Screen** — the in-app investigation surface (issue chat). Investigates and remediates through the governed pipeline.
- **Claude Code (MCP)** — deep investigation over the governed MCP server (ADR 0055). Same powers as the Incident Screen, plus BreakGlass for holders of the grant.

## The interface matrix

Columns T0–T3 are the action risk tiers of ADR 0017 (a tier is a property of the operation, declared in the connector's action catalogue — policy can raise a tier, never lower it). A cell says what happens when that interface proposes an action of that tier.

| Interface | Read | Write | Execute: read-only integration functions | T0 — Safe | T1 — Low | T2 — Sensitive | T3 — Critical | BreakGlass |
|---|---|---|---|---|---|---|---|---|
| **Assist** | All ISE systems & information | **None** | All (Evidence catalogue) | — | — | — | — | — |
| **Incident Screen** | All ISE systems & information | Incident log only | All (Evidence catalogue) | Auto-apply, audited | Auto-apply if integration policy allows; else approval | Human approval, always | Approval with separation of duties | — |
| **Claude Code (MCP)** | All ISE systems & information | Incident log only | All (Evidence catalogue) | Auto-apply, audited | Auto-apply if integration policy allows; else approval | Human approval, always | Approval with separation of duties | Per-user grant; armed window (ADR 0089): T0–T2 auto-approve silently, T3 auto-approves after confirm-back; protected-target guard lifts; EntraID self-escalation guard **never** lifts |

“—” means the capability does not exist on that interface at all: Assist has no propose/approve/execute path of any tier.

## User roles — the second axis

Roles are **cumulative** (ADR 0015): `viewer < responder < operator < approver < admin` — a role implies everything below it. The API is the authority; the UI merely hides what a role can't do.

| Role | Adds (on top of everything below) |
|---|---|
| **viewer** | Read everything: search, incident briefs, estate/graph reads, evidence fetches. Read own Assist threads. |
| **responder** | Service Desk rung (ADR 0056): run desk-executable playbooks (in-app only), resolve incidents, record notes. |
| **operator** | Ask Assist. Incident actions (status, merge), commit diagnosis, **propose changes** (any tier). |
| **approver** | **Approve or reject** proposed changes — T2 and T3 alike (the approve endpoint requires `approver`). Separation of duties: the proposer may never approve their own T2/T3 change. |
| **admin** | Administration (users, tokens, AI limits — in the ISE UI only; no extra MCP tools). **Exception:** an admin *may* self-approve a T2/T3 change — with one human operator the alternative is that no T3 could ever be approved — but the approval is distinctly audited as `self_approval: true`. |

**How the axes compose:** effective capability = **interface ceiling ∩ role**. The interface matrix says what is *possible on that surface*; the role says what *this person* may do anywhere. Examples: a viewer on the Incident Screen sees everything but cannot propose; an operator in Claude Code can propose a T3 but needs an approver to pass it; an approver on Assist still cannot act, because the surface has no execute path.

**BreakGlass is a grant, not a role rung.** It is issued per-user, on top of whatever role the user holds, and only matters on the Claude Code surface. Arming still requires the app step-up; the actions inside the window still flow through the user's own proposal rights.

**Open question for the sprint:** asking Assist currently requires `operator` (reading threads needs only `viewer`). That gate predates the mission statement — now that Assist structurally cannot act, the operator gate is protecting AI spend, not safety. Should ask drop to `viewer` (or `responder`) so the Service Desk can use it? Spend is already governed by the three-gate budget (ADR 0033).

## Rulings (agreed 2026-08-07)

1. **Proposals sit under gated Execute, not Write.** Creating a `ProposedChange` row is the front half of the execution gate, not a domain write. The Write column stays crisply “incident log only”.
2. **Write means domain writes.** ISE’s own audit/telemetry exhaust is excluded — e.g. pulling Evidence writes a mandated `credential_accessed` audit row (ADR 0018); that does not breach Assist’s “Write: None”.
3. **BreakGlass changes who approves, never what exists** (ADR 0089). The action catalogue is still the wall; arming happens in the app (step-up), consumption over MCP; window ends on expiry, disarm, or incident resolution.

## Invariants the matrix imposes

- **Read parity**: every read-tier tool available to any interface is available to all three. Enforced by a derived parity test, not a frozen list — a new read tool anywhere lands on all surfaces automatically.
- **Evidence parity**: “all read-only integration functions” means the full per-connector Evidence catalogue (ADR 0031: side-effect-free by contract, results untrusted, credential access audited). New connectors/read packs inherit into all three interfaces for free.
- **Role overlay is uniform**: the same role means the same thing on every interface — no surface may grant a capability the user's role denies elsewhere.
- **MCP completeness**: the Claude Code row must be fully true — the gated write path (propose → approve → execute) is verified on the MCP surface in the Assist sprint, not assumed.

Related: ADR 0015 (RBAC), 0017 (tiers), 0023 (Assist read-only mechanism), 0031 (Evidence contract), 0049 (chat write boundary), 0055 (Claude investigation surface), 0056 (responder role), 0089 draft (BreakGlass).