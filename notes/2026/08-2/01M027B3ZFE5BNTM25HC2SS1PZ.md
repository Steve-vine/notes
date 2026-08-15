---
id: 01M027B3ZFE5BNTM25HC2SS1PZ
created: 2026-08-15T08:06:48.559134Z
updated: 2026-08-15T15:01:40.049199Z
type: task
title: A chat turn can spend 318k tokens and return nothing — bound evidence volume, and land the token cap gracefully
project: 01KX671DATY39VW6GWK3M2T3DN
number: 728
sprint: sevhjex
assignee: steve
label:
- bug
priority: high
task_status: active
tech: null
---
On IN-1358 the same question failed and then succeeded, six minutes apart, with nothing changed by the operator. Measured on staging 2026-08-15:

| run | input | cache_read | fresh | result |
|---|---|---|---|---|
| Q1 06:49 | 149,026 | 124,562 | 24,464 | succeeded |
| **Q2 07:37** | **313,985** | 131,958 | **182,027** | `run_limit_exceeded` |
| Q2 again 07:44 | 103,632 | 79,002 | 24,630 | succeeded |

> `Exceeded the fresh-token limit of 60000 (fresh=186041, total=317999, cache_read=131958)`

Cache behaviour was comparable across the first two runs, so this is not a caching effect. The failed attempt simply gathered three times as much: 314k input against 104k for the identical question. **The same question can cost 24k or 182k fresh depending on what the model decides to pull**, and the run that fails is the one that spent the most — 318k tokens for no answer at all.

**Cause.** A turn is an agentic loop: tool call → result appended to context → decide → repeat. Every evidence pull permanently inflates that turn's input. Two caps exist — `run_max_tool_iterations` and `fresh_tokens_limit` (60,000) — and neither bounds the thing that actually varies. One `server_full_facts` returning 56 facts, or `search_events` returning 16 events, is a single iteration and arbitrary tokens. The system prompt asks for the right discipline (*"Pull only what the answer needs"*, *"search — do not trawl"*), but that is instruction, not enforcement, and on the failing run it did not hold.

**Scope**

1. **Bound evidence volume within a turn**, not just iteration count — a budget over cumulative pulled payload, with the model told what remains so it can choose its last pulls deliberately. Truncating a single oversized result is worth considering, but it must be visible in the result rather than silent, or the model reasons from a fragment believing it has the whole.

2. **Give the token cap the graceful landing the iteration cap already has.** `engine.py:315-345` handles an iteration kill properly: it resumes the exact pending request with a final-answer instruction and **no tools registered**, granting one more request but no more tokens, so the model must conclude from what it already gathered. The token cap has no equivalent — it just dies. Reuse that path.

**Explicitly NOT a partial answer.** Steve, 2026-08-15: *"I'm not sure a partial answer would be a good idea, it could return an incorrect answer."* Correct, and this must not become that. The existing fallback is not a partial answer — it is "stop gathering and answer from everything you pulled", with the model aware of what it did and did not establish. The system prompt already licenses the honest outcome: *"'ISE has no state for that' is a good answer, and a confident guess is not."* Any implementation that lets a truncated evidence set produce a confident answer has made the failure worse, not better. If the model cannot conclude safely, it must say so.

3. **Raising the 60k limit is not the fix** and should be refused if proposed — it moves the cliff without removing the randomness, and makes the wasted runs more expensive when they happen.

**Why it matters beyond cost.** A feature that works or fails at random, and burns the most tokens on the occasions it fails, teaches operators not to rely on it. The question that failed here — reconciling a recovered alert status against an agent still not reporting — was a good one, and it failed for reasons unrelated to its merit.

Related: ISE-264 bounded `analyse-issue` the same way (cheap-verdict-first); `issue-chat` never received that treatment. Its `ai_model_config` carries only `max_tokens: 8192`, an output cap, and nothing bounding input.