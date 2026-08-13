---
id: 01KZXPA7D99GPH553VS8192FYH
created: 2026-08-13T13:52:15.785247Z
updated: 2026-08-13T18:03:56.648307Z
type: task
title: The incident's Impact panel — what is affected, correctable and extendable by hand
project: 01KX671DATY39VW6GWK3M2T3DN
number: 691
sprint: sevhjex
assignee: steve
label:
- improvement
priority: high
task_status: todo
---
Two halves of one job: the operator can neither correct a wrong attachment nor state what else an incident touches. Both live in the same panel.

## Part 1 — a wrongly attached entity cannot be removed

Once an incident has an estate entity — attached by hand or resolved automatically — there is no way in the app to correct or remove it.

**The API already supports it.** `POST /findings/{id}/entity` with an explicit null clears the attachment and returns the row to automatic resolution (`findings.py:247-259`); its docstring names this exact case: *"Clearing (an explicit null) is always allowed, and is the repair for an attachment made in error."* It audits distinctly as `signal_entity_cleared`.

**The UI never offers it.** `UnlinkedEntityPanel` (`IssueDetailPage.tsx:1479`) opens with `if (issue.entity_id || !issue.entity_link_reason) return null` — it renders *only* while the incident has no entity. Attaching one makes the sole control vanish. The capability exists and is unreachable.

Two live routes to a wrong entity: a human picks the wrong search row (the attach has no confirmation step), or automatic resolution binds the wrong thing — a real risk with short hostnames, since `cross_keys_for` publishes the short form of every registered name (`servers.py:439`), so two machines sharing a short name across domains can collide.

- Surface the current entity with a way to **change** and to **clear** it, reusing the existing search picker.
- Render `entity_pinned_by` — already plumbed to the read model (`issues.py:314`, `schemas.py:481`), never shown. "Attached by steve@…" vs resolved automatically tells the operator whether clearing re-resolves to the same thing or to nothing.
- Clearing withdraws impact, entity-scoped playbooks and the AI's affected-entity context. Say so at the point of clearing.
- Operator-gated, matching the attach. Verify the return to the unlinked state, since the panel's render condition is what hid the control.

## Part 2 — the Impact panel itself (from staging, 2026-08-13)

With `mpwxdatawh` manually attached, the box reads:

> **Affects** — Not in any group or Business Application, and carrying no environment tag. No known dependents. The estate graph may simply be incomplete — add what you know on the entity page. *0 dependent entities*

Factually correct and badly misleading, because **the panel never names its subject**. `ImpactPanel` takes an `entityId` and renders the answer without ever saying which entity it is about (`components/ImpactPanel.tsx`). The operator reads a paragraph of negatives with no idea what they are negative about. This should be the most important box on the page — it is the answer to "what is affected".

Requested changes:
- **Move it to the top**, first under the "Auto-promoted from …" line. It currently renders last in the header stack, after `MergeIntoControl`, `LearningPanel` and the raw-evidence toggle (`IssueDetailPage.tsx:1962`) — despite the comment above it claiming impact is "a header question … not buried in the feed". The comment states the intent; the layout contradicts it.
- **Rename "Affects" → "Impact"** (the `title` prop default, `ImpactPanel.tsx:58`).
- **Name the subject**, linked to its entity page. This is the actual fix for the reported complaint.
- **Two sections: directly affected first, then inferred.**
- **Manual add from the estate, into either section, at any time** — including when the section already has entries.
- **Collapsible.**
- **Drop the "add what you know" link** (`ImpactPanel.tsx:166`); every listed entity links to its entity page. Note `DependentRow` already links (line 20) and the rollup badges already link — the missing link is the subject's own.
- **Drop "View in estate graph →"** (`ImpactPanel.tsx:219`).
- **Everything in this list is in scope when working the ticket.**

## Decisions to make before building, not during

**1. Does a manual add assert a graph edge, or attach to this incident only?** The panel is computed from the durable edge graph, so "add an entity here" could mean either. Recommend **incident-scoped**: an operator saying "this is affected" during an outage is making a claim about *this event*, not asserting durable topology, and letting an incident screen write to the estate graph is how the graph quietly becomes wrong. The graph-enrichment path already exists on the entity page — which is precisely the link being removed, so the removal must not be the only way to enrich the graph.

**2. "Inferred" cannot be a manual category as worded.** Inferred means ISE derived it; a human-added entity is by definition not inferred. Either the sections are *directly affected* / *indirectly affected* (a depth distinction, with provenance shown per row as derived-or-added-by), or manual additions always land in "directly affected". The current data already carries depth — `DependentRow` prints depth 1 as "depends on it" and anything deeper as "indirectly" (line 25).

**3. `unconfirmed` is a third axis and must not be folded in silently.** The panel separately renders proposed-but-unconfirmed relationships as a yellow alert: *"ISE has proposed these relationships and nobody has confirmed them. They are hints, not facts."* That distinction is load-bearing and survives the restructure — it is confirmation, not depth.

**4. "In scope when working the ticket" is backend work, not UI.** It changes what the AI reasons over and what impact/playbook matching consider. Sizeable enough to split into its own task; flagged here rather than assumed.

**5. The panel is shared.** `EntityDetailPage.tsx:767` mounts it as `variant="full"` with `title="Impact preview"` for the what-if view, where "no known dependents" has a different call to action and there is no incident to scope additions to. Changes must not degrade that surface; the manual-add affordance likely belongs to the compact/incident variant only.

Related: ISE-690 — fixing the case-insensitive join starts binding entities automatically that were previously unbound, raising the odds of a wrong automatic binding at exactly the moment there is still no way to undo one. Build Part 1 before or with it.