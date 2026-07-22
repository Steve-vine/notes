---
id: 01KY514VRBX9E4E7V7Q7ZSWAND
created: 2026-07-22T13:44:51.723001Z
updated: 2026-07-22T14:56:40.226026Z
type: task
title: Tag Dictionary foundation — canonical keys/values, ingest resolution, seeding (+ ADR)
project: 01KX671DATY39VW6GWK3M2T3DN
number: 211
sprint: s5khymf
assignee: steve
label:
- feature
priority: high
task_status: active
---
The Sprint 20 foundation slice. Canon: "The Tag Dictionary" + "Knowledge sources & authority".

- **ADR (next free NNNN)**: knowledge sources & authority model + the Tag Dictionary — codifies the Canon sections at decision level (four sources, claims/provenance, authority tiers, conflicts surfaced; dictionary = mapping never rewriting).
- **Migration (next free)**: dictionary tables — governed key (name, description, value mode `defined|open`, key aliases, expected entity types) and defined values (value, description, aliases); `tag.canonical_id` self-FK on the pool.
- **Ingest resolution** (`tags.py`): dictionary key/value aliases resolve deterministically at reconcile time — raw pool rows preserved exactly as reported, mapped rows point at their canonical. Idempotent as today.
- **Canonical matching**: `tag_rules.matching_entity_ids`, group derivation, and Tag Cloud aggregation resolve through `canonical_id` — a `service:kora` rule matches a `Service:Kora`-tagged entity with no rule edits.
- **Seed**: `env`/`service`/`cluster`/`role`/`team` + common synonym sets (prod|production, dev|development, key aliases environment→env, cluster_name/kube_cluster_name→cluster).
- **UI slice (DoD)**: TagBadge shows the canonical label with "reported as `env:Prod` by DataDog" in the provenance tooltip.
- Tests: alias-tagged entity matches canonical rule; two identical syncs reconcile to zero churn; unmapping restores raw behaviour.