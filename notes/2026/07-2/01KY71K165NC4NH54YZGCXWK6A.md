---
id: 01KY71K165NC4NH54YZGCXWK6A
created: 2026-07-23T08:31:04.901115Z
updated: 2026-07-23T08:33:20.46332Z
type: task
title: 'notuvia-mcp: stdio MCP server with read tools (search_notes, get_note, list_taxonomies)'
imported_from: linear
assignee: steve
task_status: done
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 227
label: null
---
New headless `notuvia-mcp` binary (workspace member) built on the official `rmcp` SDK (v2.x), stdio transport. MCP clients (Claude Desktop, Claude Code) spawn it directly; it works whether or not the app is running.

Scope — read tools only:

* `search_notes(query)` — delegates to the core's `search_summaries()`: FTS5 + nucleo fuzzy ranking, inline `key:value` filters, snippets with match ranges. Encrypted notes appear with title/metadata and an empty snippet.
* `get_note(id)` — full note: frontmatter (type, taxonomies, dates, relationships) + body. Encrypted bodies are withheld (return metadata plus an `encrypted: true` marker) — keys live only in the running app's session (ADR 0028); the MCP server never handles passwords.
* `list_taxonomies` — the registry from `taxonomies.yaml`, so agents can use the vault's vocabulary and valid values.

Vault resolution: `--vault <path>` flag, falling back to the app's `config.json` (`vault_path`).

Index access: open `vault/.notuvia/index.sqlite` read-only (WAL allows coexistence with the app's writer). If the index is missing or its schema version is stale, rebuild it from files — the index is disposable (ADR 0003).

Context: DEV-868 / ADR 0030.

---

Linear DEV-880 · MCP Server · created 2026-07-07 · done 2026-07-07