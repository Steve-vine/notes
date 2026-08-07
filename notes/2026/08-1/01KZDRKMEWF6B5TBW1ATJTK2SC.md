---
id: 01KZDRKMEWF6B5TBW1ATJTK2SC
created: 2026-08-07T09:24:30.300434Z
updated: 2026-08-07T16:13:45.846742Z
type: task
title: Assist question bank — benchmark questions as staging acceptance tests
project: 01KX671DATY39VW6GWK3M2T3DN
number: 595
sprint: snk16ew
assignee: steve
label: null
priority: medium
task_status: active
---
The sprint's definition of done: Assist answers the mission's benchmark questions correctly on staging.

Seed set (Steve, 2026-08-07): which App Registrations expire in the next 90 days; how many users have passwords expiring in 5 days; what does the Chinwag deployment document say about X; what would happen if X stopped responding. Extend with 2–3 per integration (DataDog, K8s, AWS, Azure, Cloudflare, M365) exercising synced state, live evidence, documents, and the graph.

- Record the bank as a checklist (Notuvia memo, like the ISE Test Plan) with expected-answer criteria.
- Where mechanically checkable, add integration tests asserting the *tool path* can produce the answer (right tool exists, filters work) — the prose answer itself stays a staging smoke check.
- Run the bank against staging at sprint end; failures become fix tasks.