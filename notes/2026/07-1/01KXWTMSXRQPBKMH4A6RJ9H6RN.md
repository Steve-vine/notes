---
id: 01KXWTMSXRQPBKMH4A6RJ9H6RN
created: 2026-07-19T09:17:18.648493866Z
updated: 2026-07-19T11:52:28.880751625Z
type: task
title: Conversational Query / Validate / Enrich (+ asserted & AI-proposed aliases)
priority: medium
label:
- feature
task_status: review
assignee: steve
project: 01KX671DATY39VW6GWK3M2T3DN
number: 131
blocked_by:
- 01KXWTKZTHER145ZR0ARR81TMM
- 01KXWTM37WBJ1KBP8HNPW4GJNB
- 01KXWTMMAS23S9KQ1G39MDJ9F1
sprint: sp5m61e
tech: null
---
**Sprint 12 (additive).** Maintain the graph through conversation, not forms — the real answer to CMDB rot (ADR 0022/0024).

- AI chat tools: **Query** (read — "what does Kora depend on?" / "what runs on g5?"), **Validate** (AI shows its assumption, human confirms/corrects), **Enrich** (natural language → structured graph updates).
- **Enrichment = a lightweight, audited ISE-internal-metadata write class** — confirmed ("I'll record that Kora depends on X/Y/Z — confirm?"), provenance recorded, and deliberately **outside** tiered-action governance (it's metadata, not infrastructure — ADR 0017/0021 untouched).
- **Identity resolution tiers 2 & 3**: heuristic AI-proposed candidate matches (human confirms — never auto-merge on a guess) and human-asserted aliases (authoritative, sticky).
- **Discovered-vs-authored**: on conflict, authored wins and the conflict is surfaced.

Depends on entities + edges + annotations. (Graph drift-detection — the Obs Loop surfacing divergence as low-severity Observations — is Sprint 14.)