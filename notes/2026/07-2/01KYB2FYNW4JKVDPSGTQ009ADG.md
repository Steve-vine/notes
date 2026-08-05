---
id: 01KYB2FYNW4JKVDPSGTQ009ADG
created: 2026-07-24T22:03:50.33292Z
updated: 2026-08-05T11:55:49.235612Z
type: task
title: Incident-learned edge proposals are name-collision blind ("openanswer depends on openanswer")
project: 01KX671DATY39VW6GWK3M2T3DN
number: 273
sprint: s5khymf
comments:
- id: 01KYB3M6BZWGEWC5XZY121HF03
  author: Steve Vine
  at: 2026-07-24T22:23:37.855277Z
  text: |-
    Fixed on feature/ise-273-edge-proposal-name-collision (PR #246 → main).

    All three failure modes addressed in learning.py `propose_incident_edges`:
    1. Circular-by-construction: candidate names are now matched against the DIAGNOSIS text only, never the title/description — the title just restates the subject.
    2. Same-name candidates are skipped from the edge channel. Where the pair is a DataDog service beside the k8s workload/namespace of the same name (two views of one thing), it's routed to the identity channel as an `alias` proposal ("are these the same entity?" → confirm merges them). A same-name pair of the same type (two clusters' namespaces) is neither dependency nor identity and is dropped.
    3. Every surviving edge proposal names entity types in its evidence ("service … depends on database …").

    Wiring: the `alias` proposal kind was already declared in PROPOSAL_KINDS and already a filter on ProposalsPage but had no confirm handler — added `_apply_alias`, which folds the two entities via the estate's own merge path (exposed as `discovery.merge_entities`). No API/OpenAPI change (the alias kind pre-existed).

    Tests (integration, real Postgres): IN-1048 case raises no self-named depends-on and one alias candidate instead; a same-type same-name pair raises nothing; surviving edge evidence names types; confirming an alias merges the entities and re-points a linked signal. All 23 tests in test_proposals.py pass; ruff + mypy green.

    Acceptance met. Note: re-running generation on the real IN-1048 will produce an identity candidate for the service↔namespace pair — the operator can confirm (merge) or reject.
assignee: steve
priority: medium
task_status: done
---
Found live 2026-07-24 in the proposals queue: "IN-1048 was raised on openanswer and its diagnosis names openanswer. That suggests openanswer depends on openanswer…" — a proposal no human can evaluate.

**Cause:** `propose_incident_edges` (`learning.py:104`, ISE-218) excludes the affected entity by *id* but matches candidates by *name substring* over title+description+diagnosis. The estate holds three entities named `openanswer` (two cluster-scoped namespaces + `datadog:service:openanswer`); IN-1048's title ("Pod openanswer/twiliotaskcleanup-… is Pending") inevitably names the affected namespace, the same-named DataDog service passes the id check and wins stable-first ranking → self-referential proposal.

**Why it's wrong three ways:**
1. **Circular by construction** — an incident's title virtually always contains the affected entity's name, so any same-named entity gets proposed on every incident touching this one; zero evidence value.
2. **Usually an identity question, not a dependency** — the DataDog service and the app in that namespace are almost certainly the same real thing, unjoined. Confirming a depends-on between two views of one entity would corrupt the graph. This case should route to the ADR 0028 §3 identity-candidate channel ("are these the same entity?"), not the edge channel.
3. **Illegible evidence text** — bare names can't disambiguate; types must be included ("service openanswer depends on namespace openanswer").

**Fix:**
- Skip candidates whose (case-folded) name equals the affected entity's name in the edge path; where types suggest two views of one thing (service vs workload/namespace), emit an identity/alias proposal instead via the existing candidate-match mechanism.
- Match candidate names against diagnosis/root-cause text only, not the title — the title restates the subject, it never reveals a dependency.
- Include entity types (and cluster/system where ambiguous, cf. the two scoped namespaces) in the evidence sentence for all surviving proposals.

Acceptance: re-running proposal generation on IN-1048 raises no self-named depends-on; a same-named service/workload pair produces an identity candidate instead; surviving edge proposals name types in their evidence.