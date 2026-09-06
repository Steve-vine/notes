---
id: 01M1TWKZFJCR6NV2XAFQE2K3GC
created: 2026-09-06T08:16:07.154013Z
updated: 2026-09-06T08:16:21.937659Z
type: task
title: deleting a company destroys its evidence files but keeps the rows
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 573
sprint: s2fcksg
assignee: steve
label:
- bug
priority: medium
task_status: backlog
---
Found 2026-09-06 while designing the admin files screen (COM-572). **Latent — no such rows exist on staging today**, and the company Steve deleted happened to hold no evidence.

Permanently deleting a company (COM-507) collects the storage keys for its assessment and risk evidence, deletes those objects from storage after the commit, and reports them in the confirmation as "attachments (files)". **It never deletes the `attachments` rows themselves.**

So the metadata survives its subject: rows pointing at an assessment or risk that no longer exists, naming a file whose bytes have been destroyed. Nothing surfaces them today, which is why this has gone unnoticed — the admin files screen is precisely what would put them on a page, each one linked to nothing.

## Why it was missed

The purge derives its graph from foreign keys, and `attachments` has none — it points at its owner by type and id, exactly as `notifications` does. Notifications got an explicit sweep for that reason, with a comment saying why. Attachments got half of the same treatment: the file keys are gathered by hand, and the row deletion that should have accompanied it was not written.

## What changes

- The purge deletes the attachment rows whose keys it destroys — the same set, so the sweep is already computed.
- Clean up any rows already stranded on a deployment where a company has been purged. Check before assuming there are none; there are none on staging.
- A test that purging a company with evidence leaves neither the file nor the row. The existing test asserts the seed still matches the schema, which is the check that cannot catch this: `attachments` is invisible to the schema walk by design.

## Related

- COM-507 — the company purge.
- COM-572 — the admin files screen, which is where these would show up.
