---
id: 01KZZX41WYJ05MAZ94QN60H2JM
created: 2026-08-14T10:29:42.430203Z
updated: 2026-08-14T10:29:47.284625Z
type: task
title: Impact should say what the entity is part of — the cluster is one hop away and never shown
project: 01KX671DATY39VW6GWK3M2T3DN
number: 707
sprint: sevhjex
assignee: steve
label:
- improvement
priority: medium
task_status: backlog
tech: null
---
**IN-1342** — *"Node ip-172-21-119-61.ec2.internal is not Ready"*. Which cluster is that node in? The incident cannot say. The operator has to leave for the estate entity page to find out. Reported 2026-08-14.

**The answer is one hop away in the graph.** Verified on staging: the incident's entity is `8b54f376` (`ip-172-21-119-61.ec2.internal`, type `host`), and it carries three `part-of` edges:

| target | type |
|---|---|
| `cluster-envstagingus-ekscluster` | cluster |
| `network-envstagingus-vpc` | network |
| `Staging` | group |

**Why the panel cannot show it today.** Both existing sections are slices of the same array — `direct = dependents.filter(depth === 1)`, `indirect = dependents.filter(depth > 1)` (`ImpactPanel.tsx:287-288`). `dependents` is the **upstream** walk: what depends on this entity, the blast radius. Containment is the **opposite direction** — what this entity sits inside. No depth filter over an upstream walk can ever surface it, which is why the cluster is invisible however the existing sections are sliced.

So this is genuinely a third section, not a variant of the two. Directly/indirectly affected answer *"what does this break?"*; **part of** answers *"where is this?"* — and on a node-not-Ready that second question is the one an operator asks first.

**The walk already exists — reuse it.** `environments.py` walks `part-of` upward for environment inheritance: `MAX_CONTAINMENT_DEPTH = 6` (line 29) and a `NON_CONTAINMENT_TYPES` exclusion list (line 47) covering `group`, `application`, `business-application`, `business-service`, `identity-group`.

That exclusion is exactly right here and worth keeping: it encodes "a group is a lens, not a location", the same principle as the dashboard dependency walk's `DEPENDENCY_EXCLUDED_TYPES`. It also avoids duplication for free — `Staging` is a group and **already** renders as a rollup badge at the top of the panel, so a `part of` section built on this walk shows the cluster and the network and does not repeat it.

**Scope**
- A third section in the Impact panel: **Part of**, listing the entity's containment ancestry, each row linking to its entity page like the existing rows.
- **Decide depth.** The node has three `part-of` edges at depth 1, so containment here is a *set*, not a single chain. Either render depth 1 only (the immediate parents — the cluster and the network) or the full ancestry as a path. Depth 1 answers the reported question; the full walk risks a long list on a deep estate.
- **Read-only.** Unlike "Also affected" (ISE-691's incident-scoped manual additions), containment is a fact about the estate, not a judgement about this incident — an operator cannot make a node part of a cluster by saying so here. No add/remove controls; corrections belong on the entity page.
- Empty state consistent with the rest of the panel: a host with no containment edges says so rather than rendering nothing.

**Sequence it against the reshaping.** ISE-699/ISE-700 are restructuring this panel (shared shell, one box, collapse). Adding a section mid-restructure will conflict — land this after them, or fold it into ISE-700's rebuild.