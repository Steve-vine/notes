---
id: 01M7HZS4DNVCTBNH1WM936GJ9V
created: 2026-11-16T10:52:22.837547Z
updated: 2026-11-16T15:07:08.198221Z
type: task
title: 'Records checks default to the date a record was created, with last-updated a deliberate choice, and a live check''s collection date can be changed: CHK-24''s approvals vanish from their week when edited'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1866
sprint: s7nqsy0
comments:
- id: 01M7J95PJPDT6VVK75SXX1WD5C
  author: Steve Vine
  at: 2026-11-16T13:36:31.830602Z
  text: |-
    Done — PR #1861, merged to main (993ed648). Not on staging yet. Decision recorded in ADR 0156.

    - Records checks collect by the date each record was created unless someone deliberately chooses otherwise. Polaris picks the created date by default, and says why when it proposes a last-updated or other date.
    - On Evidence Collection ▸ Review, a records check says which date it collects by ("Collects each week's changes, by the date they were created"). The approver can pick another of the record's dates, with created dates listed first, and a fresh sample is taken by the new date. A last-updated date is flagged: "an edit moves it into a later period".
    - A live check's date can be changed on the control's Evidence tab (check card ▸ Details ▸ Collects by ▸ Change ▸ Send for review), or Polaris can propose it. The change waits at Review and keeps the check's ID. Past captures stay as they were taken, a re-run of a past period uses the new date, and the change shows in the check's history.
    - What a date means is read from the field's name (created, opened, updated…), never from knowing the service.

    CHK-24: after deploy I'll propose moving it to change.created_at (the change's own created date, not the approval's). It then waits at Review for a person to approve; neither Polaris nor I can approve it. Once approved, re-running 8–14 Nov should find your corrected approvals.

    To check on staging:
    - Before the move, CHK-24's card ▸ Details shows "Collects by: the date they were last updated", flagged.
    - After approving, it reads "by the date they were created", the history records the change, and old captures are unchanged.
    - Asking Polaris to design a new records check gives a created date.
- id: 01M7JEBKH6J8W6RCM8MJ27029N
  author: Steve Vine
  at: 2026-11-16T15:07:08.197994Z
  text: |-
    **Pre-UAT: Couldn't check** (staging 43d03f09, E2E Test Company, E2E Admin A)

    E2E Test Company has no records check, live or proposed, so the collection date never appears:
    - CHK-2 is a snapshot. Its Details reads "Collects: A snapshot of how it's set up", with no "Collects by".
    - The one new-check proposal, CHK-1 (the Entra audit log), is proposed as a snapshot. On its Review page I asked Polaris to make it a records check by its activity date. Polaris declined, for two reasons:
      - a snapshot proposal can't be switched to records;
      - its read goes through Access Control's Microsoft 365 connection, which Compass now refuses.
      CHK-1 is unchanged. Approve on it is also refused, for the same Microsoft 365 reason.
    - So I couldn't see the Review date wording or choice, the last-updated flag, or Change ▸ Send for review on a live check.

    Steve to look at on staging (Test Company), as in the Done comment:
    - CHK-24 on CHM.2 ▸ card ▸ Details: before approval it should read "Collects by: the date they were last updated", flagged.
    - Approve the waiting change at Review. It should then read "by the date they were created", the history should record the change, and old captures should be unchanged.
    - Re-run 8–14 Nov: it should find the corrected approvals.
    - Ask Polaris to design a new records check: it should pick a created date.

    Screenshots: ~/compass-uat/s7nqsy0/COM-1866/ (review-tab.png, chk1-review-item.png, ask-polaris-open.png)
assignee: steve
label:
- bug
priority: high
task_status: review
---
Found by Steve while testing sprint "Automation - Workflows" on staging (Test Company, CHK-24 on CHM.2).

## What was seen

CHK-24 (change approvals) collects each week's items by their **last-updated** date. Steve corrected the approvals that were failing in FreshService, then re-ran 8–14 Nov. The capture came back empty. The edits had stamped those approvals as updated on 16 Nov, so they had left the week they belonged to.

A long-lived change would keep appearing in and disappearing from weekly evidence every time someone touched it. Steve's principle: **evidence for a period is, by default, the records created in that period.** Some checks may legitimately want a last-updated date (Steve, 2026-11-16: "it should favour created and it should be a choice"), so it stays possible but deliberate. CHK-7, 25 and 26 already collect by created date; CHK-24 is the only one by updated date.

Also, once a check is live, the date it collects by can't be changed, by a person or by Polaris. Polaris can change a live check's reads, fields, name, wording and schedule, but not its date. The only way out today is a replacement check.

## Done when

- **Polaris defaults records checks to the created date.** It picks the date a record was created (raised, requested, opened) unless there's a reason to do otherwise. It may propose a last-updated or modified date when that is what the evidence is about (e.g. "records changed this week"), or when the service gives no created date; the proposal then says so and why.
- **The collection date is a choice the approver makes.** Review shows which date a records check collects by, in words ("Collects each week's changes, by the date they were created"), and lets the approver pick another of the record's dates. Created is the default selection; a last-updated date is flagged with what it means: an edit moves a record into a later period.
- **A live check's collection date can be changed.** A person can change it on the check's page, or Polaris can propose it. The change goes to Evidence Collection ▸ Review like any other change to a live check, and keeps the check's ID and captures. Past captures stay as they were taken; re-running a past period uses the new date.
- **CHK-24 is moved to the change's created date** (`change.created_at`), on staging, and on production if it exists there, so it collects the same changes, week by week, as CHK-25 and CHK-26. Re-running 8–14 Nov then finds Steve's corrected approvals.
- **Tests cover it:** a records check proposed with an updated date is flagged but allowed; choosing a different date at Review is kept; changing a live check's date waits for review and keeps its ID; a re-run after the change keeps items by the new date.

On the chain (changes the check-change API).