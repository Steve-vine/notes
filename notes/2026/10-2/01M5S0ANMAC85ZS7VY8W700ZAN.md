---
id: 01M5S0ANMAC85ZS7VY8W700ZAN
created: 2026-10-25T07:45:14.890413Z
updated: 2026-10-25T07:45:14.890413Z
type: task
title: 'DDQ: questions set up from Polaris''s reading of the layout start with nobody — they must start with Polaris'
priority: high
assignee: steve
task_status: active
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1291
---
## What Steve saw

While smoke-testing sprint 86 on a fresh DDQ (DDQ-4, Company One), set up through Polaris's layout reading (COM-1280). Steve asked: "Where does it indicate who each question is assigned to?"

## Behaviour

- Every question is always with Polaris or a person (COM-1287). A question set up from Polaris's reading of the layout **starts with Polaris**, the same as one read by Set up questions or added by hand. The questions list shows "With ✦Polaris" under its status.
- A set-up run again keeps the same rule: replaced questions are new and start with Polaris; kept questions keep whoever has them.

## Cause

`core/ddq_layout.set_layout` creates the question rows but never calls `_to_polaris` (`give_to_polaris`), which `ddq_questions` calls on every other creation path. So no current assignment row is written, and the list's "With …" line has nothing to show. Missed when COM-1280 was built on top of COM-1287.

## Existing questions

On staging, DDQ-4's 29 questions were handed to Polaris through the assign tool on 2026-10-25, so no data repair is needed there. COM-1280 has not been released, so production has none.

## Implementation notes

- Call `_to_polaris(db, user, new_rows)` in `set_layout` after the rows are flushed.
- Integration test: after `set_layout`, every new question has one current assignment of kind polaris. A re-run keeps a question a person holds with that person.
- Independent (no migration, no API change).
