---
id: 01KY6YXHP4VK9ZX7GGQ6SHEWMQ
created: 2026-07-23T07:44:23.748176Z
updated: 2026-07-23T09:16:48.302761Z
type: task
title: 'Search recall tuning: stemming / partial-word recall'
label:
- brief
number: 74
assignee: steve
task_status: cancelled
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
sprint: sx9znt9
---
Follow-up idea from M9. The fuzzy matcher (DEV-604) handles typos and subsequences well, but doesn't do linguistic stemming — e.g. `running` won't necessarily surface `run`, plurals/singulars aren't unified, etc.

Explore improving recall:

* Stemming / lemmatization (e.g. a porter-style stem on both query terms and the indexed corpus) layered with or alongside the fuzzy ranking.
* Tune how aggressively partial words / word boundaries are rewarded.
* Decide where this lives (Rust pre-processing of the corpus + query, vs an FTS5 porter tokenizer feeding the candidate set).

Parked backlog idea — not scheduled. Builds on the M9 fuzzy search.

---

Linear DEV-608 · Backlog · created 2026-06-24 · cancelled 2026-07-06