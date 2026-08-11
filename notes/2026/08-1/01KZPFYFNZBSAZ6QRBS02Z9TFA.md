---
id: 01KZPFYFNZBSAZ6QRBS02Z9TFA
created: 2026-08-10T18:46:18.559261Z
updated: 2026-08-11T11:42:33.723744Z
type: task
title: Learned edges match entity names estate-wide — one diagnosis proposed four cross-cluster dependencies
project: 01KX671DATY39VW6GWK3M2T3DN
number: 647
sprint: s1rgnyx
comments:
- id: 01KZRA39QVYNPKCKDDFWNSPABR
  author: Steve Vine
  at: 2026-08-11T11:42:33.72364Z
  text: |-
    PR #594 (stacked on #593). Both acceptance points met.

    **Scope the match.** An ambiguous name is now resolved by the incident's own containment: exactly one twin sharing a `part-of` ancestor with the affected entity is the one it meant. None, or several, and nothing is raised. The body's instinct was right — dropping beats guessing, because a cross-cluster `depends-on` written on the strength of a shared string is worse than no edge at all, in a graph whose edges are never auto-asserted precisely because one incident is weak evidence.

    The filter only ever **resolves ambiguity**; it is deliberately not a requirement to *have* containment. A DataDog `service` has none, and demanding one would silently stop learning edges from the integration that reports the most — the failure mode of over-correcting here. There is a test pinning that.

    **Make the sentence decidable.** Evidence now reads "workload deepgram-api (in namespace deepgram-flux, cluster staging-uk)" — nearest container first, at most two. More than two turns the sentence into a path, and the reviewer needs the facts that separate twins, not the whole chain.

    **On `code-server-cory`, which the body asked me to consider: I left it raising.** Its name is unambiguous, so there is nothing to resolve, and cross-namespace dependencies are genuinely common in a way cross-cluster ones are not. It is weak evidence — but it is now weak evidence a reviewer can *see* is weak, because the sentence names both namespaces. Suppressing it needs a rule about what makes a mention strong, which is a different question from this one and worth its own task if it keeps happening.

    The symmetry with [ISE-633] is worth keeping: there a name resolved to nothing, here it resolved to everything, and both came from name matching that ignored scope. That is now two instances of the same root cause found by walking one estate — worth watching for a third.
assignee: steve
label:
- bug
priority: high
task_status: active
---
Found 2026-08-10. All five `edge` proposals in the estate queue come from one incident, IN-1208, raised 14:15 that day, all claiming something depends on `workload deepgram-engine` in cluster `8696e805`:

| Proposed source | Cluster / namespace |
| --- | --- |
| workload deepgram-api | `6860aa8e` |
| workload deepgram-api | `13ea2d5d` |
| workload deepgram-api | `8696e805` ← the target's own cluster |
| workload deepgram-api | `fb83f2ae` |
| workload code-server-cory | `8696e805`, namespace `openanswer` (target is in `deepgram-flux`) |

Only the third is plausible. **Three of these would draw cross-cluster `depends-on` edges into the estate graph if confirmed.**

**Cause.** `_mentioned_entities` (`learning.py:255-261`) iterates **every entity in the estate** and matches on `entity.name.lower() in text`. There is no scoping to the affected entity's cluster, namespace or system. The diagnosis said "deepgram-api", so all four clusters' `deepgram-api` matched. The stability-tier filter can't help — all four are type `workload`, the same tier. Each gets its own proposal, because the fingerprint is `{candidate.id}->{affected.id}:depends-on` and the candidate ids differ.

**This is systemic.** Staging has **396 name+type collisions covering 1512 of 7167 live entities — 21% of the estate** has a same-name-same-type twin. A multi-cluster estate guarantees it: the same workload name exists in staging-uk, staging-us, production-uk and production-us by design.

**And the reviewer cannot tell them apart.** `_describe` renders `"workload deepgram-api"` — byte-identical for all four rows. ISE-273 added the type to the evidence sentence precisely so same-named entities were distinguishable, and it does separate `service openanswer` from `namespace openanswer`. It does nothing for same-type-different-cluster. The operator is shown four identical sentences and asked to confirm. All five remain `proposed`, which is the only sane response.

**Scope**
- **Scope the match.** A candidate in the affected entity's own cluster/namespace should outrank one elsewhere; a name that resolves to several entities in *different* scopes should probably raise nothing rather than raise N — an ambiguous mention is not evidence of a dependency. Note the parallel with [ISE-633]: there a name resolved to nothing, here it resolves to everything, and both come from name matching that ignores scope.
- **Make the sentence decidable.** Where the type does not disambiguate, the evidence must name the scope — cluster and namespace — or the proposal cannot be reviewed at all.
- Consider whether `code-server-cory` should have been raised: a same-cluster, different-namespace workload mentioned in passing is weak evidence for a dependency.

**Acceptance**: a diagnosis naming an entity whose name exists in four clusters raises at most the one in scope; every edge proposal's evidence names enough to tell it from its twins.