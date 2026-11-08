---
id: 01M6X8AKTT85S8SEHA9SSV8G6N
created: 2026-11-08T09:37:41.210912Z
updated: 2026-11-08T09:37:41.210912Z
type: task
title: Claude connects end to end — Claude Code with one line, and claude.ai / Desktop / mobile as a custom connector, both by browser sign-in on staging
label: feature
priority: medium
task_status: todo
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1648
---
Prove the whole path with each Claude client and fix whatever is specific to it.

**Wanted behaviour:**
- **Claude Code:** paste the Connect page's line. The first use opens the browser, sign in, Allow, and the tools appear. No token appears in `~/.claude.json` or `.mcp.json`. It stays connected across restarts, and after a disconnect it asks to sign in again.
- **Claude (claude.ai):** Settings → Connectors → add custom connector with the address. The same sign-in, then the tools are usable in chat. Desktop and mobile pick up the same connector.
- Polaris's server instructions and tool list are the same as today in both.

**Done when:** on staging, in E2E Test Company, Claude Code connects by the copied line and runs a read tool and a write tool. Activity shows the write as done by the person via the assistant. claude.ai connects as a custom connector and runs a read tool. Pre-UAT may mark claude.ai **Couldn't check** if it needs Steve's account: say exactly what to click. This checkout's own Compass connection is moved from the token in `~/.claude.json` to browser sign-in, and the token revoked.

**Implementation:** use whatever the ADR (COM-1641) found about Claude's registration method and tool limits. If claude.ai trims or refuses a list of 600+ tools, raise it with Steve rather than cutting tools. Fixes found here land in COM-1642/1644 if they're still open, or as a PR on this task.

**Independent**, unless a fix needs an API change (it then joins the chain). After COM-1642, 1643, 1644 and 1647.