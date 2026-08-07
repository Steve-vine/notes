---
id: 01KYZ2SWGEKSVM46KE0ASYY0GJ
created: 2026-08-01T16:34:04.430001Z
updated: 2026-08-07T11:55:22.253865Z
type: task
title: Four tests pass in the morning and fail in the afternoon
project: 01KX671DATY39VW6GWK3M2T3DN
number: 460
sprint: sfv5yw0
comments:
- id: 01KYZC36SVZTGYTJXWE1JED5RJ
  author: Steve Vine
  at: 2026-08-01T19:16:27.067097Z
  text: |-
    Fixed and released 2026-08-01 — PR #399, merged to main.

    Cause, same in both files: the fixture pins its data to a fixed date while the code under test reads the real clock, so the data ages out of a relative window part-way through the day.

    - get_freshservice_summary is a ROUTE handler and cannot take an injectable `now` without exposing it as a query parameter, so it calls datetime.now(UTC) itself. Three tests swept at a frozen NOW (2026-07-31 12:00) and then asked the route for a 24-hour count — true only while the real clock stayed within 24 hours of that date.
    - search_signals also takes no `now` and bounds on now-168h. Its fixture was seen at 2026-07-25 12:00, so the window shut at 12:00 on 2026-08-01 — exactly the observed boundary.

    Both now anchor their fixtures AND their sweep to the real clock. The frozen NOW stays for every other test in those files: they pass an explicit `now` and never consult the wall clock, so they are already deterministic and making them dynamic would trade that away for nothing.

    NO PRODUCTION CODE CHANGED. Worth stating because the alternative reading — that the Freshservice card under-counts arrivals in production — would be far more serious, and it is not what was happening. The window logic is correct; the tests were asserting against a clock they did not control.

    This blocked the Sprint 40 release: `backend` is a required check, so with main red in the afternoon nothing else could merge. Fixing it was the only way to finish the release rather than force merges through.

    Full backend suite on the fix: 2036 passed.
assignee: steve
priority: high
task_status: done
---
Found while running the full suite during Sprint 40 (2026-08-01). **Pre-existing on `main`** — verified by checking out main with every sprint branch removed. Not caused by any Sprint 40 work.

**Failing**
- `tests/integration/test_freshservice_ingest.py::test_the_card_counts_when_a_ticket_was_RAISED_not_when_ISE_stored_it`
- `tests/integration/test_freshservice_ingest.py::test_a_ticket_with_an_unparseable_creation_time_is_not_counted`
- one further test in the same file
- `tests/integration/test_retrieval.py::test_chat_tools_search_and_observe` — asserts a search returns `["checkout memory usage high"]` and gets `[]`

**The tell:** the same commit passed these at ~09:00 UTC and failed them at ~16:00 UTC on the same machine. Consistent, not flaky — they fail every run in the afternoon and passed every run in the morning.

That points at a relative time window somewhere in the fixtures or the code under test — a "last N hours" bound, a day-boundary calculation, or a UTC/local mismatch that only bites once the local clock crosses a threshold. The Freshservice ones are explicitly about *when a ticket was raised*, which is where ISE-444 changed the counting window, so that is the first place to look.

**Why it matters more than the failures themselves:** CI runs whenever a PR opens. A suite that is green in the morning and red in the afternoon teaches everyone to re-run rather than read, and the next real failure gets re-run too.

**Acceptance**
- The cause is named — which window, which boundary — not just patched by widening a tolerance.
- The tests pass at any hour: prove it by running them with the clock frozen at several times of day, including either side of the boundary that currently breaks them.
- If the bug is in the *code* rather than the tests, say so plainly, because then it also affects the Freshservice card in production.
