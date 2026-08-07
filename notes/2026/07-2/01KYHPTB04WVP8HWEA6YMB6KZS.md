---
id: 01KYHPTB04WVP8HWEA6YMB6KZS
created: 2026-07-27T11:54:28.740008Z
updated: 2026-08-07T10:56:15.514527Z
type: task
title: 'MCP server foundation: HTTP endpoint, per-user tokens, RBAC, resource discovery'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 330
sprint: sax9eff
assignee: steve
priority: high
task_status: done
---
The load-bearing slice: a streamable-HTTP MCP server mounted on the backend (python `mcp` SDK, own path e.g. `/mcp`), reachable by Claude Code via `claude mcp add --transport http`.

- **Per-user MCP tokens**: new table (migration — next free number, check chain; stacking rule applies with Code Repos branches still in flight). Reveal-once plaintext on create, mirroring the dashboard board-token pattern. Scoped to the user; revocable.
- **UI (pane-of-glass DoD)**: Settings → Access section to create/revoke your MCP token, showing the exact `claude mcp add … --header "Authorization: Bearer …"` one-liner.
- **Identity + RBAC on every call**: token → user → role; enforcement server-side in the tool implementations (never prompt-level). Tool list is **filtered per role** at list time — a viewer's session doesn't even contain write tools (the "Neil can look but not touch" requirement).
- **Resource awareness** (Steve must-have): server instructions + a `describe_resources` tool advertising what THIS user on THIS install can reach — Signals, Incidents, Estate graph, Repos, Kubernetes clusters, Playbooks, Confluence documents, Events, Tags — filtered by connected integrations and role, so Claude knows its map without guessing.
- Structured logging for every MCP call (user, tool, duration); respects the redaction list.

Vertical DoD: Steve can mint a token in Settings, add the server to Claude Code, and ask "what can you see?" — getting a truthful, role-filtered resource map.