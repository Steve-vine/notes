---
id: 01M5VNJTW56N1ZMGF01HX0DD3N
created: 2026-10-26T08:35:11.365987Z
updated: 2026-10-26T19:47:33.11696Z
type: task
title: 'Polaris answers: the engine that talks to the chosen model, uses Compass''s tools as the person, streams its reply, and records what each reply cost'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1329
sprint: s9ls6e7
blocked_by:
- 01M5VNJEZ1AC8X5ZDB2T2G9A51
comments:
- id: 01M5VYR6BK1NY0CWZMH6Y5EYV2
  author: Steve Vine
  at: 2026-10-26T11:15:24.147367Z
  text: |-
    Done — merged to main (PR #1346, migration 0706).

    - **You send a prompt and Polaris answers in the background**, as you, with what your role allows: it reads, uses Compass's tools, and replies. Its words stream to the window as they're written.
    - **It's the same Polaris as the MCP's**, with the same instructions and tools, plus a short note that it's working in the Compass window.
      - It calls Compass's own MCP door in-process, with a credential made for that turn. The credential lasts 15 minutes and is deleted when the turn ends.
      - So the per-person tool list, "via Polaris" in the activity log, and every check a screen makes all apply exactly as they do for an outside assistant.
    - **Every model call is recorded**: who it was for, the conversation, the provider, the model, tokens read (fresh, cached and written to the cache) and written, and the cost at that model's price.
    - **Stop ends the turn** at the next word or tool. Whatever was already changed stays changed.
    - **If the provider fails** (a refused key, rate limiting, an outage) or the model declines, the window says so plainly. Nothing is retried silently.

    My calls (beyond the task):
    - **A turn runs inside the API, not as a background job.** The tools need the running app, and a model call spends money, so it can't be a job that is safely re-run. If a deploy kills a turn mid-answer, the conversation is marked interrupted and freed.
    - **The window long-polls for Polaris's words rather than holding a stream open.** That way any API instance can answer, and nothing streams through nginx.
    - **Polaris isn't sent all 631 tools.** A conversation's tools are fixed when it starts: the general ones, the tools for the section you're on, and "find a tool" / "use a tool" to reach anything else your role allows. This keeps each prompt cheap and the provider's cache working.
    - **A single tool result is capped at 60,000 characters**, and Polaris is told to ask for less. That stops one "list everything" from running up the bill.
    - **History is never trimmed.** Current Claude models refuse a conversation whose earlier turns were changed.
    - **A turn stops after 30 model calls** and asks you to tell it to carry on.
    - **The real Anthropic and OpenAI SDKs are tested against canned replies.** Nothing has met a real key yet, so your smoke test is the first real call.
assignee: steve
label:
- feature
priority: high
task_status: done
---
## Behaviour

- **You send a prompt and Polaris answers**, as it does today through your own assistant:
  - it reads what it needs,
  - it uses tools,
  - it replies in words, with links to the records it mentions.
- **It is the same Polaris.** It follows the same instructions the MCP gives an outside assistant and uses the same tools, with your permissions. A tool your role can't use isn't offered.
- **Its reply streams in** as it's written. Between words you see what it's doing, for example "Reading DDQ-4" or "Searching the library".
- **Stop** ends the turn at once. Anything already changed stays changed and is in the activity log.
- **Every model call is recorded:**
  - who it was for,
  - which provider and model,
  - the tokens read and written,
  - the estimated cost at that model's price.

  The spend limits and the tracker are built on this record.
- **If the provider fails** (an expired key, an outage, a refusal), the window says so plainly and nothing is retried silently.
- **Changes are recorded as "via Polaris"**, the same marker the MCP uses today.

## My calls (awaiting Steve)

- Polaris isn't sent all 628 tools on every call; that would cost about a dollar a prompt before it had done anything.
  - It always has a small core: search, whoami, list companies, and the tools of the section you're on.
  - It also has a "find a tool" step to fetch any others it needs.
  - It can still reach everything your role allows.
- Provider prompt caching is used where it's offered, to keep repeated context cheap.

## Notes

- **On the chain:**
  - migration: `polaris_usage` (user, conversation, provider, model, input/output/cached tokens, cost, at);
  - API: a turn endpoint plus a stream (SSE), regenerate schema.d.ts.
- Tools:
  - call the existing `assistant/registry` tools in-process as the signed-in user, with the same per-user filtering as `/api/mcp`;
  - set the `via` marker;
  - keep the server instructions as the system prompt.
- One provider interface with two adapters (Anthropic Messages, OpenAI Responses). The tool-use loop runs in Compass, not in the provider.
- Where the turn runs is an ADR 0127 call. Leaning: a Celery task, streamed back through Valkey pub/sub, so a turn survives a page reload and stays out of the API's memory (the API sits at 1Gi, [[staging-overlay-pins-resources]]).
  - The task takes IDs and is idempotent per step (CLAUDE.md Celery rules).
- `from_the_cloud` and other outside text stay data. The existing tool wrapping already handles this; don't unwrap it.
- Add `uv` dependencies with an `exclude-newer`-safe approach, or use `httpx` directly ([[uv-tool-table-needs-cooldown]]).
