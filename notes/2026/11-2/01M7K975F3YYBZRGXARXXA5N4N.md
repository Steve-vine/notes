---
id: 01M7K975F3YYBZRGXARXXA5N4N
created: 2026-11-16T22:56:34.275882Z
updated: 2026-11-17T19:50:15.418591Z
type: task
title: 'Contract review IDs: CR-n becomes CRV-n'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1889
sprint: s7nqsy0
comments:
- id: 01M7KFJV6QN613M3EY4D2EG158
  author: Steve Vine
  at: 2026-11-17T00:47:48.439344Z
  text: |-
    Done — PR #1878, merged aadd4a37.
    Every contract review now reads CRV-n with its old number: the Contracts list and review page, commitments, mentions, sign-off and approval actions, "From contract …" links, and Polaris's contract tools. New reviews carry on as CRV-(next).
    CR-n still finds the review: given to Polaris, or in the address. /contracts/reviews/CR-4 opens it and the page moves to the review's own address. A link's ?clause= is kept from COM-1890 on.
    Text written before the change keeps its wording. ADR 0157 lists CRV.
    Assumptions: no migration (review numbers come from one sequence). Contract reviews aren't part of the main search and the Contracts screens have no search over review IDs, so "search" here is Polaris and the address.
    To check on staging: reviews read CRV-n; open /contracts/reviews/CR-<n>; ask Polaris about "CR-<n>". Staging check: all 3 review numbers are unique. Before release, run the same check on a copy of production.
- id: 01M7MGYQZS5SXJSQJAGEDEE1VS
  author: Steve Vine
  at: 2026-11-17T10:31:01.368997Z
  text: |-
    Pre-UAT on staging 44d15b9a — Passed
    - Every contract review reads CRV-n with its old number: Passed. As E2E Admin A, Contracts ▸ Reviews lists CRV-4, CRV-2 and CRV-1, and the review page's header and trail read "CRV-1 · E2E 20261030 ACME MSA 2027". Polaris's contracts_list_reviews shows CRV-1 and CRV-2. The Commitments, Positions and Clients tabs name no review here, because E2E Test Company has no commitments from a review.
    - CR-n still resolves: Passed. In the address, as Admin A and the Viewer, /contracts/reviews/CR-1 opens CRV-1 and moves to the review's own address. /contracts/reviews/CR-1?clause=abc keeps "?clause=abc" when it moves. Polaris's contracts_get_review "CR-1" answers "CRV-1 · …". The main search finds no review by either CR-1 or CRV-1: reviews were never part of search, as the Done comment says.
    - New reviews are CRV-(next): Passed. Admin A started "E2E pre-UAT COM-1889 review" (MSA, client E2E 20261030 ACME Ltd), which became CRV-4. It shows in the list, and /contracts/reviews/CR-4 opens it. Its page reads CRV-4.
    - ADR 0157 lists CRV: Passed.
    - Switch-over check on a copy of production: Couldn't check on staging, because it's a step before release.
    - Tests: PR #1878 changes 5 test files. No app/e2e selector reads a review ID.
    Screenshots: ~/compass-uat/s7nqsy0/COM-1889/
    Left behind: CRV-4 "E2E pre-UAT COM-1889 review", now Abandoned.
assignee: steve
priority: medium
task_status: done
---
From Steve's testing of round 2 (staging 43d03f09): every reference should be three letters, a dash and a number. Contract reviews are **CR-n** today.

**Behaviour.** This works the same way as COM-1887 (risks and gaps) and COM-1886 (checks):
- CR-4 becomes **CRV-4**, keeping its number, and the counter carries on.
- The new form shows everywhere an ID is shown:
  - the Contracts list and review page;
  - commitments and comments that name a review;
  - exports from now on;
  - Polaris's contract tools, answers and MCP instructions.
- Old CR-n IDs still find the review in the address, in search and through Polaris, and old links redirect.
- Text written before the change keeps its wording.

**Done when**
- On staging, every contract review reads CRV-n with its old number, and CR-n still resolves.
- New reviews are numbered CRV-(next).
- The three-letter reference ADR (from COM-1887) lists CRV.
- The switch-over is checked on a copy of production data before release.
- Tests cover formatting, old IDs resolving, a new review, and the e2e selectors.

**Where** (for the builder): models/contract.py (`REVIEW_REF_PREFIX`), the route or search that resolves an ID, frontend contract pages, assistant/tools (contracts) and MCP instructions. Built after COM-1887.