---
id: 01KZDRKMEWF6B5TBW1ATJTK2SC
created: 2026-08-07T09:24:30.300434Z
updated: 2026-08-07T16:18:09.79915Z
type: task
title: Assist question bank — benchmark questions as staging acceptance tests
project: 01KX671DATY39VW6GWK3M2T3DN
number: 595
sprint: snk16ew
comments:
- id: 01KZEG8XRTNM09YNH6F3VGFTV7
  author: Steve Vine
  at: 2026-08-07T16:18:05.210102Z
  text: |-
    Done — PR #523 (feature/ise-595-assist-question-bank) + memo "ISE Assist Question Bank" (01KZEG7HEAWGY8G1MCGKGEF3ZN, linked to the ISE project).

    Split the bank in two, deliberately:
    - TOOL PATH (mechanical, in CI) — tests/integration/test_assist_question_bank.py.
    - PROSE ANSWER (hand-run on staging) — the memo checklist.
    The two failures have different fixes: a model never SHOWN the facts is a tool gap (ISE-540, ISE-599); a model shown them and still wrong is a prompt problem (ISE-602). Conflating them is exactly how "no reference to Crossplane exists anywhere in the estate" got read as a model failure when it was a missing tool.

    CI guards:
    - BANK table = 21 questions, each with the tools its answer travels through. Every named tool is asserted to exist on the live ASSIST agent, so a tool renamed or dropped out of ASSIST_TOOLS breaks CI rather than rotting in a checklist that still READS as coverage.
    - A second guard: no banked question may route through anything that acts. Assist is read-only; a question needing action is a product decision, not a quiet edit to the list.
    - Six cases against real Postgres: app-registration 90-day expiry (total not page length), the password count (a NUMBER; an absent key is not a match), the COLD document search + read, a two-hop blast radius, and an attribute question that names nothing at all.

    The memo: seed set (4) + 2-3 per integration across K8s / DataDog / AWS / Azure / Cloudflare / M365 / EntraID + 4 cross-integration synthesis questions. Plus five criteria that apply to EVERY answer — names its source and freshness, never offers to act, a count is a number, absence is proven not assumed, cites — and a run log table for the sprint-end staging pass.

    Note the last synthesis question is the ISE-540 regression check: "what do we know about <technology with no entity named after it>" must be found via tags and repos, never answered "no reference exists".

    Remaining: run the bank against staging at sprint end; failures become fix tasks and get logged in the memo's run log.

    No production code changed. ruff + mypy strict + suite green locally.
assignee: steve
label: null
priority: medium
task_status: review
---
The sprint's definition of done: Assist answers the mission's benchmark questions correctly on staging.

Seed set (Steve, 2026-08-07): which App Registrations expire in the next 90 days; how many users have passwords expiring in 5 days; what does the Chinwag deployment document say about X; what would happen if X stopped responding. Extend with 2–3 per integration (DataDog, K8s, AWS, Azure, Cloudflare, M365) exercising synced state, live evidence, documents, and the graph.

- Record the bank as a checklist (Notuvia memo, like the ISE Test Plan) with expected-answer criteria.
- Where mechanically checkable, add integration tests asserting the *tool path* can produce the answer (right tool exists, filters work) — the prose answer itself stays a staging smoke check.
- Run the bank against staging at sprint end; failures become fix tasks.