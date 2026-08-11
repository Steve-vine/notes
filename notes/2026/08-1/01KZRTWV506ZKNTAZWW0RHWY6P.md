---
id: 01KZRTWV506ZKNTAZWW0RHWY6P
created: 2026-08-11T16:36:07.968625Z
updated: 2026-08-11T22:34:22.641847Z
type: task
title: 'Business Services page: make it usable'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 657
sprint: sj9fsph
comments:
- id: 01KZSDBDSQBWY6JT6PF1THJBDS
  author: Steve Vine
  at: 2026-08-11T21:58:40.182999Z
  text: |-
    Done — stacked on ISE-656, PR to follow it onto main.

    The loop this sprint opened with is closed, and closed with a test rather than an assertion of confidence: `test_the_rollup_reaches_a_business_service_end_to_end` walks a Resource going red → its Business Applications → the Business Services above them, with the proportion. **Every hop of that chain was empty when the sprint started.**

    On the page itself, the fix turned out to be less about the composer and more about **which emptiness it is** (ADR 0056's rule again):

    - **No Business Applications at all** → the page says so by name and links to where they're confirmed. This is the real state today, and it's a completely different problem from "you haven't defined a Business Service yet" — different next action, different screen.
    - **The composer, opened anyway**, explains the prerequisite in place of an empty picker. That was the actual reported symptom: an empty MultiSelect plus a disabled Create button, with nothing on screen distinguishing "broken" from "waiting on something".
    - **"No business services yet"** is kept for the case where one genuinely could be built.

    Copy renamed throughout. The non-customer-facing fault banner is untouched (ADR 0073 §7 — there are no test Business Services).

    Worth noting for the smoke test: with the estate as it stands, this page will show the *first* empty state, not the third. That is correct and is the point — it now tells you the prerequisite instead of looking broken. To get past it you need a confirmed Business Application, which needs a proposal, which needs an entity carrying both `app:` and `env:` — the original diagnosis. Confirming the `crossplane-name` mapping proposal (49 entities, already queued) gives a rule that can name a database today without retagging anything.
assignee: steve
label:
- bug
priority: medium
task_status: review
---
The page cannot currently be used at all. The "Composed of" MultiSelect is fed by `/api/v1/applications`, which returns nothing, and Create stays disabled while no application is selected (`BusinessServicesPage.tsx:229,242`) — so the field reads as broken when it is merely empty. Zero `business-service` entities exist.

- Composer offers **Business Applications** (post-rename)
- Empty state explains the prerequisite and links to Business Applications, instead of presenting a dead field
- Rename throughout page, nav and copy
- Keep the non-customer-facing fault banner (ADR 0073 §7 — there are no test Business Services)
- Verify the rollup end to end: a Resource going red reaches its Business Applications and then the Business Services above them

This is the task that closes the loop the sprint opened with — the reported symptom that started the design.