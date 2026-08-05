---
id: 01KYAFNMPJ9KV1AKZFF5Z45M6P
created: 2026-07-24T16:34:53.778006Z
updated: 2026-08-05T12:03:01.908285Z
type: task
title: Track ExternalSecrets in the estate — first behaviour preset beyond workloads
project: 01KX671DATY39VW6GWK3M2T3DN
number: 261
sprint: s5khymf
blocked_by:
- 01KYAE3QN39PSD50A5BY5WTJRE
- 01KYAE4B5NNNKCJDE2P8217AN3
comments:
- id: 01KYAT599M9M0MBJVADWASG0XQ
  author: Steve Vine
  at: 2026-07-24T19:38:12.148254Z
  text: |-
    Work complete; moved to Review. Branch `feature/ise-261-externalsecrets-preset` pushed to origin. (PR creation is blocked by a transient GitHub API incident — GraphQL and REST both returning errors; I'll link the PR here once it recovers.)

    Delivered (backend-only; no API/schema change):
    - Non-workload custom discovery (`_custom_other_entities`): ExternalSecret → `other` entity with scoped key, part-of-namespace, tags, lifecycle — no workload bundle. `_contained` per entry (CRD absent → nothing, criterion c).
    - Behaviour presets (the third rung), `connectors/k8s_behaviours.py` keyed by GVK:
      • PRODUCED_SECRETS — a workload whose pod template references the Secret an ExternalSecret produces gets a `depends-on` edge to it, derived from CR spec + pod templates only (never reads Secret objects). Gated on an ES entry being present (zero cost otherwise).
      • HEALTH — ExternalSecret with Ready≠True → a medium Observation on its entity.
    - Preset `external-secrets.io/v1beta1 ExternalSecret → other` (renders via the existing generic preset UI — no frontend change).
    - Blueprint brief `docs/briefs/kind-preset-blueprint.md`: the map → promote-type → behaviour ladder, ExternalSecret as the worked example, with the "when to promote a canonical type" bar.

    Tests: pure behaviour units, connector discovery (ES entity, workload depends-on incl namespace-scoping, health obs, CRD-absent degradation), preset validity, and an end-to-end sync integration test landing the depends-on EntityEdge. All gates green (ruff/format/mypy over 288 files, 313 unit + integration). No OpenAPI drift.

    Acceptance on env-staging-us is a staging smoke test (add the ExternalSecret preset → probe → sync → ExternalSecrets appear with depends-on edges from consuming workloads).
- id: 01KYAVSH1T8QF63KWJYAKCY7H2
  author: Steve Vine
  at: 2026-07-24T20:06:44.026869Z
  text: 'PR now open: #244 → main (https://github.com/Steve-vine/ise/pull/244). GitHub API recovered. Already released to staging (CI green).'
- id: 01KYAYGHEN4B2F76JCQWWPC82Z
  author: Steve Vine
  at: 2026-07-24T20:54:15.253618Z
  text: 'Smoke test complete on env-staging-us (Steve, 2026-07-24) — moving to Done. ExternalSecrets appear as `other` entities with depends-on edges from consuming workloads; CRD-absent clusters unaffected. Released to main (PR #244).'
assignee: steve
label: null
priority: medium
task_status: done
---
ExternalSecrets have been operationally problematic in the past; bring them onto the pane of glass as first-class estate citizens. This is deliberately the **first non-workload kind preset**, so it doubles as the template for future kinds (Ingress, Certificates, …).

**Success criteria (Steve, 2026-07-24):**
a. ExternalSecrets are tracked as real entities with relationships — not just rows.
b. The work produces a **blueprint for adding other kinds in the future** (documented pattern: what's config, what's preset code, what's promotion-to-canonical-type).
c. **Zero impact on clusters without External Secrets Operator installed** — CRD absent must mean "preset unavailable/inactive", never a sync failure or error noise (the ISE-257 graceful-degradation path).

**Scope:**
- Ships as a preset in the Kind Dictionary (mechanism from ISE-256/257): `ExternalSecret.external-secrets.io → other` (no canonical-type promotion yet — only one integration knows the concept; note the level-2 promotion bar in the blueprint doc).
- Entity per ExternalSecret with scoped native key, part-of-namespace edge, tags, lifecycle.
- **Relationship derivation** (the behaviour code, and the heart of criterion a): workloads whose pod templates reference the ExternalSecret's target Secret name (env/envFrom/volume `secretKeyRef`) get a `depends-on` edge to the ExternalSecret. Optionally an edge to its (Cluster)SecretStore if modelled. RBAC note: derived entirely from the ExternalSecret CR spec + pod templates — the connector must NOT read actual `Secret` objects (existing RBAC exclusion stands).
- **Stretch (decide in plan mode):** sync-health Observation — ExternalSecret with `Ready=False`/stale sync condition surfaces as an Observation on the entity. This is the "problematic in the past" payoff; if cut, raise as follow-up.
- Blueprint deliverable: a short doc (or ADR appendix to ISE-256's ADR) recording the ladder — map (config) → promote type (ADR) → behaviour preset (developer code) — using this task as the worked example.

Acceptance on env-staging-us: ExternalSecrets appear in the estate with depends-on edges from consuming workloads; a cluster without the CRD shows the preset as unavailable and syncs cleanly.

Depends on ISE-256 (in progress, other session) and ISE-257.