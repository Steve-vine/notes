---
id: 01KY71P24PVW7FAY5Z0WR7QF7K
created: 2026-07-23T08:32:44.18229Z
updated: 2026-07-23T11:04:51.547759Z
type: task
title: In-app MCP registration — one-click "Connect AI assistants" for Claude Desktop, Claude Code, and VS Code/Copilot
imported_from: linear
task_status: done
assignee: steve
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 235
comments:
- id: 01KY71PE9TN5P8RJBAKVX82KSF
  author: Steve Vine
  at: 2026-07-23T08:32:56.633677Z
  text: |-
    Steve Vine · 2026-07-12:

    **Plan (agreed scope for this brief):**

    **Backend — new `src-tauri/src/mcp_clients.rs`** (desktop glue, not core). Four client targets, each defined by a config file path and a schema:
    - **Claude Desktop** — `<config base>/Claude/claude_desktop_config.json`, entry under `mcpServers.notuvia` (macOS + Windows only; the row never appears on Linux).
    - **Claude Code** — `~/.claude.json` (user scope), same `mcpServers.notuvia` shape — written directly, no CLI shell-out.
    - **VS Code** and **VS Code Insiders** — `<config base>/Code[ - Insiders]/User/mcp.json`, root key `servers` (not `mcpServers`), entry `{"type": "stdio", "command": …}`.

    `<config base>` comes from Tauri's `path().config_dir()` — `~/Library/Application Support` / `%APPDATA%` / `~/.config` — so the paths are right on all three platforms without a new dependency.

    **Merge semantics (it's another app's file):** parse the whole file as `serde_json::Value`; a file that exists but doesn't parse is an *error, not a clobber* ("couldn't read X — fix or register manually"). Mutate only `mcpServers.notuvia` / `servers.notuvia`, preserving every unknown key; write pretty-printed. Registration writes `{"command": "<resolved sidecar path>"}` with **no `--vault` pinning** — the sidecar already follows the app's configured vault, so registration survives vault switches. The merge/remove/inspect logic is pure (JSON in → JSON out) and unit-tested.

    **Commands:** `mcp_clients()` → per detected client: id, label, config path, registered?, the command it currently points at, and whether that matches the resolved sidecar; `register_mcp_client(id)` / `unregister_mcp_client(id)` → write and return the fresh status. Detection = the client's config dir exists (covers "not installed"); the sidecar path reuses `mcp_info`'s next-to-the-executable resolution.

    **Clobber guard:** an existing `notuvia` entry pointing elsewhere shows as "Registered → old/path" with the button reading **Update** — overwriting is a deliberate, labelled act, never silent.

    **Frontend — Settings › MCP:** a new "Connect AI assistants" group above the existing manual snippets: one row per detected client with its status (Not registered / Registered → path / Registered, stale path) and Register / Update / Remove buttons; Register disabled with a hint while the sidecar binary is missing (dev checkouts). Claude Desktop's row notes "picked up on next launch". The DEV-967 copy-paste snippets stay beneath as "Manual setup".

    **Docs:** `docs/mcp-server.md` gains the in-app path as the primary route and a VS Code section; manual instructions stay as fallback.

    **Out of scope / follow-up:** the optional first-run prompt — a separate surface; filed parent-linked so this brief stays one reviewable PR. Non-goals per the issue: Connectors/OAuth, `.mcpb` bundles, ChatGPT.
- id: 01KY71PR2EFFZ8CJWMZEDVCMFV
  author: Steve Vine
  at: 2026-07-23T08:33:06.637643Z
  text: |-
    Steve Vine · 2026-07-12:

    **Done — in review.** PR: https://github.com/Steve-vine/notuvia/pull/304

    **What was done:** the plan as posted — `mcp_register.rs` (pure, 9-test JSON merge/remove/inspect logic + client path table), three Tauri commands (`mcp_clients`, `register_mcp_client`, `unregister_mcp_client`), the Settings "Connect AI assistants" group with per-client status and Register/Update/Remove, the DEV-967 snippets kept as "Manual setup", and docs/mcp-server.md leading with the in-app route plus a VS Code section.

    **Decisions made on the fly:**
    - **Claude Code detection** probes `~/.claude` *or* `~/.claude.json` — the dir marks an install even before user-scope config exists.
    - **Remove leaves the emptied `mcpServers`/`servers` table in place** — deleting keys the user's other tools might rely on isn't ours to do.
    - Registration **rewrites our entry canonically** — a stale hand-added `args: ["--vault", …]` on the `notuvia` entry is replaced along with the path (the entry is ours; everything outside it is untouched).
    - Formatting: the file is re-pretty-printed on write (structure and values preserved exactly); noted since it's another app's file.

    **Problems encountered:** none. All checks clean (9 new Rust tests; `cargo test`/`fmt`/`clippy -D warnings`, `npm run check`/`test` 190/`build`).

    **Caveat for review:** the merge logic is unit-tested but I haven't exercised it against real Claude Desktop / VS Code configs on this machine — worth one manual pass (register, restart client, see the tools appear; remove, confirm the entry is gone and the rest of the file intact) before release.

    **Follow-up filed:** DEV-971 — the optional first-run "connect AI assistants" prompt.
sprint: sgm3rgt
---
Today, connecting an MCP client to the vault means a terminal command or hand-editing JSON (docs/mcp-server.md, DEV-882). Fine for a developer machine; wrong for an installed-from-dmg experience. Add a "Connect AI assistants" section to app settings (plus an optional first-run prompt) that registers the bundled `notuvia-mcp` sidecar with one click.

Scope:

* **Claude Desktop:** additively merge a `notuvia` entry into `claude_desktop_config.json` — `~/Library/Application Support/Claude/` on macOS, `%APPDATA%\Claude\` on Windows. Merge carefully (it's another app's config file): preserve unknown keys, don't clobber an existing `notuvia` entry without saying so. Picked up on Desktop's next launch.
* **Claude Code:** write the equivalent entry to `~/.claude.json` (user scope) directly rather than shelling out to the CLI — avoids PATH detection and the Windows `claude.cmd` shim wrinkle entirely.
* **VS Code / GitHub Copilot:** Copilot's agent mode runs local stdio MCP servers like Claude does. Register via the user-level `mcp.json` in the VS Code profile — note the schema differences: root key is `servers` (not `mcpServers`) and MCP tools only apply in agent mode. VS Code also offers `code --add-mcp '{…}'`, but writing the file directly keeps all three clients on the same no-shell-out mechanism. Applies to VS Code stable (and Insiders, separate profile dir) on all three platforms.
* **Sidecar path resolution:** resolve at runtime relative to the app executable, not hard-coded — `Notuvia.app/Contents/MacOS/notuvia-mcp` on macOS, next to `Notuvia.exe` on Windows (Tauri `externalBin` placement). Registering the installed path (not a dev-checkout path) makes registration survive app updates.
* **Platform gating:** the mechanism is cross-platform; only paths differ (the `app_config_dir()` idiom already in notuvia-mcp's [main.rs](<http://main.rs>)). Gate the Claude Desktop option on Linux (no official build); for each client, show its row only if its config directory exists — that covers "VS Code not installed" too.
* **Status surface:** show whether each client is currently registered and where it points, with a "remove" action for symmetry.

Non-goals: the Connectors directory model (remote HTTP + OAuth — doesn't fit a local-first app; revisit with Online Version), `.mcpb` MCP Bundles (Claude Desktop one-click packaging — a possible later addition, but this issue covers all three clients without a new artefact to distribute), and ChatGPT (remote-only MCP: OpenAI's backend makes the connection, so a local binary is unreachable without a hosted endpoint or tunnel — Online Version territory).

---

Linear DEV-888 · Application Deployment & Update · created 2026-07-07 · done 2026-07-12