---
id: 01M7AFGA4WANVMSR2NCMQJS5KZ
created: 2026-11-13T12:53:15.54895Z
updated: 2026-11-13T13:58:25.406876Z
type: task
title: Designing a collected check reads a sample of the service, not its whole history, so a design batch doesn't use up a service's API limit
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1793
sprint: spsp226
assignee: steve
label: bug
priority: high
task_status: todo
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