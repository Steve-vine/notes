---
id: 01M027B3ZFE5BNTM25HC2SS1PZ
created: 2026-08-15T08:06:48.559134Z
updated: 2026-08-15T17:17:50.374169Z
type: task
title: A chat turn can spend 318k tokens and return nothing — bound evidence volume, and land the token cap gracefully
project: 01KX671DATY39VW6GWK3M2T3DN
number: 728
sprint: sevhjex
comments:
- id: 01M031M0037FMGR9V2QWP9ENB9
  author: Steve Vine
  at: 2026-08-15T15:46:02.37158Z
  text: |-
    Done — PR #684, merged to main 2026-08-15. **One half is not fully delivered; that is at the bottom and it is the part that matters most to you.**

    **1. The evidence budget — the fix for the randomness, and it does cover issue-chat.** `AgentDeps` carries a cumulative character budget (120k ≈ 30k tokens), spent by the pull tool. Two properties matter as much as the number:

    - **Refused before the fetch.** The harm of an over-budget pull is that its payload lands in the context *permanently*, so declining after fetching would cost exactly what the budget exists to prevent.
    - **Visible, never silent** — and it says what *remains*, not merely "no", so the model can choose its last pulls deliberately instead of discovering the wall by hitting it. A tool-side guard in the shape of `note_empty_search`, since as you say instruction is not enforcement.

    **2. The graceful landing — built, and the reason it did not already exist turned out to be real.** The engine's comment said a token-cap kill gets no final call because "an extra request after it would simply defeat it". True of an *unbounded* request; not of this one, since no tools are registered and the model cannot gather anything more.

    But there was a harder obstacle underneath, which is why simply "reusing that path" would not have worked: **after a token-cap kill the fresh count is already past the cap**, so carrying the cap into the resumed call grants nothing — it raises in `check_before_request` before reaching the model. The ceiling has to be built from what was *spent* plus a small headroom. An iteration-cap kill still gets zero headroom, which remains exactly right for it.

    Not a partial answer, per your note — the tests assert the refusal text tells the model to say what it could NOT establish.

    **3. The 60k limit is untouched**, as instructed.

    **⚠️ What is NOT done: the graceful landing does not yet reach the chat surfaces — which is where IN-1358 happened.**

    `stream_chat` has its own `UsageLimitExceeded` handler and, unlike `run_agent`, it **does not capture the transcript** ("No `messages_json` here — the run never returned a result"). Without the captured messages there is nothing to resume, so the landing cannot simply be wired in: the streaming path needs `capture_run_messages` first, and that is the module whose docstring lists three properties it must hold. I judged that too delicate to add unsmoke-tested at the end of a long session rather than doing it badly.

    So today: a chat turn that trips the token cap still ends with `run_limit_exceeded`. What has changed for chat is that it should trip it far less often, because the evidence budget is what bounds the thing that actually varied. I have raised **ISE-736** for the chat half.

    Two existing tests encoded the old "token cap = dead run" contract and were updated, not deleted — the budget test still proves the kill happened and cost real money, and the transcript test now disables the degraded call outright, because its property is what a run killed AT the wall records.
assignee: steve
label:
- bug
priority: high
task_status: done
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