---
id: 01KY731CNY8JCPY6A0D6S7N8A8
created: 2026-07-23T08:56:23.998952Z
updated: 2026-07-23T11:00:29.647791Z
type: task
title: Sync conflict copies of a project keep identifier and next_task_number; counter bumps lost in keep-both
assignee: steve
task_status: done
number: 338
imported_from: null
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
label: null
---
## Incident (2026-07-17 ~19:00 UTC)

Editing a sprint description on the Mac while a task was created in the same project on the Linux machine (task creation bumps the project's `next_task_number`, so it writes the project note too) produced a git conflict on the ISE project note. The DEV-984 counter merge bailed — the sprint text was a real content difference — so the keep-both path ran on both machines, minting two live "ISE (conflict copy)" projects. Two consequences:

1. **Duplicate identifier.** Both copies kept `identifier: ISE`, so saving the real project failed with "identifier is already used by another project". Unlike DEV-990's trashed variant, these copies were live — the trashed-filter fix would not have helped.
2. **Lost counter bump.** The remote side's `next_task_number: 107` survived only inside a conflict copy; the kept live note stayed at 106 while task #106 existed. The next task created would have duplicated number 106.

Vault was repaired by hand (counter set to 107, copies deleted).

## Fix

1. `Note::rekey_as_conflict_copy` (notuvia-core `note.rs`) should drop `identifier` and `next_task_number`, exactly as DEV-942 already drops a task's `number`: they are project-sequence identity, not content, and a copy that keeps them poisons the uniqueness check and shadows the allocator.
2. In `resolve_conflicts` (gitsync.rs), when the DEV-984 counter merge fails and the keep-both path applies to a note, still resolve the allocator fields into the kept side — `next_task_number` = max(ours, theirs) — so a concurrent bump is never lost, instead of only applying that resolution when it explains the whole conflict.

## Out of scope (follow-up)

Symmetric double-minting (each machine writes its own conflict copy, doubling every conflict) and general field-aware merging of disjoint frontmatter edits — tracked separately.

---

Linear DEV-991 · created 2026-07-17 · done 2026-07-17