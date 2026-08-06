---
id: 01KYAT4V3GY1W7WKPZK3YFCVED
created: 2026-07-24T19:37:57.616916Z
updated: 2026-08-06T07:28:25.770063Z
type: task
title: budget_exceeded message conflates two different failures
project: 01KX671DATY39VW6GWK3M2T3DN
number: 266
sprint: sthz8ne
comments:
- id: 01KYC52H8YVG3KXNW7VNR7N6X7
  author: Steve Vine
  at: 2026-07-25T08:08:10.782417Z
  text: |-
    Done — PR #252 (green), merged to staging.

    Chose the distinct-status route over branching on `outcome.error` (robust, no fragile error-string sniffing; also fixes persisted chat rendering, and the timeline's `run` object didn't even expose `outcome`). New status `run_limit_exceeded`:
    - `AGENT_RUN_STATUSES` + migration 0050 widen the `agent_run.status` CHECK (additive).
    - engine.py and chat.py set it on the `UsageLimitExceeded` path; chat keeps its distinct live-stream `limit_exceeded` reason.
    - Timeline surfacing filter (ISE-102) includes the new status.
    - Frontend: distinct **red** pill (vs orange refusal), and a timeline message that says the run executed and points at **Run max tokens** in Settings → AI — not the ceiling. AgentRunsPage status filter gains the option.

    No OpenAPI change (`status` is a plain string, not an enum — verified the dump snapshot is identical). Tests: backend engine + chat cap tests assert `run_limit_exceeded`; new timeline-surfacing test; frontend IssueConversation message test + statusColors colour assertions.
assignee: steve
label: null
priority: medium
task_status: done
---
Found live 2026-07-24: `IssueTimeline.tsx:431` maps every `budget_exceeded` run to "The daily AI budget is exhausted, so this did not run. Try again later." But the status covers two unrelated failures:

1. **Pre-flight daily-spend refusal** — didn't run, cost nothing, "try again later" is correct.
2. **Mid-run per-run token cap** (`Exceeded the total_tokens_limit of N`) — the run executed, spent real money, and retrying later hits the same wall. The operator was sent to the Spend Limits screen where nothing was near the ceiling.

Fix: distinguish the cases in the timeline (and anywhere else `budget_exceeded` is rendered — chat surfaces have their own messages, check them). The backend already stores the truth in `outcome.error` — surface it: "This run exceeded the per-run token limit (216,560 of 200,000). Raise Run max tokens in Settings → AI, or investigate why the run grew." vs the existing daily-budget text. Consider whether the two cases deserve distinct statuses (`budget_exceeded` vs `run_limit_exceeded`) — status is checked in several places, so weigh the migration against just branching on outcome.