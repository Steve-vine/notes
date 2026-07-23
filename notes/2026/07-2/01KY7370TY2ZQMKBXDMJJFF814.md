---
id: 01KY7370TY2ZQMKBXDMJJFF814
created: 2026-07-23T08:59:28.478857Z
updated: 2026-07-23T12:25:00.112219Z
type: task
title: Semantic three-way note merge; keep-both only for body-region conflicts (ADR 0045 stage 3)
assignee: steve
task_status: done
label: null
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 361
---
Stage 3 of ADR 0045 — the core of the design. `resolve_conflicts` parses base/ours/theirs for a conflicted note and resolves per field instead of delegating to line-level git resolution:

* A field changed on one side only takes that side.
* `updated` → the later stamp; `next_task_number` → the larger (folds in the DEV-984/DEV-991/DEV-997 special cases rather than accreting beside them).
* **Comments**: append-only union by comment id, ordered by timestamp — the ISE-73 class ends here.
* A **scalar field changed on both sides** to different values → the side with the later `updated` wins silently (agreed trade-off: recoverable from git history, never surfaced).
* The **body**: text-level three-way merge (non-overlapping edits compose — e.g. `git merge-file` over the bodies alone, per ADR 0013's system-git philosophy).
* **Keep-both survives only** when both sides edited the same body region: the copy is a valid note (never conflict markers), numberless (DEV-996), and expected to be rare.

Taxonomies.yaml and workspaces.yaml keep their current handling (out of scope). All existing guards (no-op save, push retries) remain as fast paths and defence in depth.

Test expectations: a matrix of divergence cases (field one-sided / both-sided scalar / comment adds both sides / disjoint body edits / same-region body edits / combinations), each asserting the resolved note and whether a copy was created. The DEV-1015 chaos harness exercises the same matrix end-to-end.

---

Linear DEV-1014 · created 2026-07-19 · done 2026-07-19