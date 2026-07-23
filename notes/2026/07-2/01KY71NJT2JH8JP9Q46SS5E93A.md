---
id: 01KY71NJT2JH8JP9Q46SS5E93A
created: 2026-07-23T08:32:28.482472Z
updated: 2026-07-23T11:00:30.550674Z
type: task
title: Trash/archive state for notes — a safety net before permanent delete
task_status: done
imported_from: null
assignee: steve
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 234
sprint: snnvjf1
label: null
---
Deletion currently has no in-app safety net: `delete_note` permanently removes the file, its attachments, and its index rows, with no undo. The only recovery path is git history on a synced vault (ADR 0013) — nothing for un-synced vaults, and nothing discoverable in the app either way.

Add a soft-delete state between "live" and "gone", Linear-style: deleting a note moves it to a trash/archive; a restore puts it back; permanent delete is a second, deliberate step (or automatic after a retention period).

Design questions to settle (probably an ADR, since it touches the storage model):

* **Representation.** A `trashed:`/`archived:` frontmatter flag keeps the file in place and greppable (index/search/browse must learn to exclude it everywhere); a `trash/` folder outside `notes/` keeps the live tree clean and the sharded layout (ADR 0004) untouched, but moves attachments with it. The flag is more in keeping with plain-files-as-truth.
* **Scope.** Notes only, or taxonomy value pools too? (Probably notes only.)
* **Retention.** Keep forever until emptied, or auto-purge after N days?
* **Surfaces.** In-app trash view + restore; MCP `delete_note` should default to trashing, with permanent delete as an explicit opt-in — an agent typo shouldn't be able to destroy a note irrecoverably.
* **Project cascade.** Today deleting a project detaches or cascade-deletes its tasks; trashing needs the same choice, plus what restore does to the links.

Context: surfaced from the Linear-vs-Notuvia project-management comparison — Linear archives by default and makes delete rare; Notuvia only has permanent delete. Done/cancelled statuses already cover the "hide finished work" half of archiving; this issue is the recoverability half.

---

Linear DEV-887 · Editor and Sync · created 2026-07-07 · done 2026-07-09