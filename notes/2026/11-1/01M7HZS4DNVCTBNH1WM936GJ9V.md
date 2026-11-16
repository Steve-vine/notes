---
id: 01M7HZS4DNVCTBNH1WM936GJ9V
created: 2026-11-16T10:52:22.837547Z
updated: 2026-11-16T11:50:35.237118Z
type: task
title: 'Records checks default to the date a record was created, with last-updated a deliberate choice, and a live check''s collection date can be changed: CHK-24''s approvals vanish from their week when edited'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1866
sprint: s7nqsy0
assignee: steve
label:
- bug
priority: high
task_status: todo
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