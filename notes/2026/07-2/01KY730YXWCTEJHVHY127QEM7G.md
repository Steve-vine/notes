---
id: 01KY730YXWCTEJHVHY127QEM7G
created: 2026-07-23T08:56:09.916363Z
updated: 2026-07-23T15:02:18.802029Z
type: task
title: Trashed projects still own their identifier, blocking saves of the live project
project: 01KY6W9951TW0904DT0GGJVGE7
number: 337
sprint: segj1dz
comments:
- id: 01KY7QZCXH9A9W2HED45E5ZANG
  author: Steve Vine
  at: 2026-07-23T15:02:18.801588Z
  text: 'PR #354 (branch not-337-trashed-identifier): identifier_owner now filters trashed IS NULL, and restore_trashed clears the identifier + next_task_number when a live project has since claimed it (also covers NOT-339 point 3). Two new tests; full notuvia-core suite green (333).'
assignee: steve
label:
- bug
priority: medium
task_status: review
---
## Symptom

Saving a project note (e.g. adding a sprint) fails with:

> identifier "ISE" is already used by another project

even though only one live project uses that identifier.

## Cause

`identifier_owner` in `src-tauri/crates/notuvia-core/src/index.rs` (~line 1511) is the only notes-table query that does **not** filter `trashed IS NULL`:

```sql
SELECT id FROM notes WHERE note_type = 'project' AND identifier = ?1 LIMIT 1
```

So a trashed project still "owns" its identifier. `Runtime::update_note` calls `ensure_identifier_free(idf, Some(&own_id))`; when the query returns a trashed note's id instead of the live project's, the save is rejected.

Real-world trigger: three trashed "ISE (conflict copy)" project notes (from a git-sync conflict) still carried `identifier: ISE`, blocking every save of the live ISE project. Workaround was emptying the trash.

## Fix

Add `AND trashed IS NULL` to the `identifier_owner` query so trashed projects release their identifier, matching every other index query.

Consider the flip side: restoring a trashed project whose identifier has since been claimed by another project. The restore path should handle the collision (e.g. clear or reject the identifier on restore) rather than silently reintroducing a duplicate.

---

Linear DEV-990 · created 2026-07-16 · backlog