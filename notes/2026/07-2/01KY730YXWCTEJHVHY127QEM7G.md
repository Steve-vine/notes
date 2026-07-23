---
id: 01KY730YXWCTEJHVHY127QEM7G
created: 2026-07-23T08:56:09.916363Z
updated: 2026-07-23T11:04:51.011969Z
type: task
title: Trashed projects still own their identifier, blocking saves of the live project
number: 337
imported_from: linear
assignee: steve
task_status: backlog
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
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