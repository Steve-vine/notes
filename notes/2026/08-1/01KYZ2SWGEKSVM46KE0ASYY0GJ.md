---
id: 01KYZ2SWGEKSVM46KE0ASYY0GJ
created: 2026-08-01T16:34:04.430001Z
updated: 2026-08-01T19:16:15.562269Z
type: task
title: Four tests pass in the morning and fail in the afternoon
project: 01KX671DATY39VW6GWK3M2T3DN
number: 460
sprint: sfv5yw0
assignee: steve
label:
- bug
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
