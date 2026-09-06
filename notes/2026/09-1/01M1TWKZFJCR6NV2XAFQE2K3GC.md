---
id: 01M1TWKZFJCR6NV2XAFQE2K3GC
created: 2026-09-06T08:16:07.154013Z
updated: 2026-09-06T11:26:47.295152Z
type: task
title: deleting a company destroys its evidence files but keeps the rows
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 573
sprint: s2fcksg
comments:
- id: 01M1TZXGJ8E7ND97WBEX6ZKAJ8
  author: Steve Vine
  at: 2026-09-06T09:13:45.288264Z
  text: |-
    Done — PR #579, merged to main.

    The purge now deletes the attachment rows whose keys it destroys. The two are one query and one set, which is the actual fix: they were gathered separately, and that is how they came apart.

    The owner map got a guard while I was in there. It is the one part of `company_purge` not derived from the schema — `attachments` has no foreign key to follow — so it is the one part that can go quietly out of date, which is precisely what happened. `content_item` is now *named* as deliberately excluded rather than merely absent, and a test asserts every member of the enum appears in one list or the other.

    Migration 0165 clears rows already stranded. Scoped to assessment and risk owners, the two the purge touches — a stranded `content_item` attachment would mean something else entirely, so no broader "orphan" definition. Checked against a populated database rather than only the fresh one CI builds: it removes the stranded rows, leaves the live ones and the library row, and a second run removes nothing.

    **One thing I could not do.** Checking staging for existing stranded rows — `kubectl exec … psql` is being refused by the permission classifier in this session, in the exact command shape that worked before. The migration handles zero rows and any number, so it is not a blocker, but the count on staging is unverified rather than confirmed-zero. If you want the number:

    ```
    KUBECONFIG=/home/steve/.kube/g5.yaml kubectl exec -n compass compass-postgres-1 -- psql -U postgres -d compass -c "select count(*) from attachments a where (a.owner_type='assessment' and not exists (select 1 from assessments s where s.id=a.owner_id)) or (a.owner_type='risk' and not exists (select 1 from risks r where r.id=a.owner_id));"
    ```

    The existing purge test could never have caught this: it walks the tables with a foreign key to `companies`, and `attachments` has none by design. The new one asserts neither the bytes nor the row survives and that a library file is untouched — verified it fails without the fix (`assert 1 == 0` on the surviving row), and note the *file* deletion passes either way, which is the bug exactly.
assignee: steve
label:
- bug
priority: medium
task_status: done
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
