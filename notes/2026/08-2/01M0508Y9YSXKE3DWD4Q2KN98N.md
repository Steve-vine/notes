---
id: 01M0508Y9YSXKE3DWD4Q2KN98N
created: 2026-08-16T10:01:00.478273Z
updated: 2026-08-16T13:27:07.858535Z
type: task
title: A Capabilities Catalogue in the title bar — generated from the registry, not copied from the memo
project: 01KX671DATY39VW6GWK3M2T3DN
number: 739
sprint: sevhjex
comments:
- id: 01M05C2BTJEFNK7Z2PZ8XN2VRT
  author: Steve Vine
  at: 2026-08-16T13:27:07.855369Z
  text: |-
    BUILT 2026-08-16 — PR #691 (stacked on #690 / ISE-742).

    **Generated, as scoped.** A `Capabilities` button left of Search opens a large modal built entirely from declarations that already exist: `capabilities()`, `evidence_catalogue()`, `action_catalogue()` (name, description, tier, expected effect, reversibility, rollback note), `signal_kinds()`, `sync_spec()`. New endpoint `GET /api/v1/capabilities`, viewer-readable — it names operations and tiers and exposes no credential, no parameter value and no estate content.

    **The editorial third is now a declaration, not prose in a component.** Connectors gained `catalogue_note()` (the ADR 0083 precedent — owned by the connector, in the same file as the code it describes, so it cannot drift): M365's "actions: none, permanently by design (ADR 0066 §1)", the pack's structural refusal (`action_catalogue` returns nothing and no pack field could populate it), servers' register-first + no-arbitrary-execution-ever, EntraID's all-T3 with the second write principal and the self-escalation guard, Status Page's "nothing here to act on". The standing preamble and the tier legend are served WITH the catalogue rather than written into the UI, so the two cannot disagree about what ISE does.

    **Decided the "as built vs as configured" question: show both, plus a third state.** Each integration says whether this deployment has one and whether it is switched ON. "Configured, disabled" collapsed into "configured" would tell an operator ISE is watching a cluster it is not — and that distinction is only available to a generated catalogue.

    **The one thing that needed care.** `evidence_catalogue()` takes a context because a generic MCP source lists its server's tools, so it cannot be answered without connecting — and this surface must never connect: a reference page that dials out to every configured integration when somebody opens it is a page nobody dares click. It probes with an empty context and treats a raised exception as "declares nothing statically" (the `playbook_envelope` pattern), then says **"discovered at investigation time"**. An empty evidence table with no explanation is exactly the misreading this whole surface exists to prevent — an absence in a generated inventory reads as "not built yet" when the truth is usually "refused on purpose", which is also why the notes above matter more than they look.

    **Planned-but-unbuilt** is a separate API field, rendered last and apart: voice escalation (ADRs 0079/0080, ISE-545..549), with "no code yet" in its own words. A reader must not be able to mistake an intention for a capability, so the confusion is not made available rather than merely discouraged.

    Tests assert the LINK to the declarations, never a fixed list — a hard-coded expectation would be the memo again, one directory further in.

    **Memo superseded.** `01KZED7V0M99D3NM6YA5SA9CST` now opens with a banner pointing at the app and stating why the generated version is better (cannot go stale — it was already wrong about `node_present`; distinguishes as-built from as-configured; carries the refusals in code). The body stays as the historical record of 2026-08-09 and is no longer maintained.
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