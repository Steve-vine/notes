---
id: 01M84XYPVZG3CMTX5BH2SX7FD7
created: 2026-11-23T19:26:02.623351Z
updated: 2026-11-24T15:20:46.546187Z
type: task
title: 'Restore option 2: Keep audit logs — the data goes back to the copy, while the logs, signatures, legal holds and revocations made since are carried forward'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2119
sprint: szwetpq
blocked_by:
- 01M84XYDAWZQWZPVAJZXP43KNA
comments:
- id: 01M85XYVCNZD28M6251Q18BF08
  author: Steve Vine
  at: 2026-11-24T04:45:21.685282Z
  text: |-
    Merged: #2117, 00ba56c9f, 24 Nov 04:44 GMT. Migration 0907_restore_kept_records. Not on staging yet: the sprint deploys together. ADR 0172 (Keep audit logs) is Proposed, for Steve to read.

    Built: Restore ▸ Keep audit logs. The data goes back to the copy. These made since the copy are carried forward: the activity log, the evidence deletion and privacy retention logs, signatures, NDA acceptances, legal holds, revocations (tokens, disabled people, removed privileges, per-record access), tightened restrictions, switched-off portals and sign-in, and erased personal data. A carried row that can't fit the older data is kept aside and listed in the review. If anything carried changes between being read and the swap, the swap is undone and Compass stays as it was.

    Reviews: an independent review of the build found 6 defects, 3 of them high: a rollback could make a whole group Admin again, the lock-out check counted Admins who couldn't sign in, and a former owner could get back into a Restricted register. All 6 were reproduced with failing tests and fixed. Two further fresh reads found 8 more, then 2 more, all fixed with tests.

    Decisions made in the build, for Steve:
    - It refuses rather than guessing when the live data can't be read, when a held record can't come back, when nobody could sign in as an Admin afterwards, or when a disclosure was restricted only by a request made since the copy.
    - A company purged since the copy comes back, unless the copy holds privacy records old enough to have been erased since. Then it refuses, because it can't tell which were.
    - Owning an ordinary record (a risk, vendor, secret, initiative or audit request) goes back with the data, so the old owner returns. Only being named on a restricted record is carried. Where an owner change would have kept someone out of a Restricted register or contract, the record is left with no owner and listed.
    - A legal hold lifted since the copy comes back on: a restore never takes a hold off.
    - These go back with the data rather than being carried: a signed NDA recorded on a DDQ, and rotated integration credentials (that connection fails until re-entered).

    Tested: 187 restore, Keep audit logs, access, hold and recovery tests on real Postgres with Compass's real permission shape, and the full CI suite.

    Couldn't check yet: the screens in a browser, and a full rehearsal (COM-2124). The last small fix (questionnaire handovers) is being given another independent read under COM-2128.

    For the release: the swap now checks the carried tables while they're locked, so a large activity log lengthens the time Compass is offline. COM-2124 will time it.
- id: 01M872AAPJ2P0F7Q12YMTRNAP5
  author: Steve Vine
  at: 2026-11-24T15:20:46.545956Z
  text: |-
    Pre-UAT pass, 24 Nov 2026, staging 0234a65f3.

    Couldn't check on staging, by design: every Done when item. A Keep audit logs restore would roll back everyone's shared staging data. None was started.

    Where it was proved instead: COM-2124 Phase B, scenario 3, Keep audit logs from BKP-6, PASS in 447.4 s (about 5 min 40 s carrying 3.47M activity rows forward). Results in ~/compass-uat/backup-and-restore/COM-2124/logs/phase-b-summary.md.
    - The data went back.
    - Every activity entry since the copy was kept.
    - The legal hold placed since the copy was still on.
    - The revoked token stayed gone.
    - Deleted evidence read as deleted.
    - On hold 08:38–08:47 with 0 requests and 0 mail.

    Signatures, NDAs and disabled people weren't individually called out in the summary, so rely on the build's tests for those.

    On staging I only saw that Keep audit logs is on each Ready copy's Restore menu (COM-2121/01-restore-menu.png).
assignee: steve
label:
- feature
priority: high
task_status: review
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