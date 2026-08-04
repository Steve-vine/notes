---
id: 01KZ6THGHBKPFX9G682JCESS9R
created: 2026-08-04T16:43:36.875739Z
updated: 2026-08-04T19:27:27.323007Z
type: task
title: Assist can read repo files but cannot find them — register repo search on Assist, and let entity search match tags
project: 01KX671DATY39VW6GWK3M2T3DN
number: 540
sprint: skxht3g
assignee: steve
label:
- bug
priority: medium
task_status: todo
---
Live-found 2026-08-04: Steve asked Assist "What can you tell me about how Crossplane is used?" and it answered — honestly, given its tools — that no reference to Crossplane exists anywhere in the estate. In reality: the register holds a comprehended `devops.library.crossplane` repo, and every Crossplane-built VPC and EKS cluster carries `crossplane-kind` / `crossplane-name` / `crossplane-providerconfig` tags. The answer was sitting in two places Assist structurally could not look.

## Gap 1 — the repo tool pair is split across surfaces

`ASSIST_TOOLS` (`assist_tools.py:553`) includes `read_repo_file`, whose own comment says *"The comprehension shortlist rides via `search_repo_knowledge`"* — but **`search_repo_knowledge` is not registered on Assist**; it lives only in the issue-chat/loop toolset (`tools.py:593`), along with `search_commit_history`. Assist has the drill-down without the search: it can open a file it already knows the path of, and has no way to learn a path. Worse, the agent instructions reference the missing tool (`agents.py:404` — "Use `search_repo_knowledge` to find the file and `read_repo_file`…"), so the model is told to call a tool that isn't there.

Fix: add `search_repo_knowledge` and `search_commit_history` to `ASSIST_TOOLS` (both already zero-cost DB reads over the read-only session — no new capability, just the same wiring issue-chat has). Sanity-sweep the other direction while there: any tool a surface's instructions mention must be registered on that surface — a cheap test can assert instruction-mentioned tool names ⊆ registered tool names per agent.

## Gap 2 — `find_estate_entities` searches names only, so tag-borne facts are invisible

The Crossplane fingerprint on the estate is entirely in tags, and the entity search tool matches names. `GET /api/v1/entities` already supports a `tag` filter (ISE-482 — substring over `key:value` labels), so the fix is exposing what exists: give `find_estate_entities` an optional `tag` parameter (or match the query against tag labels as well as names, flagged per result so the model knows *why* something matched). Docstring guidance: when a name search returns nothing for a technology/product term, search tags before concluding absence — operational ownership (crossplane-*, argocd-*, karpenter-*) lives in tags, not names.

## Not in scope

- `search_documents` absent from the live deployment — already fixed (landed 16:26 with ISE-533/534 work); deploys with the next staging build.
- Adding retrieval tools to surfaces beyond Assist — issue-chat already has the full set.

## Acceptance (the failing conversation, replayed)

"What can you tell me about how Crossplane is used?" on Assist produces an answer citing the `devops.library.crossplane` repo's comprehension (via repo search) and identifying the Crossplane-managed VPCs/clusters (via tag match) — plus the wiki once `search_documents` is deployed. A test asserts Assist's registered tool names include the repo search pair, and the instruction-vs-registration sweep passes across agents.
