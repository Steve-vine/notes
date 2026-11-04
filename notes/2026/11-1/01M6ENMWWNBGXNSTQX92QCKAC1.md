---
id: 01M6ENMWWNBGXNSTQX92QCKAC1
created: 2026-11-02T17:41:53.173367Z
updated: 2026-11-04T18:21:42.931849Z
type: task
title: Polaris sees every clause's full comparison when it reviews a contract — nothing is cut short partway through a batch of clauses
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1527
sprint: sm2a4gc
assignee: steve
label:
- bug
priority: high
task_status: active
---
Contract Review - Updates. Found by Steve testing Contract Review (ADR 0134) on staging, 2026-11-02. **On the chain** — changes the review-context API response (no migration).

## What happened

Steve asked Polaris (in Compass) to review a contract. Polaris reported:

> "I didn't see the full comparison data for about 35 clauses because Compass cut several results short. These include most of 2, 3.1(a)–(d), 6.3, 7, 8, 10, 11.2–11.3 and 13.2–13.7. I compared those directly with the full text of our standard NDA instead."

So for roughly a third of the contract, Polaris judged clauses without what Compass holds for them — the approved position, what we actually do, related records — and only against the standard NDA it read separately. Flags on those clauses may say "matches" or "differs from standard" where they should have said "conflict" or "outside position", and nothing on screen tells the reviewer that.

## What people should see

- Polaris gets the full comparison for every clause it reviews, however long the contract and however many standard-contract clauses or records apply.
- If Compass ever can't give Polaris a clause's comparison, that clause stays with Polaris (or is flagged "can't tell") — it is never judged on part of the picture.

## Cause (technical)

- In-app Polaris cuts any single tool answer at 60,000 characters (`core/polaris/tools.py` `MAX_RESULT_CHARS`, `_capped`). `contracts_review_context` returns a page of 15 clauses (`CONTEXT_PAGE` in `api/v1/contracts_reviews.py`), each carrying its own copy of every matching standard-contract clause's full text (up to 25, `_standard_clauses`), every "what we do" record for its topic (up to 25 per reader) and up to 8 related records (`core/contracts/judging.py` `context`). Clauses on the same topic repeat the same standard clauses and records, so a page easily exceeds 60k and the later clauses in it lose their context mid-JSON.
- The page's `more` flag is computed before the cut, so Polaris carries on after the last clause it *asked for* — the cut clauses are never re-fetched.

## Approach (for the PR)

- Size the page by its encoded length, not a fixed count: fill clauses until a budget comfortably under the tool cap (e.g. ~45k) is reached; always at least one clause; `more` reflects what was actually sent.
- Send shared material once per page: standard-contract clauses and "what we do" records in a page-level list keyed by id, with each clause referencing the ids that apply to it. Keep the `kind`/`id` pairs `contracts_flag_clauses` cites unchanged.
- Consider trimming a single very long standard clause's text with an explicit "ask for clause N of the standard" pointer (`contracts_read_standard_contract`) rather than letting the cap cut JSON.
- External MCP clients have no 60k cap but get the same smaller pages — fine.
- Update the tool description if paging wording changes; check the route docstring/OpenAPI drift (the endpoint's response model will change).

## Done when

- A review of a long contract (the NDA Steve used, or a fixture with ~50 clauses sharing a few topics and a standard contract with long clauses) gives Polaris every clause's full context across its pages — no "Compass cut this result short" in any `contracts_review_context` answer.
- Test: a page whose clauses together would exceed the budget comes back smaller with `more: true`, and the next call starts at the first clause not sent.
- Test: shared standard clauses/records appear once per page and each clause references them.
- Re-running Polaris on Steve's contract on staging records flags for 2, 3.1(a)–(d), 6.3, 7, 8, 10, 11.2–11.3 and 13.2–13.7 from their full comparison.