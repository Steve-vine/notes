---
id: 01M84XYPVZG3CMTX5BH2SX7FD7
created: 2026-11-23T19:26:02.623351Z
updated: 2026-11-23T19:27:13.432853Z
type: task
title: 'Restore option 2: Keep audit logs — the data goes back to the copy, while the logs, signatures, legal holds and revocations made since are carried forward'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2119
sprint: szwetpq
assignee: steve
label:
- feature
priority: high
task_status: todo
---
ADR 0169 §3, §4. For a significant change that went wrong, when the record of what happened must survive.

**Chain:** on the chain — API.

**What people see**

- **Restore ▸ Keep audit logs** follows the same steps as Everything, and says what is kept: activity log, evidence deletion log, privacy retention log, signatures, NDA acceptances, legal holds and revocations since the copy.
- Afterwards the activity log reads continuously: entries before, entries since the copy, then the restore itself.
- An entry about a record that the rollback removed still reads properly, by name, and doesn't link to nothing.

**Done when**

- After a restore, every log entry made since the copy is still there, unchanged, with its original time and person.
- A token revoked since the copy stays revoked. A person disabled since the copy stays disabled, and a privilege removed since stays removed.
- A legal hold placed since the copy is still in force, and personal data erased since the copy stays erased.
- A document signed or an NDA accepted since the copy still shows as signed where its record still exists, and is listed in the review where it doesn't.
- Evidence deleted since the copy is shown as deleted, with its deletion log entry, and not as a broken file.

**Technical notes**

- Read the carry-forward set out of the live data **before** the swap and write it in the same transaction as the swap.
- These rows can point at records the copy doesn't have. The deletion log has no links by design; check each of the others, and decide per table whether to keep the row with a null link or list it in the review.
- A revoked API token is a **deleted row**, so "revoked since the copy" means present in the copy and absent from live. Remove those rather than copying anything forward.
- DSR retention deliberately rewrites activity rows (`core/dsr_retention.py`). Keep the live version of those rows, so an erasure isn't undone.