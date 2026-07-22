---
id: 01KXH1XNKNP1M4MTRPMH4N7N4C
created: 2026-07-14T19:33:35.989193915Z
updated: 2026-07-22T11:23:13.385621Z
type: task
title: Redact streamed deltas — the invariant SSE breaks
project: 01KX671DATY39VW6GWK3M2T3DN
number: 66
sprint: syz8rn1
blocked_by:
- 01KXH1X85G8DQYM4DJ5GD5E0W2
assignee: steve
priority: high
task_status: done
---
**This is the one invariant the codebase currently holds unconditionally that SSE breaks. Treat it as a security task, not a polish task.**

`redact()` (`logging_setup.py`, ADR 0010) runs on the transcript **at persist time**. SSE deltas go to the browser **raw**, before anything is persisted.

Why that matters: **state-snapshot payloads are connector output** — they are whatever DataDog and the Kubernetes API returned, and they can contain env vars, tokens and DSNs. Assist tools read those payloads (ISE-63), so the model can echo a secret straight into its answer, and today that answer would reach the browser unredacted.

## Why the naive fix does not work

Scrubbing each delta independently misses a secret that **straddles a chunk boundary** — the model emits `...AKIA` in one delta and `IOSFODNN7...` in the next, and neither chunk matches the regex on its own.

## The approach

- Accumulate the full answer text as it streams.
- Re-run the scrubber over the **accumulation** on each flush.
- Emit only the **newly-safe suffix** — the portion that scrubbing has confirmed clean.
- Hold back a **guard band** (~64 chars, ≥ the longest secret pattern) until the stream ends, then flush it.

## Test

A secret **split across two deltas** must not reach the client. Also assert the persisted `AgentRun.transcript` is redacted as it is today (that path must not regress).

Reuse the existing `_scrub_text` / `redact` machinery in `logging_setup.py` — do not write a second redaction implementation, or the two will drift and one of them will be the one that matters.

Blocked by: ISE-65.