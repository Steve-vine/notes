---
id: 01KY72T4EYES2851SG04EVPEPW
created: 2026-07-23T08:52:26.206608Z
updated: 2026-07-23T09:18:07.787626Z
type: task
title: 'Settings: MCP section — binary path, client setup, version diagnostics'
priority: medium
assignee: steve
label: null
task_status: done
project: 01KY6W9951TW0904DT0GGJVGE7
number: 314
sprint: sf9yevt
---
## Context

The API has a settings section but MCP has nothing. An enable/disable toggle would be wrong by design — `notuvia-mcp` is a standalone stdio sidecar (ADR 0030) that MCP clients spawn themselves; the app doesn't own its lifecycle and there's no network surface. But setting a client up today means hunting for the bundled binary by hand, and a stale sidecar build against a newer index schema has already caused corruption-shaped confusion — nothing surfaces the mismatch.

## Change

A read-only **MCP** section in Settings, focused on discoverability and setup:

* **Server binary**: resolved path (next to the app executable / target dir in dev) with a copy button; version reported by running `notuvia-mcp --version`, compared against the app version with a "rebuild the sidecar" hint on mismatch; a clear "not found" state for dev builds.
* **Vault served**: the app-configured vault the sidecar defaults to (overridable per client with `--vault`), and a note that clients read/write it directly — the app needn't be running.
* **Connect a client**: copyable snippets — the `claude mcp add notuvia -- "<path>"` one-liner for Claude Code, and the `mcpServers` JSON block for Claude Desktop.

Backend: one `mcp_info` Tauri command returning path/exists/version. No lifecycle controls.

## Acceptance

* The section shows the real staged binary path and its version, flags an app↔sidecar version mismatch, and the snippets paste working config into Claude Code / Claude Desktop.

---

Linear DEV-967 · Settings Window · created 2026-07-12 · done 2026-07-12