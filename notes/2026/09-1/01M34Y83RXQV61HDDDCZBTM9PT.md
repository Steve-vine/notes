---
id: 01M34Y83RXQV61HDDDCZBTM9PT
created: 2026-09-22T16:12:41.629233Z
updated: 2026-09-24T20:06:10.707773Z
type: task
title: Mailbox access is watched, and can be recertified
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 741
sprint: s3nfes0
blocked_by:
- 01M34Y7PYDC14PWXMPYVM0YNB5
comments:
- id: 01M35NZ3SF9T98VP2892MT1VT9
  author: Steve Vine
  at: 2026-09-22T23:07:12.559506Z
  text: |-
    Done — PR #753, merged to main.

    **Watched.** Each hourly pass compares every person's direct mailbox access with the last pass. Access Compass granted or revoked through a request is not drift. A grant on a mailbox some role maps lands in the validation queue as a decision — "Grace given access to open Sales", with the mailbox and the kind on the item; one on a mailbox nobody maps is recorded for information. A grant that goes away is the other half ("Grace lost access to open Sales"). Who did it is left honestly unanswered: Exchange's admin audit is a separate read from the directory audit — a possible follow-up, as the task said. Deciding an item works as for groups: adopt it, or flag it for reversal against a corrective request (which can now name mailbox access).

    **Recertified.** A recertification schedule can be on a shared mailbox. Its holders become review rows: someone holding a grant directly ("Full access · direct grant"), someone reached through a group ("Send as · via Sales Team"), and a trustee Exchange could not place. A flagged direct grant is revoked through Exchange once a second person approves — recorded in the ledger and on the mailbox's page straight away. A grant through a group, or with no account behind it, is confirmed by hand in Exchange, as a directory role is in Entra.

    Smoke test: (1) in the Exchange admin centre give someone access to a role-mapped shared mailbox, then Admin ▸ Integrations ▸ Exchange ▸ Read now, then Access Control ▸ Validation — expect the item; (2) Access Control ▸ Recertification ▸ Add schedule ▸ Entity type "Shared mailbox".

    Side note: this PR's first CI run failed on `test_frameworks.py::test_importer_fills_the_implementation_group_wherever_it_is_unset` (unrelated; passes locally and on every other run) — a rerun was green. Worth a look if it recurs.
assignee: steve
label:
- feature
priority: medium
task_status: done
---
Once shared mailboxes are mirrored and managed, the two governance mechanisms that already exist for groups extend to them.

**Watched.** Each mirror pass compares the access on every *managed* mailbox against what Compass's own requests explain. Access that appeared or disappeared with no request behind it becomes an **unrequested change**, in the same feed as group ones, with the mailbox and the access kind named. Who made it is a stretch: Exchange's admin audit log is a separate read (`Search-UnifiedAuditLog`) and may follow as its own task — the change itself is the finding; the actor is enrichment.

**Recertified.** A recertification campaign can include shared-mailbox access: the reviewer sees *can open* / *can send as* lines beside group memberships for each person, and a removal decided in the campaign executes through the same path as everything else — one write path, recorded, refusable.

Unmanaged mailboxes are observed and shown but neither watched nor recertified, consistent with the boundary.