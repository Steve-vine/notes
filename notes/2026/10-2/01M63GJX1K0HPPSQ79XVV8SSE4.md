---
id: 01M63GJX1K0HPPSQ79XVV8SSE4
created: 2026-10-29T09:41:46.163904Z
updated: 2026-10-29T23:52:14.294947Z
type: task
title: 'Core journeys as scripted tests — one journey per main area, done through the screens as a person would: assess a control and raise a gap, add and treat a risk, report and close an incident, send a vendor a questionnaire that is answered in the vendor portal, raise an access request that a second administrator approves, and draft a policy'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1451
sprint: s5pn06h
blocked_by:
- 01M63GJGXF4Z9VZ4DXAAYQC601
comments:
- id: 01M651856PVY6YV4GDSRRJJN8V
  author: Steve Vine
  at: 2026-10-29T23:52:14.294765Z
  text: |-
    Journey 5 changes (found in COM-1447, ADR 0135 correction): the directory is shared by every company, so an approved joiner in E2E Test Company would be created in the real directory. The journey becomes: E2E Admin A raises a joiner → Admin A can't approve it → E2E Admin B rejects it with a reason → the request shows Rejected and the directory is never touched. No journey approves, validates or expedites an access request.

    Journey 4: E2E Vendor Contact isn't a sign-in; the contact follows the questionnaire link read from mailpit (as planned).
assignee: steve
label:
- feature
priority: medium
task_status: todo
---
Sprint 99, Browser Testing (ADR 0135, COM-1446). Needs the suite (COM-1449); runs in the post-deploy step (COM-1450).

## The journeys

All take place in E2E Test Company. Records are named "E2E <run stamp> …".

1. **Posture.** Assess a control (status and maturity), raise a gap against it, and see both on the control and in the gap register.
2. **Risk.** Add a risk, score it, add a treatment and link the gap from journey 1. The risk shows in the register with its new score.
3. **Incidents.** Report an incident, triage it, move it through to closed and complete the review. The timeline shows each step.
4. **Vendors, across people and the portal.**
   - E2E Vendor Admin sends the test vendor a questionnaire.
   - The email arrives in the mail catcher.
   - E2E Vendor Contact follows its link and answers in the vendor portal.
   - Back in Compass, the answers show and can't be edited.
5. **Access Control, with two people.**
   - E2E Admin A raises a joiner.
   - E2E Admin A **can't** approve it.
   - E2E Admin B approves it.
   - The test company has no directory, so the journey stops at what Compass shows next and records that. Nothing can reach a real directory.
6. **Playbook.** Create an "E2E" draft policy, add and reorder sections, and see it listed in Content as a draft. **It is not published.** The Playbook is shared by every company, and publishing can ask real people to sign again and can reach SharePoint. It never edits a Playbook record it didn't create.

Anything that needs Polaris's AI provider is left out of this sprint, because runs would cost money and give different answers each time.

## Notes (technical)

- Each journey checks it is in E2E Test Company before changing anything (the company guard in COM-1449).
- Read the mail catcher through its API, as in COM-1448.
- Journeys are independent of each other, apart from 2 using 1's gap. If 1 fails, 2 is skipped, not failed.
- Keep the whole run, smoke included, under about 8 minutes.

**Chain:** independent.

**Done when:** all six run green in the post-deploy Browser smoke step on staging.