---
id: 01M031MQCVPRJ89ETRJEVYP9QK
created: 2026-08-15T15:46:26.331515Z
updated: 2026-08-15T17:22:47.014944Z
type: task
title: A chat turn killed at the token cap still returns nothing — the graceful landing does not reach stream_chat
project: 01KX671DATY39VW6GWK3M2T3DN
number: 736
sprint: sevhjex
assignee: steve
label:
- improvement
priority: medium
task_status: active
tech: null
---
Raised 2026-08-15 while building ISE-728, which delivered the graceful landing on the **single-shot** engine path only. This is the other half, and it is the half IN-1358 actually hit.

**Where it stands.** `engine.run_agent` now gives a token-cap kill one tools-disabled final call, so a run that gathered real evidence answers from it instead of finishing `run_limit_exceeded` with nothing. `stream_chat` — assist and issue-chat — still dies.

**Why it could not simply be wired in.** The two paths handle the kill differently, and the difference is load-bearing:

- `run_agent` wraps its call in `capture_run_messages`, so on a kill the captured transcript ends with the exact `ModelRequest` that was about to be sent. That is what `_degraded_final_answer` resumes.
- `stream_chat`'s handler explicitly records no transcript — *"No `messages_json` here (the run never returned a result), so the transcript is skipped; the token count and cost are not."* There is nothing to resume from.

So the work is **transcript capture on the streaming path first**, then the same landing. And `ai/chat.py` is the module whose own docstring lists three properties it must hold in order of how badly they bite — a run is always recorded, no database connection is held across the model call, nothing raises — so this is not a mechanical port.

**Scope**
- Capture the run messages on the streaming path, cancel-shielded like everything else there.
- On `UsageLimitExceeded`, run the tools-disabled final call and emit its text as deltas, honouring the FIRST-TOKEN RULE: if text has already reached the browser, a second attempt would duplicate or contradict what the operator has read. That probably means the landing only applies when `emitted_text` is false — worth deciding explicitly rather than by omission.
- Reuse `_degraded_final_answer` and `_final_call_token_limit` rather than writing a second answer to the same question (ISE-686/687 is the standing lesson, and ISE-727 found it three more times).
- The turn's persisted status: `succeeded` with `degraded: true`, as the engine path does, so the conversation reads as answered rather than failed.

**How urgent, honestly.** Less than it was. ISE-728's evidence budget bounds the thing that actually varied — the identical question cost 24k fresh tokens once and 182k the next — so a chat turn should reach the token cap far less often. This is the safety net for when it still does, not the primary fix.

**Not a partial answer**, exactly as ISE-728 recorded: it is "stop gathering and answer from everything you pulled", with the model told to say what it could not establish. An implementation that lets a truncated evidence set produce a confident answer has made the failure worse.