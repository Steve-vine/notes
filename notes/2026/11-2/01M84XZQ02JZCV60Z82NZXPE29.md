---
id: 01M84XZQ02JZCV60Z82NZXPE29
created: 2026-11-23T19:26:35.522131Z
updated: 2026-11-24T15:20:15.16205Z
type: task
title: 'Restore option 3, part 2: put chosen records back from an opened copy, with their original reference numbers and anything they depend on'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2122
sprint: szwetpq
blocked_by:
- 01M84XZDDRKWVYD86CQY2SVR8K
comments:
- id: 01M868C86D27BP0AJX02CFK3H1
  author: Steve Vine
  at: 2026-11-24T07:47:26.541206Z
  text: |-
    Merged: #2121, e034eaeed, 24 Nov 07:46 GMT. No migration, two new API routes. Not on staging yet: the sprint deploys together. ADR 0174 (putting records back) is Proposed, for Steve to read.

    Built: from the compare view, an Admin ticks records and chooses Put back. A preview shows exactly what returns, what is overwritten (with differences), what else must come with it, and who is left out. A reason is required. Each record keeps its original number and is recorded as "Put back from BKP-n". It's all one step, so a failure leaves nothing changed.

    What it never does:
    - Put back people, roles, access requests, tokens, credentials, settings or logs, including through a crafted API call.
    - Loosen a restriction or classification.
    - Send an email or "assigned to you" message, write to an integration or change access.
    - Run during a hold or maintenance (it's refused).

    The Admin also needs the area's own edit right.

    Decisions made in the build, for Steve:
    - On a record that still exists today, the people named on it stay as they are today, owners included. On a record that's gone entirely, a register's owner and editors and a pending acceptance's approver are left empty, and anyone else comes back only if still active. This narrows ADR 0172's "ownership goes back with the data" for put-back.
    - Gap comments, vendor certificates, contacts and engagements, and document versions and reviews are only ever added, never removed.
    - Evidence deleted for good isn't put back.
    - A vendor put back reappears on the Trust Centre subprocessor list; the preview says so.
    - What deleting a document tidied up (Library folders, reading groups, runbook systems) isn't redone; the result says so.

    Reviews: four rounds of independent review. The first found 2 high and 5 medium issues, including restrictions loosening, approvers coming back, and reminder mail not being silenced. Every issue was fixed, each with a failing test first except the very last small guard.

    Tested: 41 put-back tests through the API, plus the opened-copy, restore, Keep audit logs, hold, maintenance, backup and recovery suites (313), and the full CI suite.

    Couldn't check yet: the Put back window in a browser (pre-UAT), and how fast a very large install would be.
- id: 01M8729C1TYN341ABWVAPBFVEY
  author: Steve Vine
  at: 2026-11-24T15:20:15.161846Z
  text: |-
    Pre-UAT pass, 24 Nov 2026, staging 0234a65f3, E2E Test Company, E2E Admin A, from BKP-1. Screenshots: ~/compass-uat/backup-and-restore/COM-2122/

    Setup: before the copy I made four test records: draft policy "E2E UAT124 Put-back document", software asset SFT-30 "E2E UAT124 App", technology asset AST-66 "E2E UAT124 Server" with SFT-30 installed, and gap GAP-207. After the copy, through the screens, I deleted the document, AST-66 and SFT-30, and changed GAP-207's title and description.

    Passed: a deleted record comes back with its original reference number and its links to records that still exist.
    - I ticked only AST-66. It came back as AST-66, Live, with SFT-30 back under Installed software, and its audit trail reads "put back technology asset AST-66 · E2E UAT124 Server from BKP-1" (06).
    - The deleted draft document came back as a Draft, V1, with its text (preview 05).
    - I couldn't test a deleted risk or control: Compass can't delete a risk, and I left controls (Playbook, shared) alone.

    Passed (first branch): a record depending on one that has gone brings it too, with the Admin's agreement.
    - The preview listed under "Also needed": "Bring software asset SFT-30 · E2E UAT124 App too. Without it, AST-66 comes back without its link to it." (01)
    - Ticking it changed the button to "Put back 2 records" (02). Both came back (result 03).
    - The branch where a needed record is left behind wasn't run.

    Couldn't check: a reference number since used by a different record is refused. I can't arrange that through the screens, because numbers are never reissued.

    Couldn't check: evidence whose file has gone comes back marked as having no file. The screens can't remove only the file, and evidence deleted for good isn't put back by design.

    Passed: each record put back is in the activity log as put back from BKP-n by that Admin, and search reflects it.
    - Activity log lines, each by e2e-admin-a (08):
      - "put back technology asset AST-66 … from BKP-1"
      - "put back software asset SFT-30 … from BKP-1"
      - "put back gap GAP-207 … from BKP-1", with Title and Description old → new
      - "put back content item E2E UAT124 Put-back document from BKP-1"
      - and per run, "Database backup: put back N records from BKP-1: <reason>"
    - Search for "E2E UAT124" found all four records live (09).
    - Posture and compliance figures don't involve these kinds of record, so they weren't checked.

    Changed record:
    - The preview showed GAP-207 under "Changed since the copy" with its differences, and an unticked "Overwrite today's version with the copy's". With it unticked the button read "Put back 0 records" (04).
    - Ticked, the gap went back to "E2E UAT124 Gap (to change)" and "Original description before the copy." (07).

    Couldn't check: nothing put back causes an email. Staging's mail catcher was off (mail is real SendGrid), so I couldn't read what was sent. No access change or integration was involved. The preview says "Nobody is emailed about it."

    Passed: people, roles, access requests, tokens, credentials, settings and logs can't be put back through the API. The put-back preview refused users, roles, api_tokens, access_requests, settings, activity_log and integrations with 422: "Only records from Content, Controls, … Evidence details can be put back. People, roles, …". I didn't send the put-back call itself with a forbidden kind; my session's permission checks blocked it.

    Observations:
    - The document preview says deleting it took it out of folders, reading groups and runbook systems, and that putting it back doesn't redo those. Good.
    - Ticks don't carry between areas. I ticked the document in Content, moved to Gaps and ticked GAP-207, and it said "1 record chosen", so a mixed put-back needs separate runs. Steve may want that differently.

    Clean-up: AST-66, SFT-30 and the document are deleted again. GAP-207 is Cancelled with a note, because gaps can't be deleted.
assignee: steve
label:
- feature
priority: medium
task_status: review
---
ADR 0169 §7.

**Chain:** on the chain — API.

**What people see**

- From the compare view, the Admin ticks records and chooses **Put back**.
- Before anything happens, Compass shows exactly what will change: records returning, records being overwritten (with their differences), and anything else that has to come too because a chosen record depends on it.
- A record changed since the copy is overwritten only if the Admin ticks that it should be.
- A reason is required. The result reports what came back, and anything that couldn't and why.

**Done when**

- A deleted risk, control or document comes back with its **original reference number** and its links to records that still exist.
- A record depending on another that has gone either brings it too, with the Admin's agreement, or isn't put back. No broken links.
- If a reference number has since been used by a different record, the put-back is refused for that record and says so.
- An evidence record whose file has gone comes back marked as having no file.
- Each record put back appears in the activity log as "Put back from BKP-n" by that Admin, and the rest of Compass (search, posture, compliance figures) reflects it.
- Nothing put back causes an email, integration write or access change.
- People, roles, access requests, tokens, credentials, settings and logs cannot be put back, including by calling the API directly.

**Technical notes**

- One transaction per put-back, so a failure leaves nothing half done.
- Write through the ORM with an actor set, so the normal activity logging applies. Bulk SQL would skip the `before_flush` listener.
- Dependencies come from the foreign keys of the catalogue's tables, walked only within the allowed areas. A dependency outside them (a person, say) is reported, and the link is left empty only if the column allows it.
- Check soft-deleted rows: many "missing" records still exist with `deleted_at` set, and those are an update rather than an insert.