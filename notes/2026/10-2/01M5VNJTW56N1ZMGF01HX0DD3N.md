---
id: 01M5VNJTW56N1ZMGF01HX0DD3N
created: 2026-10-26T08:35:11.365987Z
updated: 2026-10-26T09:14:49.916327Z
type: task
title: 'Polaris answers: the engine that talks to the chosen model, uses Compass''s tools as the person, streams its reply, and records what each reply cost'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1329
sprint: s9ls6e7
blocked_by:
- 01M5VNJEZ1AC8X5ZDB2T2G9A51
assignee: steve
label:
- feature
priority: high
task_status: active
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
