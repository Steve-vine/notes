---
id: 01M3MY1WCDYGA7Q1GYZRV99NNB
created: 2026-09-28T21:17:08.36598Z
updated: 2026-09-28T21:26:15.902507Z
type: task
title: App repo points users at the website docs
project: 01KY6W9951TW0904DT0GGJVGE7
number: 484
sprint: spqrtwg
blocked_by:
- 01M3MY1N5B636W6ARMKM3H3W9B
- 01M3MY20QBFVH9Q9QXFH9ZK5QN
assignee: steve
label:
- chore
priority: low
task_status: backlog
tech:
- docs
---
Work in the **app** repo, once the user docs are live on `notuvia.com` (website ADR 0003).

## Scope

- [ ] Replace `docs/mcp-server.md` and `docs/api.md` with short pointers to `notuvia.com/docs/…`, or cut them down to developer-only notes.
- [ ] Update the README's MCP and HTTP API sections to link to the site.
- [ ] Point in-app links at the site: docs, the privacy policy (the feature-request pane, NOT-471), and the changelog fallback (NOT-477).
- [ ] Add a line to the Definition of Done (app ADR 0007 / `brief/ways-of-working.md`): a change to behaviour users can see includes updating the website.

**Done when:** no user-facing link in the app or README points at a doc in the private repo.