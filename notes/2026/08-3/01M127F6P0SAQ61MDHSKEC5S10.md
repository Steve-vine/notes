---
id: 01M127F6P0SAQ61MDHSKEC5S10
created: 2026-08-27T18:24:44.224781Z
updated: 2026-08-28T21:52:56.370714Z
type: task
title: An engagement says how far in the vendor can reach, and the register can filter on it
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 471
sprint: sd9gmcq
blocked_by:
- 01M127F2FRFN8ANFHZ1P7VWX7M
comments:
- id: 01M155S51J1R2ZV1F0N1B5P0SE
  author: Steve Vine
  at: 2026-08-28T21:52:56.370549Z
  text: |-
    Done — PR #486, merged to main 2026-08-28.

    What landed:

    - `vendor_engagements.access_level` — nullable, single-valued. The ladder is nested, so the highest true rung is the whole answer; the data dimension stays on the engagement's data types, so a supplier holding our data *and* a support account is `connected` and nothing is lost.
    - `access_requirements` keeps its place beside it. The rung says how far, the sentence says why.
    - **Nothing backfilled, nothing guessed.** The migration test proves it: an engagement whose free text reads "Full administrative access to production" comes through the upgrade with `access_level` still null and the sentence untouched.
    - `access=unclassified` on the register (internal and portal) — the other half of that decision. A vendor is in the backlog if *any* live engagement is unclassified, so classifying the easy one on a supplier does not close the question for the rest. Ended engagements drop out; proposed ones count.
    - `proposed_access_level` on requests, joining `_PROPOSABLE` and `ProjectedEngagement`, so an amendment handing a supplier production access is judged on the rung it *would* have. That is what makes COM-476's rule work at all.
    - Surfaces: the shared engagement form, the manager's direct edit, the amendment modal, the card pill, the approver's Review panel, the request summaries, the register filter. A rung always reads by its rubric name — "Acts as us", never "privileged".

    One judgement call: the rung is **optional**, unlike criticality and cost. Those are required because a blank matches no threshold and is a control that silently requires nothing; an unclassified rung is instead an honest state the register can list, and COM-473 treats an unset dimension as contributing nothing. Easy to make mandatory later if the backlog filter shows new engagements arriving unclassified.

    Also fixed on this branch: `test_vendor_request_summaries.py`'s `_FakeRequest` kept a hand-written copy of the proposable columns, so the new field broke six tests that had no opinion on access at all. It now takes its field list from `_PROPOSED_COLUMNS`, so the fake grows with the real thing.

    Tests: `tests/test_engagement_access_level.py` (13) + 2 unit tests on the summaries wording + 2 frontend register-filter tests.
assignee: steve
company: null
label:
- feature
priority: medium
task_status: active
---
ADR 0060 §1. `vendor_engagements.access_level` — nullable, single-valued, the highest true rung (the ladder is nested, so one value is the whole answer).

`access_requirements` **keeps its place** beside it as the note that says what the access is for and how it is constrained. Nothing is discarded and nothing is machine-guessed from it — existing engagements start with no rung, deliberately.

Surfaces: engagement create / amend / approval-request forms, the engagement card, the engagement's revisions, and a register filter — including "access not yet classified", which is the visible backlog this creates.