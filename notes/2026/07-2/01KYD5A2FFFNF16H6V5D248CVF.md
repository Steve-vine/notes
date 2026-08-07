---
id: 01KYD5A2FFFNF16H6V5D248CVF
created: 2026-07-25T17:31:32.207215Z
updated: 2026-08-07T12:15:31.08053Z
type: task
title: Limit-killed runs record their partial transcript and spend breakdown
project: 01KX671DATY39VW6GWK3M2T3DN
number: 295
sprint: svgrad3
comments:
- id: 01KYD71W1ZGP2N3BFRBDHAXNSX
  author: Steve Vine
  at: 2026-07-25T18:02:00.639815Z
  text: |-
    Done — PR #265 (feature/ise-295-killed-run-transcript → main, stacked on #264/ISE-294), CI running.

    - Verified pydantic-ai's capture_run_messages() captures the partial transcript even when run_sync raises (incl. state='interrupted' partials) — so no agent.iter rewrite needed. Wrapped each attempt's run_sync in its own capture_run_messages context (it keeps only the first run per context).
    - On UsageLimitExceeded, serialize the captured messages via ModelMessagesTypeAdapter and record through the normal record_usage path → redaction + compute_token_breakdown, so a killed run gets the same Spend breakdown as a completed one, plus its run_limit_exceeded status + error. Defensive: serialization failure just yields no transcript (as before).
    - Completes the ISE-267 arc (spend was recovered then; this recovers the decomposition). No migration/API/frontend — the ISE-283 run-detail Spend panel already renders token_breakdown, now populated for killed runs.
    - Tests: test_killed_run_transcript.py (fresh-token limit of 1 trips a real TestModel; asserts non-empty transcript + populated token_breakdown). Backend ruff+mypy(320 fresh) green; engine regression (analyse/diagnose/propose/fresh-guard) green.
assignee: steve
label: null
priority: medium
task_status: done
---
**Sprint 24, live-found follow-up (2026-07-25).** The `run_limit_exceeded` diagnose on issue `214bd680` has an **empty `token_breakdown` and no transcript** — on `UsageLimitExceeded` pydantic-ai raises before returning messages, so `record_usage` never sees a transcript and the ISE-283 Spend-breakdown panel goes dark on precisely the run an operator most needs to decompose ("where did 389k tokens go?").

Fix: capture the messages exchanged up to the kill (pydantic-ai's `agent.iter` / run-context message access — verify the cleanest hook) and record them through the normal redaction + `compute_token_breakdown` path, so a limit-killed run stands on the run-detail screen with the same Spend breakdown as a completed one, plus its existing `run_limit_exceeded` status and error.

Completes the ISE-267 arc (limit-killed runs record usage/cost) — usage was recovered then; this recovers the *decomposition*. User-facing surface: the existing run-detail Spend breakdown card, now populated for killed runs.