---
id: 01KZRTVVRG2CQ57H760CQ1WQ91
created: 2026-08-11T16:35:35.82466Z
updated: 2026-08-11T20:22:27.496246Z
type: task
title: 'ADR: Business Applications (amends ADR 0073)'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 652
sprint: sj9fsph
comments:
- id: 01KZS7V40ZJ2CG5W05A6MS9540
  author: Steve Vine
  at: 2026-08-11T20:22:23.007096Z
  text: |-
    Done — ADR 0096 "Business Applications: membership is a list of rules". PR #604, merged to main as 76687bc.

    Number check: 0095 was the highest on origin/main and no open branch held 0096, so 0096 was free.

    Records, per the design: the rename (Entity stays the technical umbrella; the discovered `application` type keeps its name); membership as a union of rules with predicates ANDing *within* a rule; per-rule validity replacing whole-Application emptiness; the environment dimension stated on the rule rather than inferred per entity; dependencies derived by downstream traversal and never stated; external Applications as eligible members.

    It also writes down the diagnosis chain in full — Business Services composer empty → zero rows in `application` → zero proposals ever raised → zero entities carry both `app:` and `env:` (254 workloads + 49 kubernetes-services vs 367 hosts + 8 networks + 6 clusters, perfectly disjoint) — and the four deferred dependency sources (SG ingress, ExternalName, ConfigMap values, RDS read-replica source) so the next person doesn't re-derive them.

    Two extras beyond the brief, both one-liners in files I was already editing:
    - ADR 0095 (Reports) never got its README row — added.
    - ADR 0073's row now reads "amended by 0096".
assignee: steve
label:
- brief
priority: high
task_status: review
---
Record the amendment to ADR 0073 as a new `docs/decisions/NNNN-*.md` (append-only — amend, never rewrite). Headless: the only task in this sprint with no screen. Check `origin/main` for the next free ADR number before writing — a sprint releasing mid-flight takes it.

**What it records**

- **Rename.** Entities make up **Business Applications** make up **Business Services**. `Entity` stays the technical umbrella — 0073 §5 already reserves it ("Entity remains the technical umbrella in the model, the API and the code"), so nothing below the middle layer is renamed. The discovered `application` entity type KEEPS its name for externally-operated applications.
- **Membership is a list of rules, unioned.** Each rule = {role or governed key} + value + environment. One conjunctive predicate cannot express the many-to-many case 0073 §6 itself flagged: *"a tag can seed it but cannot express many."* Rules are stated against Tag Dictionary **roles** (Environment + Application/Platform) so rebinding a role re-derives every Business Application — but a rule may name **any governed key**, because the Platform role is estate-grained (`project:envproductionpri` covers 120 entities) and cannot select one database.
- **Per-rule validity.** A rule resolving to zero live entities raises an Observation naming *that rule*. Replaces 0073's whole-Application "emptied" Observation, which cannot say what went dark.
- **The environment dimension moves onto the rule.** Application-role rule → application dimension (`prod`); Platform-role rule → infrastructure dimension (`production`). Same ISE-472 discriminator, stated rather than inferred per entity.
- **Dependencies are derived, never stated.** Downstream traversal from whatever membership resolves to, over `runs-on` / `depends-on` / containment `part-of` (excluding group + identity-group targets), never `composes`. It is the mirror of the impact walk — one stored fact, read in two directions.
- **External Applications are eligible members.** A SaaS dependency stated honestly, and provider incidents then roll up to Business Services.

**Consequence worth stating explicitly:** the asserted `depends-on` edge is no longer needed for shared infrastructure — rules cover shared resources as members, traversal covers the infrastructure beneath them.

**Deliberately deferred** (real uncaptured dependency sources found during design; none required by this model): AWS security-group ingress (`describe_security_groups` — never called), Kubernetes ExternalName `spec.externalName` (kubernetes-service entities store only `namespace`), ConfigMap hostname matching (values dropped for leanness, `kubernetes.py:1995`), RDS `ReadReplicaSourceDBInstanceIdentifier`.