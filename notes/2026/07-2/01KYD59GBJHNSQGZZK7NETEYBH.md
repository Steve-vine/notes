---
id: 01KYD59GBJHNSQGZZK7NETEYBH
created: 2026-07-25T17:31:13.650944Z
updated: 2026-08-06T08:15:29.627708Z
type: task
title: Run token guard counts fresh tokens, not cached re-reads
project: 01KX671DATY39VW6GWK3M2T3DN
number: 294
sprint: svgrad3
comments:
- id: 01KYD6NEQXPRWZB6QKXW00BMQ2
  author: Steve Vine
  at: 2026-07-25T17:55:13.789705Z
  text: |-
    Done — PR #264 (feature/ise-294-fresh-token-guard → main), CI running.

    - Verified the API: pydantic-ai total_tokens = input + output, and for the cache-aware providers input_tokens INCLUDES the cached portion (so total includes cache reads — matching the live 389k total / 280k cache). fresh = total − cache_read is correct.
    - FreshTokenUsageLimits(UsageLimits) overrides check_before_request / check_tokens / has_token_limits (the last because the streaming path gates check_tokens on it) to guard total − cache_read. usage_limits_for builds it with fresh_tokens_limit → both single-shot runs AND chat guard the honest metric with the SAME numbers. Per-task caps (ISE-286) unchanged. $ ceiling stays the cost control.
    - ADR 0033 note added. Env defaults (200k run / 60k chat) are honest and unchanged; the 2026-07-24 admin overrides (300k / 200k in spend_policy) get walked back on the deployment — I'll do that when I redeploy staging.
    - Tests: test_fresh_token_guard.py (live case doesn't trip 200k; fresh-over-limit raises; has_token_limits gates streaming; request_limit intact; usage_limits_for builds fresh guard). Backend ruff+mypy(319 fresh) green.
assignee: steve
priority: high
task_status: done
---
**Sprint 24, live-found follow-up (2026-07-25).** Motivating case: a diagnose on IN-triggered issue `214bd680` was killed `run_limit_exceeded` at total_tokens=389,468 vs the 300k admin cap — but **280,017 of that was cache reads**; fresh tokens were ~108k and the run cost $0.34, progressing normally. The guard counts cached re-carry at full weight, so any evidence-rich tool loop grows its *counted* total ~quadratically with hops and hits whatever cap is set around hop 10–13. Raising the cap (200k→300k on 07-24) just moved the wall — the ISE-264 audit's exact prediction.

Fix: the runaway guard compares against **fresh tokens (total − cache_read)** — re-carried cached context is the legitimate, ~0.1×-priced bulk (ISE-107); fresh assembly is the runaway signal. Per-task caps (ISE-286) keep their values but bite on the honest metric. Likely a custom per-hop check in the engine rather than pydantic-ai's `total_tokens_limit` (which sums usage.total_tokens incl. cache reads) — verify what UsageLimits allows before building around it.

- ADR note amending the cap semantics (touches ADR 0033 / the ISE-286 comment block in engine.py).
- Then walk the admin `ai_run_max_tokens` override (300k, set 2026-07-24 in spend_policy) back down to an honest default.
- Chat cap was also raised 60k→200k on 07-24 — review it against the same metric while here.

The $ ceiling stays the cost control; this only makes the count guard measure what it claims to guard against.