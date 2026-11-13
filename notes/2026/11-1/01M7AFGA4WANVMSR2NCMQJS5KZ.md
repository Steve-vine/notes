---
id: 01M7AFGA4WANVMSR2NCMQJS5KZ
created: 2026-11-13T12:53:15.54895Z
updated: 2026-11-13T23:19:15.194861Z
type: task
title: Designing a collected check reads a sample of the service, not its whole history, so a design batch doesn't use up a service's API limit
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1793
sprint: spsp226
comments:
- id: 01M7B48DBTZE3JYMFKGBVVH84X
  author: Steve Vine
  at: 2026-11-13T18:55:56.794371Z
  text: |-
    Built — PR #1789 (feature/com-1793-design-sample), auto-merge set. Independent: no migration, no API change. ADR 0148 amended.

    What you'll see:
    - While Polaris designs a check, both its tries and Compass's sample read only a sample: at most 2 pages of each read and 20 follow-on reads (one page each), spread over the first items.
    - The sample card says where it stopped, e.g. "A sample: the first 60 changes of more; approvals read for the first 20 of them, one page each … A capture reads everything the check defines." It says "of 1,650" when the service gives a total, and counts read "at least N". Field paths and sensitive-field highlights come from the sample.
    - A 429 stops the sample at once: the card shows "The sample stopped — The service asked Compass to slow down…". No retry, no waiting; Polaris is told not to try that service again in the same job.
    - For a check over a growing history, Polaris proposes a window when the service can be asked "updated since" (90 days by default, at most 366) and says so; the read is described as "…, only what changed in the last 90 days". (COM-1799 will turn this into the check's own period.)
    - Captures are unchanged: they read everything the check defines, and still wait and retry on a 429.

    Proof: a whole design job (one try + one proposal) against a fake service with 1,650 changes and their approvals makes 44 requests (production incident: ~4,500). A 429 run makes 2 requests and never sleeps. No service-specific code (test passes).

    Not covered: reads from AWS, Azure, Microsoft 365 and AD aren't sampled this way — only Collection services, where the incident was.

    For you to check (tests can't reach FreshService): a design batch against FreshService — the call count, and that the sample card reads sensibly with its paging.
- id: 01M7BKAHFT5FH8T5FPHMKTNNQF
  author: Steve Vine
  at: 2026-11-13T23:19:15.194629Z
  text: |-
    Pre-UAT: Couldn't check (staging 2f72416b).

    Every part of this needs a real Collection service and Polaris's AI provider to design a check. E2E Test Company has no Collection integration, and the test rules forbid adding one. Nothing on screen in E2E Test Company exercises the design sample.

    What Steve should look at (production, Moneypenny, FreshService):
    1. Re-run a design for CHM.2 against FreshService (or a small design batch). In FreshService's API usage, the job should make at most a few dozen calls (the build's fake-service proof was 44), not thousands. It should finish in minutes.
    2. The sample card should read like "A sample: the first 60 changes of more; approvals read for the first 20 of them, one page each … A capture reads everything the check defines". Counts should read "at least N", or "of 1,650" when FreshService gives a total. Field paths and sensitive-field highlights should still be there.
    3. For a read over a growing history (changes, tickets), the proposal should say it reads only what changed in the last 90 days, if FreshService can be asked "updated since".
    4. If FreshService returns a 429 during the design, the card should say "The sample stopped — The service asked Compass to slow down…" with no retries.
    5. The first approved capture should still read everything the check defines.
assignee: steve
label:
- bug
priority: high
task_status: review
---
## What happened

On 2026-11-13 a design batch ran in production for 16 Moneypenny controls against the new FreshService Collection integration. It made about 4,500 calls to FreshService in 15 minutes, a steady ~400 a minute (FreshService's per-account ceiling), and started getting 429s:

- ~3,750 per-change approval look-ups (`/changes/{id}/approvals`)
- ~360 pages of `/changes` (~1,650 changes, read again and again)
- the rest on `/assets` and `/tickets`

Five controls' proposals took over 15 minutes, and the other eleven queued behind them. Since a service's API limit is usually shared across the customer's whole account, everything else using FreshService was throttled meanwhile.

## Why

`polaris_design.take_sample` runs each proposed check's reads in full (`run_spec`, every page and follow-on reads up to `max_follow`, which defaults to 2,000) and then keeps only the first `SAMPLE_ROWS` to show. Polaris's own tries while designing may also page all the way through.

## What people see

- While Polaris designs a check, both its tries and Compass's sample read **a sample**: at most a couple of pages of each read, and a small number of follow-on reads (say 20), spread over the first rows.
- The sample card says when it stopped early, e.g. "first 200 of more; approvals read for the first 20 changes". The count is shown as "at least N" rather than as if it were the whole.
- Field paths and sensitive-field highlighting come from what the sample read.
- A design batch over a service with a large history finishes in minutes, not tens of minutes, and stays well under the service's rate limit.
- When Polaris designs a read over a growing history (tickets, changes, incidents, audit events) and the service lets it ask for "updated since", it proposes an **incremental read** with a sensible first window (ADR 0148), not a full sweep on every run. The proposal says so.
- The first approved capture is unchanged: it reads what the check defines, within its limits.

## Rules

- Configuration-free and service-agnostic: no code that knows FreshService (ADR 0147 §9).
- A 429 during a sample stops that sample and reports "the service asked Compass to slow down". It doesn't retry until the service's limit is exhausted.

## Done when

- Tests show a design sample stops after the page and follow-on caps, and labels a cut-short sample as such.
- Re-running a design for CHM.2 against FreshService makes at most a few dozen calls.

**Independent.**