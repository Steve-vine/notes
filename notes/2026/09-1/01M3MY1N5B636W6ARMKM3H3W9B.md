---
id: 01M3MY1N5B636W6ARMKM3H3W9B
created: 2026-09-28T21:17:00.971516Z
updated: 2026-09-28T21:17:23.45519Z
type: task
title: 'Website: user documentation — getting started, MCP and HTTP API'
project: 01KY6W9951TW0904DT0GGJVGE7
number: 482
blocked_by:
- 01M3MY0Y6T6DRHJ60MPGHKJZ5T
assignee: steve
label: brief
priority: medium
task_status: backlog
tech: docs
---
The site becomes the canonical home of the user docs (website ADR 0003).

## Scope

- [ ] Sidebar structure: Getting started, Using Notuvia, Connecting AI agents (MCP), HTTP API. Use `autogenerate` per directory, as ise-website does.
- [ ] Getting started: install, the capture hotkey and window, search, and where the notes live on disk.
- [ ] Using Notuvia: the core ideas as a user meets them (Types, taxonomies, projects and tasks, git sync). Draw on the app's `brief/` and `README.md`; don't copy them.
- [ ] Move the app's `docs/mcp-server.md` and `docs/api.md` here. Remove the ADR numbers, task ids, repo paths and anything else only a developer of the app would need.
- [ ] Check every claim against the current app (feature and platform).

The app-side half (pointing the app repo and README at these pages) is a separate task.

**Done when:** the docs render in the preview with working search, and no page contains an internal reference (`grep` for `ADR`, `NOT-`, `DEV-` and `src-tauri` comes back clean).