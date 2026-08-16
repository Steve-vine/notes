---
id: 01M031MQCVPRJ89ETRJEVYP9QK
created: 2026-08-15T15:46:26.331515Z
updated: 2026-08-16T09:49:07.435218Z
type: task
title: A chat turn killed at the token cap still returns nothing — the graceful landing does not reach stream_chat
project: 01KX671DATY39VW6GWK3M2T3DN
number: 736
sprint: sevhjex
comments:
- id: 01M039JNTWHZZC5KJKA3HQP19B
  author: Steve Vine
  at: 2026-08-15T18:05:07.804404Z
  text: |-
    Built and merged as PR #686 (main 7e85c18a). The landing now reaches stream_chat — assist and issue-chat.

    Transcript capture first, as the task said: `capture_run_messages` is entered INSIDE the run task (so its context var belongs to the run, not to whoever drains the generator) and copied out in a `finally`, so it survives the exception.

    Two things the port surfaced that the engine never had to face.

    **The streaming path kills somewhere else.** The engine always sees the pending `ModelRequest` because both caps fire in `check_before_request`. On the streaming path `check_tokens` runs the moment a response is accounted for, so a token-capped chat turn's transcript ends with a **ModelResponse whose tool calls never ran** — which cannot be resumed at all (a provider rejects tool calls carrying no returns). It is dropped and the answer comes from the hops that completed; there is nothing in it to keep, since it asked for evidence that never arrived. This was found by running it, not by reading: the first implementation returned None on every real kill.

    **The first-token rule** is decided explicitly, as the task asked: the landing applies only when `emitted_text` is false. Both cap kills are covered — the token cap (`check_tokens`) and the iteration cap (`check_before_request`).

    Reuse rather than a second answer: `_prepare_final_call` now makes the one decision (what to resume, with what headroom, under what guard) for a sync and an async runner that differ in nothing but how they call the model, and the iteration-vs-token headroom discriminator moved into `final_answer_headroom` — it was duplicated the moment a second caller existed.

    Persisted as `succeeded` + `degraded: true` + `degraded_reason`, as the engine records it. One extra: a kill that CANNOT land now records its partial transcript too (it used to be skipped as "the run never returned a result") — the ISE-295 recovery, which the capture makes free.

    Tests: `test_chat_limit_landing.py` — the landing, the first-token rule driven by a model that *could* land and is not allowed to, and a landing that fails leaving the turn as it was. Confirmed each fails with the fix switched off.
assignee: steve
label:
- improvement
priority: medium
task_status: done
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