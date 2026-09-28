---
id: 01M3MY1N5B636W6ARMKM3H3W9B
created: 2026-09-28T21:17:00.971516Z
updated: 2026-09-28T22:09:44.045402Z
type: task
title: 'Website: user documentation — getting started, MCP and HTTP API'
project: 01KY6W9951TW0904DT0GGJVGE7
number: 482
sprint: spqrtwg
blocked_by:
- 01M3MY0Y6T6DRHJ60MPGHKJZ5T
comments:
- id: 01M3N125156WJF28HV00YM2MYS
  author: Steve Vine
  at: 2026-09-28T22:09:42.949475Z
  text: |-
    Built and pushed to staging (1d47465, c9317a5).
    - Seventeen pages under /docs/:
      - an overview;
      - Getting started (the footer's link): install and the first launch, choosing the vault, capture with Option+Space, search, and where notes live on disk;
      - twelve "Using Notuvia" pages: Notes and Types, Finding notes, Taxonomies, Writing and editing, Projects and tasks, Schedules, Workspaces, Encrypted notes, Version history and trash, Git sync, Import and export, Updates;
      - Connecting AI agents (MCP), and HTTP API.
      The sidebar lists them in that order (astro.config.mjs).
    - The MCP and HTTP API guides moved from the app repo with every internal reference removed (no decision records, task ids, repo paths or private-repo links). They're also corrected where the old docs had gone stale:
      - delete moves notes to the trash by default;
      - taxonomy values change only the keys you send;
      - notes can be created as any of the five Types;
      - PATCH takes type and start;
      - the MCP server has a --no-self-update flag.
    - Every step and label is checked against the app's screens and code: Settings sections, first-run text, hotkeys, menus, rail views, the note ⋯ menu, the "/" insert list, default statuses, the Planner options, the 14 MCP tools, the API routes, and port 6688. Milestones are left out, because sprints replaced them. The first-launch step leads with the `xattr` command.
    - There is no pricing or Pro, and search (Pagefind) indexes every page. The grep for internal references across the docs comes back clean.
    - Open for Steve:
      - the Updates page calls the check-in a "check-in message" rather than "anonymous", because a request can link it to an email;
      - the headless example pins `--version 0.30.0`: keep it, or use a placeholder?
    To look at: /docs/, then Getting started, MCP and HTTP API at desktop and phone widths in both themes; try search.
assignee: steve
label:
- brief
priority: medium
task_status: review
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