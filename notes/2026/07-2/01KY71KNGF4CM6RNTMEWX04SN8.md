---
id: 01KY71KNGF4CM6RNTMEWX04SN8
created: 2026-07-23T08:31:25.711819Z
updated: 2026-07-23T08:31:25.711819Z
type: task
title: Bundle notuvia-mcp with the app and document MCP client setup
assignee: steve
task_status: done
imported_from: linear
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 229
---
Ship and document the MCP server:

* Bundle `notuvia-mcp` as a Tauri sidecar (`externalBin`) so it rides along in the app bundle on macOS now, and Windows/Linux installers later — no separate install step.
* Docs: how to register the server in Claude Desktop and Claude Code (stdio command config), including the per-platform binary path inside the app bundle and the `--vault` flag vs config-fallback behaviour.
* A `--version`/`--help` surface on the binary and a sanity check that a spawned server responds to `initialize` (smoke test in CI if feasible).

Context: DEV-868 / ADR 0030. Packaging follows ADR 0018 (macOS) conventions; Windows packaging is a future milestone but `externalBin` is the cross-platform mechanism.

---

Linear DEV-882 · MCP Server · created 2026-07-07 · done 2026-07-07