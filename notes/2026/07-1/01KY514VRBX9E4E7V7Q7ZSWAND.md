---
id: 01KY514VRBX9E4E7V7Q7ZSWAND
created: 2026-07-22T13:44:51.723001Z
updated: 2026-07-23T13:54:51.599936Z
type: task
title: Tag Dictionary foundation — canonical keys/values, ingest resolution, seeding (+ ADR)
project: 01KX671DATY39VW6GWK3M2T3DN
number: 211
sprint: s5khymf
comments:
- id: 01KY56FX409KSCG4Y0XVT8GDCZ
  author: Steve Vine
  at: 2026-07-22T15:18:16.448645Z
  text: |-
    Done — PR #193 (feature/ise-211-tag-dictionary), branched from main. Unblocks ISE-212, 213, 216, 219.

    **ADR 0041** written: knowledge sources & authority + the Tag Dictionary. It generalises ADR 0028 from three registers to one model of *claims with provenance* (source / method / freshness) and states the authority order — human-asserted > currently-observed > rule-derived > incident-learned > document-stated. That ordering is the thing the rest of the sprint slots into: document claims and incident-learned edges now have a defined place rather than a negotiation. It also records explicitly that ISE never writes tags back to source (that would be an infrastructure mutation and would need the governed action catalogue), which is the boundary ISE-214 stops at.

    **Migration 0043**: `tag_key` (name, description, `defined|open` mode, aliases, expected_types) + `tag_value` (value, description, aliases) + `tag.canonical_id` self-FK with `ON DELETE SET NULL`, indexed both ways.

    **Seeding is at startup, not in the migration** — a deliberate departure from where you might expect it. The seed is application policy a human edits afterwards in the UI; a migration is the wrong home for something that gets edited. `tag_dictionary.seed()` is additive and idempotent so it never overwrites an edit, and it's contained: a seed failure logs and lets the API serve, because raw tags work without the dictionary. Seeded `env` (defined, with prod/staging/dev/test synonym sets), `service`, `cluster`, `role`, `team`, plus the key aliases actually seen in this estate (`environment`, `kube_cluster_name`, `dd_service`…).

    **Resolution happens once**, in `tags.get_or_create`, so entity tags and finding tags both get it and a future third caller can't forget. Canonical rows are minted even when nothing reported that exact spelling — an estate that only ever says `env:Prod` still needs `env:prod` to exist for a rule to match. Exactly one hop; a canonical row never points at anything, so a later rename can't build a chain.

    **Two consumer changes worth flagging beyond the task text:**

    1. **Rule matching now counts distinct PREDICATES, not distinct tag ids.** This is load-bearing and wasn't in the task: an entity tagged `env:Prod` by DataDog and `env:prod` by Kubernetes carries two pool rows satisfying one predicate, and the old `COUNT(DISTINCT tag_id) == len(tag_ids)` would have matched a *two*-predicate rule on that alone. Pinned by a test.
    2. **The Tag Cloud had to roll up or the dictionary would have made it worse** — the same tag appearing twice, each at half its true heat. Done with a `canon` CTE; aliases never appear in their own right. The drilldown resolves across all spellings too.

    **UI slice (DoD)**: `TagBadge` shows the canonical label, and the tooltip appends "reported as `env:Prod` by DataDog" where a source differed — ADR 0041 §3 (conflicts surfaced, never silently resolved) applied to vocabulary. `tags_for_entities` collapses onto the canonical and carries `reported_as` per system.

    **Tests** — 12 new integration (`test_tag_dictionary.py`) + 1 frontend, covering all three you listed plus the edge cases: resolution as a pure function; canonical names never shadowed by another key's alias; raw preserved with no chaining; two integrations → one badge; zero churn on re-sync; canonical rule matching an alias-tagged entity; the one-predicate-not-two rule; cloud combined weight; seeding idempotent and non-destructive; unmapping restoring raw behaviour; ungoverned keys untouched.

    Backend 908 passed, ruff + mypy strict clean; frontend 297 passed, lint/build clean; OpenAPI regenerated.

    Note for the next tasks: the Settings tab value `"tags"` is already taken by Tag rules, so ISE-212's dictionary editor needs a different tab value (`tag-dictionary`).
assignee: steve
priority: high
task_status: done
---
The Sprint 20 foundation slice. Canon: "The Tag Dictionary" + "Knowledge sources & authority".

- **ADR (next free NNNN)**: knowledge sources & authority model + the Tag Dictionary — codifies the Canon sections at decision level (four sources, claims/provenance, authority tiers, conflicts surfaced; dictionary = mapping never rewriting).
- **Migration (next free)**: dictionary tables — governed key (name, description, value mode `defined|open`, key aliases, expected entity types) and defined values (value, description, aliases); `tag.canonical_id` self-FK on the pool.
- **Ingest resolution** (`tags.py`): dictionary key/value aliases resolve deterministically at reconcile time — raw pool rows preserved exactly as reported, mapped rows point at their canonical. Idempotent as today.
- **Canonical matching**: `tag_rules.matching_entity_ids`, group derivation, and Tag Cloud aggregation resolve through `canonical_id` — a `service:kora` rule matches a `Service:Kora`-tagged entity with no rule edits.
- **Seed**: `env`/`service`/`cluster`/`role`/`team` + common synonym sets (prod|production, dev|development, key aliases environment→env, cluster_name/kube_cluster_name→cluster).
- **UI slice (DoD)**: TagBadge shows the canonical label with "reported as `env:Prod` by DataDog" in the provenance tooltip.
- Tests: alias-tagged entity matches canonical rule; two identical syncs reconcile to zero churn; unmapping restores raw behaviour.