---
id: 01M7A80AP4PRRKA35DZ3WWNB0J
created: 2026-11-13T10:42:11.780397Z
updated: 2026-11-13T23:18:30.898846Z
type: task
title: 'Recertification: an empty review says so, a schedule shows who holds its access now, and an empty run is flagged'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1790
sprint: spsp226
comments:
- id: 01M7B5D3K5BPCSHRT2994BXGAC
  author: Steve Vine
  at: 2026-11-13T19:15:59.205452Z
  text: |-
    Built — PR #1792 (feature/com-1790-empty-recert). On the chain: migration 0840 (when a schedule's target last changed, which clears the Action) and API changes. I merge it in chain order. Your production "Global Administrators" schedule is untouched — which role it should point at is still your call.

    What you'll see:
    1. An empty review says so — on Access ▸ Recertification ▸ Instances, on an asset's review in Inventory, and on the owner's portal page: "Nobody held Domain Name Administrator when this review started, so there was nothing to keep or flag." The owner's button reads **Confirm nobody holds it**; the sign-off then reads "confirmed nobody holds it <time>", and review lists show "Nobody held it". The evidence CSV gets a line "(nobody held it) / confirmed nobody holds it" (before, it had none). SAP evidence of operation reads "Confirmed nobody holds it". Polaris says nobody held it. The owner's assignment email says so too.
    2. The schedule window shows who holds it now, e.g. "Holds it: 5 people now (14 more eligible)" (directory roles count active and eligible separately). With nobody: a yellow warning "Nobody holds this now; a review would have nothing in it. Check you've picked the right one." — saving still works. The Schedules list has a "Holds it now" column; an asset's Recertification card shows the count; Polaris's schedule replies include the count and warning.
    3. An empty run raises an Action, "<schedule> review started with nobody in it: check the schedule recertifies the right thing", for whoever can run recertification of that kind (Access for groups/roles/mailboxes, Inventory for assets). It opens the schedule, and clears when the schedule is pointed at something else or the review is completed or withdrawn (a rename doesn't clear it). It goes in the digest — no extra mail.

    Choices:
    - "Nobody held it" is worked out, not stored: a review's rows are fixed when it starts, so signing off an empty review can only mean nobody holds it.
    - The holder count is exactly what a review started now would contain, so the count and the review always agree. Service principals holding a role count among "people"; for an asset, someone holding two roles counts once.
    - On deploy, any empty review still open raises the Action straight away. Production's 1 October review is completed, so it won't.

    Checks: ruff/mypy clean, unit passed, integration 153 (new empty-recert tests, Polaris recert, recert/SAP-evidence/list-rights, action sources), RecertPage + portal recert vitest pass.
- id: 01M7BK967JVNBGJGEZW1YFT0YP
  author: Steve Vine
  at: 2026-11-13T23:18:30.898687Z
  text: |-
    Pre-UAT: Passed (staging 2f72416b, E2E Test Company, as E2E Admin A). Screenshots: ~/compass-uat/spsp226/COM-1790/

    Steps and what I saw:
    1. Access ▸ Recertification ▸ Add schedule, Directory role = Yammer Administrator (nobody holds it). The window shows "Nobody now" and the yellow warning "Nobody holds this now; a review would have nothing in it. Check you've picked the right one." Saving still worked. Choosing Global Administrator shows "Holds it: 5 people now (14 more eligible)"; the Schedules list has a "Holds it now" column reading "Nobody now" / "5 people now (14 more eligible)".
    2. Trigger now on the empty schedule. Instances shows OPEN + NOBODY HELD IT; the review reads "Nobody held Yammer Administrator when this review started, so there was nothing to keep or flag." instead of a table.
    3. Actions (Recertification schedule) gained "E2E pre-UAT COM-1790 empty directory role review started with nobody in it: check the schedule recertifies the right thing" — Check what it recertifies — Access team. Clicking it opens the schedule.
    4. Pointed that schedule at Global Administrator: the Action went (0 actions). Pointed it back.
    5. A second empty schedule (Viva Pulse Administrator), triggered: Action raised. In the Portal ▸ Recertifications the owner's page has the same "Nobody held…" sentence and a "Confirm nobody holds it" button. Pressed it: "This recertification completed …: its sign-off confirmed nobody holds it." The Action cleared. The Access review then reads "required — confirmed nobody holds it 13 Nov 2026, 22:56".
    6. Evidence CSV has the line "(nobody held it) … confirmed nobody holds it".
    7. Polaris: the review tool says nobody_held "Nobody held Viva Pulse Administrator when this review started…" and the owner "confirmed: nobody holds it". SAP evidence of operation for ACC.3 reads outcome "Confirmed nobody holds it", with the CSV as evidence.
    8. Asset: new AST-62 (no access recorded). Its Recertification card shows "Nobody now", and the schedule window warns. Trigger now gives an Inventory review saying "Nobody held AST-62 …". The Action goes to the "Inventory team". Confirming in the portal completes it and the Action clears. Polaris's asset review also says nobody held it.

    Worth knowing, not a fail:
    - On staging, Domain Name Administrator shows "Holds it: 1 person now", but the role's own page says People 0 and "1 holder is not a mirrored person". I started a review to compare, and it had 1 row, a bare id "71a50207-… — Active · unresolved principal". So the count and the review agree, but "1 person" is really an unnamed principal. I withdrew that review and disabled its schedule. Production's 1 Oct review had 0 rows, so production's mirror may differ. Steve: look at what the production schedule window says for Domain Name Administrator.
    - Changing what a schedule recertifies empties the Owners list, and Save stays disabled until an owner is added again. This is the existing owner-prefill behaviour, not new.
assignee: steve
label:
- improvement
priority: medium
task_status: review
---
## Why

Steve, testing on 2026-11-13, in production (Moneypenny):
- The 1 October review of the schedule **"Global Administrators"** was completed, but it "doesn't show any details of what was submitted by the reviewer".
- The cause: the schedule recertifies the Entra role **Domain Name Administrator**, which no people hold. The run started with **0 rows**, and the owner signed off an empty list.
- Nothing on screen said the review was empty, and nothing warned that the schedule pointed at access nobody holds. It looked like lost data.
- The intended target was probably Global Administrator (5 active, 14 eligible) or the on-premises Domain Admins group. The schedule fix itself is Steve's call and isn't part of this task.

## What changes

### 1. An empty review says so
- Where it applies:
  - the review's page in Access Control (the Instances tab detail);
  - the asset recertification equivalent in Inventory;
  - the reviewer's page in the User Portal.
- With no rows, these pages say plainly: **"Nobody held Domain Name Administrator when this review started, so there was nothing to keep or flag."**
  - This replaces an empty table.
- The owner can still sign off, which is valid evidence that nobody holds the access. The button reads **"Confirm nobody holds it"**.
- The sign-off is recorded as that, and appears that way in:
  - the review;
  - the evidence export;
  - SAP evidence of operation;
  - Polaris (`access_get_recert_review` says "nobody held it" rather than returning an empty `rows`).

### 2. A schedule shows who holds its access now
- In the schedule window, when you choose what it recertifies, show how many hold it now, for example **"5 people now (14 more eligible)"**.
- When the count is none: **"Nobody holds this now; a review would have nothing in it. Check you've picked the right one."**
  - It's a warning only, and saving is still allowed.
- The Schedules list shows the same count.
- Polaris's schedule create/update reply includes the count and the warning.

### 3. An empty run is flagged
When a scheduled review starts with nobody in it:
- it's still created and sent;
- it raises an **Action** for whoever can run recertification for that kind (Access or Inventory):
  - the Action reads: "Global Administrators review started with nobody in it: check the schedule recertifies the right thing";
  - it links to the schedule;
  - it clears when the schedule's target is changed or the review is completed.
- It follows the actions-queue rules (ADR 0055) and doesn't send extra mail beyond what the Action already does.

## On the chain
Probably on the chain: a field for "nobody held it" on the review and its sign-off, a current-holders count on schedules, and a new Action source. Decide when building. If it needs no API change, it's independent.

## Done when
- On staging, E2E Test Company:
  - a schedule on a role or group with nobody in it shows the warning when it's chosen;
  - starting it by hand produces a review that says "Nobody held … " instead of an empty table, on both the Access page and the owner's portal page;
  - the owner's "Confirm nobody holds it" is recorded and shows in the evidence export.
- The empty run raises the Action for an Access recertification runner. It clears when the schedule is pointed at a role with holders.
- The schedule window and list show the current holder count for a role with holders.
- An asset recertification behaves the same.
- Polaris says "nobody held it" for an empty review.