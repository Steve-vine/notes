---
id: 01KYD5A2FFFNF16H6V5D248CVF
created: 2026-07-25T17:31:32.207215Z
updated: 2026-07-25T17:45:40.104127Z
type: task
title: Limit-killed runs record their partial transcript and spend breakdown
project: 01KX671DATY39VW6GWK3M2T3DN
number: 295
sprint: svgrad3
assignee: steve
priority: medium
task_status: todo
---
**Sprint 24, live-found follow-up (2026-07-25).** The `run_limit_exceeded` diagnose on issue `214bd680` has an **empty `token_breakdown` and no transcript** — on `UsageLimitExceeded` pydantic-ai raises before returning messages, so `record_usage` never sees a transcript and the ISE-283 Spend-breakdown panel goes dark on precisely the run an operator most needs to decompose ("where did 389k tokens go?").

Fix: capture the messages exchanged up to the kill (pydantic-ai's `agent.iter` / run-context message access — verify the cleanest hook) and record them through the normal redaction + `compute_token_breakdown` path, so a limit-killed run stands on the run-detail screen with the same Spend breakdown as a completed one, plus its existing `run_limit_exceeded` status and error.

Completes the ISE-267 arc (limit-killed runs record usage/cost) — usage was recovered then; this recovers the *decomposition*. User-facing surface: the existing run-detail Spend breakdown card, now populated for killed runs.