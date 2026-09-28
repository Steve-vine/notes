---
id: 01M3MY1N5B636W6ARMKM3H3W9B
created: 2026-09-28T21:17:00.971516Z
updated: 2026-09-28T21:26:09.698176Z
type: task
title: 'Website: user documentation — getting started, MCP and HTTP API'
project: 01KY6W9951TW0904DT0GGJVGE7
number: 482
sprint: spqrtwg
blocked_by:
- 01M3MY0Y6T6DRHJ60MPGHKJZ5T
assignee: steve
label:
- brief
priority: medium
task_status: backlog
tech:
- docs
---
The site becomes the canonical home of the user docs (website ADR 0003). They are served under `/docs/` by Starlight and themed by the site shell task.

## Scope

- [ ] Sidebar: Getting started, Using Notuvia, Connecting AI agents (MCP), HTTP API. Declare it in `astro.config.mjs`; a new page joins the sidebar in the same change.
- [ ] Getting started (the footer's "Getting Started" link): install, first run and choosing the vault folder, the capture hotkey and window, search.
- [ ] Using Notuvia: the ideas a user meets (Types, taxonomies, projects and tasks, git sync, encryption). Draw on the app's `brief/` and `README.md`; don't copy them.
- [ ] Move the app's `docs/mcp-server.md` and `docs/api.md` here. Remove ADR numbers, task ids, repo paths, and anything else only a developer of the app needs.
- [ ] Every page has `title` and `description` frontmatter. Check each claim against the current app.
- [ ] If the pricing decision puts MCP, the API or sync behind Pro, the docs say so.

**Done when:** the docs render with working search, and `grep` for `ADR`, `NOT-`, `DEV-` and `src-tauri` across the docs comes back clean.