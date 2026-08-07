---
id: 01KZDTK0FZ8AZWNGD8Q2KJPH69
created: 2026-08-07T09:59:07.007449Z
updated: 2026-08-07T12:11:09.45113Z
type: task
title: 'Connector timeout hardening: bound HTTP reads so network outages fail fast'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 606
sprint: sgyvvx3
comments:
- id: 01KZE10PHT7D6KR5DGQBJSH7AF
  author: Steve Vine
  at: 2026-08-07T11:51:27.034482Z
  text: |-
    Built — PR #514 (feature/ise-606-connector-timeouts), ADR 0092. Branched from main, not stacked: it shares no code with #512/#513.

    New `ISE_api.http_bounds` owns the numbers once — 5s connect, 30s read, 1 retry — and exposes the shape each client library actually wants: `client()` for httpx, `bind_urllib3_pool()` for the generated clients, `boto_config()` for botocore.

    Audit result, all eleven covered: Graph/EntraID/M365/Teams (via msgraph), Azure ARM, Cloudflare, Freshservice, GitHub, Confluence, status pages, the Teams bot, Kubernetes, DataDog, AWS.

    Two things the audit turned up that were worth more than the timeout values:

    - The httpx connectors were not actually unbounded, they were UNALIGNED — 10s connect on the Graph/ARM/Cloudflare/Freshservice family, and a flat `timeout=30.0` on GitHub/Confluence/status-pages that applied to the CONNECT phase too, so an unresolvable name cost half a minute per call before a byte was sent. The generated clients (Kubernetes, DataDog) were the genuinely unbounded ones: no socket read deadline at all, and three retries with backoff, which is the 2026-08-06 minutes-long read exactly.
    - Kubernetes and DataDog bind the urllib3 POOL rather than taking `_request_timeout=` per call. The Kubernetes connector makes dozens of list calls; a bound that has to be remembered at each one is a bound the next call site will not have, and binding the pool covers the code paths that do not exist yet.

    The rule is enforced rather than documented: `test_http_bounds.py` fails the build if any module outside `http_bounds.py` constructs a bare `httpx.Client`. That is the part that lasts — the obvious way to write a new connector was the way that reproduced the outage, and a shared helper nobody is obliged to use is a convention the next connector forgets. (Same reasoning as ADR 0085/0086: make the correct thing the path of least resistance.)

    Two calls made in passing, both in the ADR: AWS already had explicit timeouts (ADR 0058) and moves onto the shared clock — botocore counts the first attempt, so one retry is `max_attempts=2` there, which is silent if you get it wrong and is now pinned by a test. And the one-shot OIDC token/JWKS fetches are deliberately left alone: on the login path with a human waiting, already bounded, no pool.

    Trade-off worth flagging: retries 3 → 1 makes ISE marginally more sensitive to a single transient blip. Deliberate — a blip costs one sync interval, and the alternative cost nineteen hours of estate monitoring.

    Full suite green: ruff, mypy strict, 719 unit and all 1,761 integration tests.
- id: 01KZE24S8BP01JFKD78D9DPAB8
  author: Steve Vine
  at: 2026-08-07T12:11:09.450902Z
  text: |-
    Deployed to staging 2026-08-07 (run 31176759374, green). PR #514 fully green post-rebase onto the new main.

    Live confirmation that the bounded clients are doing real work rather than just importing: valkey's `ise:status:durations` (the ISE-607 telemetry) shows real per-task times on staging — 0.005s to 11.3s — so connector syncs are completing normally under the new 5s/30s/1-retry bounds. Nothing in the Platform Log about timeouts.
assignee: steve
priority: medium
task_status: review
---
During the 2026-08-06 g5 DNS outage, connector reads went from ~2s to minutes of urllib3 retry storms (NameResolutionError × 3 attempts with backoff, SSL EOF retries, long default socket timeouts). That inflation — not task volume — collapsed worker throughput below beat's inflow and built the 10k sync-queue backlog. A network outage should degrade to *fast, visible failures* (which the Platform Log already surfaces well), not minute-long hangs.

Audit every connector's HTTP client and apply explicit, tight bounds:

- Connect timeout ~5s, read timeout ~30s (per connector judgement — some Graph/ARM list calls are legitimately slow), retries capped at 1–2 with short backoff.
- Covers: kubernetes client (urllib3 — the worst offender on 2026-08-06), httpx-based connectors (Cloudflare, FreshService, status pages), Graph/EntraID/M365, boto3 (AWS config has its own connect/read timeout + retry `max_attempts` settings), Azure SDK, DataDog, GitHub.
- One shared place for the defaults (settings), so a new connector inherits sane bounds instead of library defaults.
- A sync that fails fast records `last_sync_error` and warns to the Platform Log — the existing surfaces do the rest.

Companion to ISE-605 (task expiry + queue/staleness visibility): expiry makes backlogs self-healing, this stops them forming.