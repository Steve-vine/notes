---
id: 01KXWTKVXKPQCNV27X9Y3CHGXA
created: 2026-07-19T09:16:47.923849788Z
updated: 2026-07-21T16:17:09.928261Z
type: task
title: 'ADR: Estate Knowledge Base'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 124
sprint: sp5m61e
assignee: steve
priority: high
task_status: done
---
**Sprint 12 foundation.** Codify the Canon's Estate Knowledge Base as ADR 0028.

- Three registers: **structural** (entities / integration aliases / typed edges), **contextual** (annotations), **tuning** (the ISE-115 severity overrides + Ignores — already built, the structured face of the same knowledge).
- **Identity resolution**, cheapest-first: harvest shared keys/cross-tags automatically → heuristic AI-proposed candidate match (human confirms) → human-asserted aliases (authoritative, sticky). Discovered-vs-authored: **authored wins, conflict surfaced**.
- **Graph-as-cache**: seeded by discovery, enriched during investigation (resolve-once, persist), validated by the Obs Loop (drift → low-severity Observation; Sprint 14).
- **Postgres, not a graph DB** — a few tables + recursive CTEs (ADR 0002).
- **Maintained through conversation** (Query / Validate / Enrich, ADR 0022/0024); enrichment is a lightweight **audited ISE-internal-metadata write class**, distinct from tiered-action governance (ADR 0017/0021).
- The entity id is the **join key** across signals + evidence; enables directed, bounded investigation traversal (blast radius) instead of blind tool loops.