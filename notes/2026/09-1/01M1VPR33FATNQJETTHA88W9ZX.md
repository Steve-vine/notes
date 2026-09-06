---
id: 01M1VPR33FATNQJETTHA88W9ZX
created: 2026-09-06T15:52:44.911656Z
updated: 2026-09-06T15:59:01.425332Z
type: task
title: schema.d.ts drifted after COM-585 — the callback's docstring is part of the contract
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 593
sprint: s2fcksg
comments:
- id: 01M1VQ3JK39A84D9QZNSJXFXHK
  author: Steve Vine
  at: 2026-09-06T15:59:01.218904Z
  text: 'Done — PR #602 merged to main (3d40426). Only the generated schema.d.ts changed: the 16 lines of the grant callback''s docstring that COM-585 rewrote. Waiting for the main backstop and image build to go green before promoting to staging.'
assignee: steve
label:
- chore
priority: high
task_status: review
---
The push-to-main backstop went red after COM-585 merged (run 34043438470): `check-openapi-drift.sh` found 16 lines missing from `app/frontend/src/api/schema.d.ts`.

COM-585 changed no request or response shape, so the schema was not regenerated — but the endpoint's docstring is emitted as the operation's OpenAPI `description`, and the generator copies it into the type file. A docstring edit on a route is a contract edit as far as the drift check is concerned.

- [ ] Regenerate `schema.d.ts` on main and commit it. Nothing else changes.
- [ ] Not deploying until the backstop is green (ADR 0041).

Lesson for the loop: run the drift script on any backend PR that touches a routed function, not only on ones that change a Pydantic model.