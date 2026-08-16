---
id: 01M0508Y9YSXKE3DWD4Q2KN98N
created: 2026-08-16T10:01:00.478273Z
updated: 2026-08-16T13:00:25.233891Z
type: task
title: A Capabilities Catalogue in the title bar — generated from the registry, not copied from the memo
project: 01KX671DATY39VW6GWK3M2T3DN
number: 739
sprint: sevhjex
assignee: steve
label:
- feature
priority: medium
task_status: active
tech: null
---
A **Capabilities** button on the title bar, immediately left of Search, opening a large modal: the catalogue of what ISE can actually do, per integration. Requested 2026-08-16. Content per the Notuvia memo *"ISE Integration Capabilities Catalogue"* (`01KZED7V0M99D3NM6YA5SA9CST`).

Sized generously — this is a reference document, and the memo's tables are wide. It should read as a document, not a cramped dialog.

## Build it from the connector registry, not from the memo text

The memo is a **hand-maintained transcript of what the code already declares** — its own header says *"as implemented in code (connector registry, verified against the code 2026-08-09)"*. It is already stale: `node_present` shipped for Kubernetes in ISE-712 and is not in it.

Every table in that memo has a live source:

| Memo section | Declared in code |
|---|---|
| capability list | `capabilities()` |
| Evidence tables | `EvidenceQuery` — name + description |
| Action tables | `ActionSpec` — name, description, **tier**, parameters, reversibility, expected effect, rollback note |
| Observations | `signal_kinds()` |
| State sync | `sync_spec()` |

Copying prose into a component would put ISE's own answer to "what can you do" a manual step behind the truth — and ADR 0086 already settled this class of question: *a canonical vocabulary is served through the contract, never hand-copied*. ADR 0083 (connectors declare their own System-detail summary) is the same instinct one layer down.

A generated catalogue also gains something the memo cannot have: it can show what **this deployment** actually has configured, and distinguish a capability that exists in code from one that is live here.

## What the memo has that code does not

Roughly a third of it is editorial and genuinely valuable — the reasoning, not the inventory:

- *"No arbitrary-execution primitive, ever"* — no `run_playbook`, no `run_command` (ADR 0084 §2).
- *"Register-first: Ansible is agentless, so inventory is an input."*
- M365 — *"Actions: None, permanently by design (ADR 0066)"*.
- Packs — *"no actions and no write path, permanently"*, with the structural rather than conventional argument.
- The evidence-vs-actions distinction at the top: evidence is live, bounded, read-only and immediate; actions are proposals that pass through approval.
- EntraID's self-escalation guard; the servers check-mode preview and why `reboot_server` declares itself un-previewable.

Those want a short declared blurb per connector — following ADR 0083's precedent, owned by the connector rather than by the frontend — plus a standing preamble for the evidence/actions distinction and the tier legend (T0/T1 auto-appliable, T2/T3 always human-approved).

## Scope

- Title-bar button left of Search; large modal; grouped by integration, with evidence, actions (showing tier) and observations per group.
- Served from an endpoint over the registry. Viewer-readable — this is a "what can this thing do" reference, not a configuration surface.
- Include the **planned-but-unbuilt** section the memo carries (voice escalation / on-call, ADRs 0079/0080, ISE-545..549 Backlog). Stating what is coming is part of an honest catalogue, and it must be visibly separated from what exists — a reader must never mistake one for the other.
- Once it is generated, the memo becomes redundant as a source and should say so, pointing at the app rather than being maintained in parallel. Two answers to one question is how the second one goes quietly wrong.

## Worth deciding

Whether this lists **capabilities as built** (every connector ISE ships) or **capabilities as configured** (only integrations this deployment has). The memo answers the first; an operator asking "what can ISE do for me" usually means the second. Showing both, clearly marked, is probably right — and only the generated version can do that at all.