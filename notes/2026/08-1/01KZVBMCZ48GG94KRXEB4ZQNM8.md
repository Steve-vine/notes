---
id: 01KZVBMCZ48GG94KRXEB4ZQNM8
created: 2026-08-12T16:07:05.956876Z
updated: 2026-08-12T16:07:05.956876Z
type: task
title: Tune low / high scanner concurrency profile values from prod telemetry
assignee: steve
imported_from: linear
label: follow_up
priority: low
task_status: backlog
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 126
---
Brief 015 / DEV-164 shipped three named scanner concurrency profiles (`low`, `medium`, `high`) bundled in `PROFILE_DEFAULTS` (`app/backend/src/redvektor_api/core/scan_engines.py`). The starter values are defensible but **not measured against real workloads**:

| Profile | rate_limit | threads | timeout | pre_resolve_concurrency | pre_resolve_timeout |
| -- | -- | -- | -- | -- | -- |
| `low` | 5 | 2 | 10 | 20 | 2.0 |
| `medium` (default) | 25 | 10 | 5 | 50 | 2.0 |
| `high` | 150 | 50 | 5 | 200 | 2.0 |

* `medium` mirrors current Brief 013 numbers — known-good for home-network egress.
* `low` is conjecture for genuinely flaky links — not validated against a real flaky link.
* `high` reuses Brief 013's *pre-fix* httpx defaults — the values that compounded conntrack exhaustion on home networks. Correct for cloud egress in theory; not measured.

## Why now is too early

Tuning needs httpx scan throughput observability — per-host probe rate, NXDOMAIN drop counts, conntrack pressure indicators, egress-router behaviour over the run. Today we have:

* `ScanJob.meta["dispatched_opts"]` (Brief 015) — what dial was used.
* `ScanJob.meta["summary"]` and the `preresolve_*` extras (Brief 013) — duration, asset count, drop counts.
* Datadog APM / OTEL on the API + worker pods.

What we don't have: a way to observe whether `high` actually saturates cloud egress without dropping connections (we'd see this as elevated httpx exit-non-zero rates or sub-linear scaling vs. input count), or whether `low` is conservative enough on a real flaky link.

## Pick-up signal

Do this after a real prod deploy has logged ≥10 scans on `high` against varied targets, **or** sooner if a deploy reports throughput problems on either extreme. Look for:

* `high` too aggressive — non-zero exit rate climbing with input count, intermittent connection-reset patterns in stderr excerpts, `dropped_other` counts climbing under steady DNS conditions. Likely fix: reduce `rate_limit`/`threads`, leave `pre_resolve_concurrency` alone (DNS is rarely the bottleneck).
* `high` too conservative — wall-clock budget exhausted on input lists where pre-resolve confirms the inputs are live. Likely fix: increase `rate_limit`.
* `low` too aggressive — same conntrack-exhaustion pattern Brief 013 fixed at `medium`'s level. Likely fix: lower further.
* `low` too conservative — finishes well within budget on flaky-link smoke targets but takes far longer than necessary. Likely fix: bump `rate_limit` toward `medium`.

## Out of scope here

* Adding a fourth profile.
* Per-target profile.
* Auto-detection of egress shape.
* Promoting `subfinder.timeout` into the profile (it's a wall clock, not a throughput dial).
* Frontend visibility of the profile.

## Fix shape (when picked up)

A one-line `PROFILE_DEFAULTS` change in `app/backend/src/redvektor_api/core/scan_engines.py`, plus update the table in `docs/architectural-standards.md` § Scanner concurrency profile, plus a session summary. No ADR required — ADR 019 already covers the *mechanism*; this is a values change inside the established mechanism. Likely small-fix flow, not a full brief.

## References

* Brief 015 — `docs/briefs/015-scanner-concurrency-profile.md`
* ADR 019 — `docs/decisions/019-scanner-concurrency-profile.md`
* Brief 013 — `docs/briefs/013-httpx-throughput-and-preresolve.md` (the home-network failure mode that drove conservative `medium`)
* Architectural standards — `docs/architectural-standards.md` § Scanner concurrency profile

---

Imported from Linear [DEV-172](https://linear.app/stevevine/issue/DEV-172/tune-low-high-scanner-concurrency-profile-values-from-prod-telemetry) · parent DEV-164