---
id: 01M7J4C4AK91ZKW51PGS1SB9G4
created: 2026-11-16T12:12:39.635544Z
updated: 2026-11-16T23:03:23.117297Z
type: task
title: 'Check page: edit a check from its own page — rename it, change its description and schedule, and change its reads directly or with Polaris'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1867
sprint: s7nqsy0
comments:
- id: 01M7JC3NTBGCGBAJ8N4Z9ZCNSF
  author: Steve Vine
  at: 2026-11-16T14:27:51.243305Z
  text: |-
    Done — PR #1864, merged to main (3194e0dd). Not on staging yet.

    - Edit on a check's page opens a dialog:
      - Name, Description and Schedule save at once.
      - Collects by (for a records check with more than one date) sends the change to Review, as COM-1866 does.
      - Reads: either Edit the reads (the same editor as the Evidence tab, with Try it for a fresh sample) then Send to Review, or Ask Polaris.
    - When a change is waiting at Review, the page says so and links to Review. Details now also shows which date a records check collects by.
    - Changes, in the side column, lists every rename, description, schedule and reads change, and each change sent to Review (waiting, approved or discarded), with who made it (and "via Polaris") and when.
    - Polaris works the same way: name, description and schedule apply at once; reads and date wait for Review.
    - A check replaced by a re-created one can't be edited. A check that's switched off can.

    To check on staging: on CHK-26's page, rename it and change its description and schedule, and see each appear in Changes. Edit the reads, Try it, Send to Review, and see the waiting note.
- id: 01M7JECE50R2SKSSC10495RTHM
  author: Steve Vine
  at: 2026-11-16T15:07:35.455888Z
  text: |-
    **Pre-UAT: Passed** for name, description and schedule. **Couldn't check** a change to the reads (staging 43d03f09, E2E Test Company, E2E Admin A, on CHK-2's page).

    Steps and what I saw:
    - Edit opens "Edit CHK-2" with Name, Description and Schedule (Daily / Weekly / Monthly / Quarterly / Yearly). It says "The name, description and schedule apply at once", and has a Reads section ("A change to what it reads waits on Evidence Collection ▸ Review…") with Edit the reads and Ask Polaris.
    - I renamed it (added " (UAT rename)"), added "UAT edit." to the description, set Monthly, and saved. All three applied at once: the header name, Details ▸ Description, and "Schedule: Monthly · next 6 Dec 2026", counted from the last capture on 6 Nov.
    - Changes listed each of the three with "by E2E Admin A · 16 Nov 2026".
    - I then put all three back as they were (logged the same way).
    - Edit the reads opens the reads as text with Try it. Try it replied "That Collection integration doesn't exist", because CHK-2's integration was deleted. So I couldn't send a reads change to Review or see the "change waiting" note.

    Side effect worth knowing: after the schedule went back to Weekly, Details reads "Weekly · next: due now", where before it read "next 21 Nov 2026". That is because the next run is now counted from the last capture (6 Nov), as designed. CHK-2 can't collect anyway.

    Not covered:
    - A reads change and its "waiting at Review" note: needs a check whose integration exists.
    - Ask Polaris for reads.
    - A retired (replaced) check refusing Edit: E2E Test Company has none.

    Steve to look at on CHK-26's page in Test Company: Edit the reads ▸ Try it ▸ Send to Review, then see the waiting note and the Changes entry.

    Screenshots: ~/compass-uat/s7nqsy0/COM-1867/ (edit-dialog.png, after-save.png, edit-reads.png, try-it-deleted-integration.png)
assignee: steve
label:
- improvement
priority: medium
task_status: done
---
Asked for by Steve while testing sprint "Automation - Workflows" on staging (2026-11-16).

## Today

A collected check's page (All checks ▸ CHK-n) is read-only. A check can be renamed, rescheduled and have its reads edited, but only from the control's Evidence tab. Its description (About, what it shows) can only be changed by Polaris.

## Done when

- **Edit** on the check's page (for whoever may record assessments) lets a person change:
  - its **name**, applied at once;
  - its **description** (About), applied at once, because it only changes how the check is described;
  - its **schedule** (frequency), applied at once, with the next capture counted from its last one, as today;
  - its **reads**, either edited directly (the same read editor and sample as the Evidence tab's) or by asking Polaris from the page. A change to reads goes to Evidence Collection ▸ Review like any change to a live check, and the page says a change is waiting.
- Every change appears in the page's Changes list, with who made it and when.
- A retired check can't be edited.
- Polaris, with the check on screen as "this check", can do the same under the same rules. A reads change still waits for a person at Review.
- Tests cover:
  - name, description and schedule changes apply at once and are logged;
  - a reads change waits for Review and the page shows it;
  - a retired check refuses edits.

On the chain (the description becomes editable through the API).