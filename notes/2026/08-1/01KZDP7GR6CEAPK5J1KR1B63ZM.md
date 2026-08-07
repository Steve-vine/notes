---
id: 01KZDP7GR6CEAPK5J1KR1B63ZM
created: 2026-08-07T08:42:56.134933Z
updated: 2026-08-07T08:42:56.134933Z
type: memo
title: ISE Role Matrix
project: 01KX671DATY39VW6GWK3M2T3DN
---
Status: **draft for review** (2026-08-07, Assist sprint planning). Defines every ISE interface as a row in one capability matrix, replacing per-surface hand-curated tool lists. To be adopted as an ADR once agreed.

## The three interfaces

- **Assist** — quick read-only Q&A over the estate. Surfaces information; can never act.
- **Incident Screen** — the in-app investigation surface (issue chat). Investigates and remediates through the governed pipeline.
- **Claude Code (MCP)** — deep investigation over the governed MCP server (ADR 0055). Same powers as the Incident Screen, plus BreakGlass for holders of the grant.

## The matrix

Columns T0–T3 are the action risk tiers of ADR 0017 (a tier is a property of the operation, declared in the connector's action catalogue — policy can raise a tier, never lower it). A cell says what happens when that interface proposes an action of that tier.

| Interface | Read | Write | Execute: read-only integration functions | T0 — Safe | T1 — Low | T2 — Sensitive | T3 — Critical | BreakGlass |
|---|---|---|---|---|---|---|---|---|
| **Assist** | All ISE systems & information | **None** | All (Evidence catalogue) | — | — | — | — | — |
| **Incident Screen** | All ISE systems & information | Incident log only | All (Evidence catalogue) | Auto-apply, audited | Auto-apply if integration policy allows; else approval | Human approval, always | Approver/admin approval; proposer can never self-approve | — |
| **Claude Code (MCP)** | All ISE systems & information | Incident log only | All (Evidence catalogue) | Auto-apply, audited | Auto-apply if integration policy allows; else approval | Human approval, always | Approver/admin approval; proposer can never self-approve | Per-user grant; armed window (ADR 0089): T0–T2 auto-approve silently, T3 auto-approves after confirm-back; protected-target guard lifts; EntraID self-escalation guard **never** lifts |

“—” means the capability does not exist on that interface at all: Assist has no propose/approve/execute path of any tier.

## Rulings (agreed 2026-08-07)

1. **Proposals sit under gated Execute, not Write.** Creating a `ProposedChange` row is the front half of the execution gate, not a domain write. The Write column stays crisply “incident log only”.
2. **Write means domain writes.** ISE’s own audit/telemetry exhaust is excluded — e.g. pulling Evidence writes a mandated `credential_accessed` audit row (ADR 0018); that does not breach Assist’s “Write: None”.
3. **BreakGlass changes who approves, never what exists** (ADR 0089). The action catalogue is still the wall; arming happens in the app (step-up), consumption over MCP; window ends on expiry, disarm, or incident resolution.

## Invariants the matrix imposes

- **Read parity**: every read-tier tool available to any interface is available to all three. Enforced by a derived parity test, not a frozen list — a new read tool anywhere lands on all surfaces automatically.
- **Evidence parity**: “all read-only integration functions” means the full per-connector Evidence catalogue (ADR 0031: side-effect-free by contract, results untrusted, credential access audited). New connectors/read packs inherit into all three interfaces for free.
- **User-role overlay**: the matrix is the interface’s **ceiling**, intersected with the user’s role (viewer / operator / approver / admin). A viewer on the Incident Screen still can’t propose; a non-grant-holder in Claude Code has no BreakGlass. Ownership rules (e.g. owner-private Assist threads) sit below this layer too.
- **MCP completeness**: the Claude Code row must be fully true — the gated write path (propose → approve → execute) is verified on the MCP surface in the Assist sprint, not assumed.

Related: ADR 0017 (tiers), 0023 (Assist read-only mechanism), 0031 (Evidence contract), 0049 (chat write boundary), 0055 (Claude investigation surface), 0089 draft (BreakGlass).