---
id: 01M0N7DCK3SK1Y0CQ6S55WVWNG
created: 2026-08-22T17:13:37.123488Z
updated: 2026-08-22T17:13:47.476273Z
type: task
title: Test an assessment — a dry-run of the supplier's form from the builder
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 367
sprint: sbph5q5
assignee: steve
label:
- feature
priority: medium
task_status: todo
---
There is no way to see an assessment as the supplier will before sending it to one. Add a **Test** button on each assessment in the builder (the Vendor Assessments tab) that runs the form as a dry-run.

- [ ] **Test** opens the form in the same renderer the Vendor Portal uses — same component, not a lookalike, or the test stops testing the real thing. Answers are **ephemeral**: client-side state only, no `VendorAssessment`, no answer rows, no tokens, no emails, nothing in the activity log.
- [ ] The dry-run exercises what the sender needs to check: question order, kinds and options, required markers, validation messages, the live percentage indicator, and — once conditional questions land — children appearing and disappearing as trigger answers change (the main reason testing is now needed).
- [ ] A submit in test mode runs the same client-side validation and ends in a "this was a test — nothing was recorded" state rather than a completion.
- [ ] Available to the roles that build forms (vendor-write), from the builder list; a Test on a form with zero active questions says so instead of rendering an empty run.
- [ ] Implementation note: this should fall out of extracting the portal's fill component into a shared piece taking answers-state + callbacks, with the portal wiring persistence and test mode wiring local state. If the extraction is awkward, that awkwardness is coupling worth fixing anyway.
- [ ] Tests: test mode writes nothing (assert no assessment/answer rows after a full run); renderer parity (same component identity, not a copy); zero-question state; conditional show/hide works in test mode once available.