---
id: 01KY6YX69EHNX5XPGRZ1QJ36CS
created: 2026-07-23T07:44:12.078404Z
updated: 2026-07-23T12:24:57.062842Z
type: task
title: 'Inline query-token filtering (type:/status:/taxonomy: + free text)'
task_status: done
label: null
number: 72
assignee: steve
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
sprint: s6nm897
---
Let the search box combine free text with cross-taxonomy filters via inline tokens, e.g. `type:task status:open meeting`.

**Plan**

* Parse `key:value` tokens out of the query (type, the built-in taxonomies status/priority/assignee, and user taxonomy keys); the remaining words are the free-text query that the fuzzy matcher (DEV from fuzzy issue) ranks.
* Filter the candidate set by the tokens (AND across keys; a note must carry the given taxonomy value / be of the given Type), then fuzzy-rank the free text within the filtered set.
* Tolerant parsing: unknown keys fall back to plain text; quoted values for spaces.
* Lightweight affordance in the UI (hint/placeholder); highlighting of recognised tokens optional.

Second M9 issue (chosen UX: inline query tokens). Builds on the fuzzy ranking.

---

Linear DEV-605 · M9 — Search & retrieval polish · created 2026-06-23 · done 2026-06-24