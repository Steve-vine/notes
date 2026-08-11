---
id: 01KZRTW9HN1F8A9E7XRV3MPBZ6
created: 2026-08-11T16:35:49.941741Z
updated: 2026-08-11T16:35:49.941741Z
type: task
title: 'Business Application: define with a list of tag rules'
label: feature
priority: medium
assignee: steve
task_status: backlog
project: 01KX671DATY39VW6GWK3M2T3DN
number: 654
---
Membership becomes a **list of rules** instead of one conjunctive predicate, so a Business Application can span compute and infrastructure and a shared database can belong to several.

**Backend**
- `Application.predicates` (flat list) → list of rule groups (JSONB). Migration wraps each existing list as one group — zero rows today, so it is a shape change only.
- `member_ids()` already resolves one conjunction — call it per rule and **union** the results. (Note: `matching_entity_ids` ANDs its predicates — `tag_rules.py:65` — so rules must be evaluated separately, not concatenated.)
- `apply_membership()` unchanged: it reconciles whatever `member_ids` returns, and already protects `asserted` edges from being retracted by a sync (`applications.py:355`).
- **Per-rule validity**: a rule resolving to zero live entities raises an Observation naming the rule. Replaces the whole-Application emptied Observation.
- A rule is `{role: application|platform, or any governed key} + value + environment`; the environment dimension follows the rule's role.
- `detect_candidates()` unchanged — still proposes a single-rule Business Application from an (app, env) pair as a seed; the operator adds the rest.

**UI** (Business Applications page): create a Business Application, add / edit / remove rules, with each rule's live match count and a fault marker on any rule matching nothing.

**Estate prerequisites, known and expected to surface as rule faults**
- No entity carries both `app:` and `env:` today, so the seeded application-role rule matches nothing until workloads gain `env:`.
- Selecting a single database works **today** via `crossplane-name:` — already sitting in the proposals queue as an unknown-key mapping proposal covering 49 entities. Confirm it and rules can name one RDS instance with no retagging.