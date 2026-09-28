---
id: 01M3MY1WCDYGA7Q1GYZRV99NNB
created: 2026-09-28T21:17:08.36598Z
updated: 2026-09-28T22:09:48.126362Z
type: task
title: App repo points users at the website docs
project: 01KY6W9951TW0904DT0GGJVGE7
number: 484
sprint: spqrtwg
blocked_by:
- 01M3MY1N5B636W6ARMKM3H3W9B
- 01M3MY20QBFVH9Q9QXFH9ZK5QN
comments:
- id: 01M3N12A2Y658GJ52D283XF71F
  author: Steve Vine
  at: 2026-09-28T22:09:48.126129Z
  text: |-
    Exact targets, from the docs work (NOT-482), for when this is picked up in an app session after go-live:
    - docs/mcp-server.md → notuvia.com/docs/mcp/. Keep only its "Notes for packagers" section, which is developer-only.
    - docs/api.md → notuvia.com/docs/http-api/
    - docs/packaging-macos.md, "Install on another Mac" → notuvia.com/docs/getting-started/#the-first-launch
    - README:
      - "Connecting AI agents (MCP)" → /docs/mcp/
      - "Driving Notuvia from other apps (HTTP API)" → /docs/http-api/
      - "Building the macOS app": point users to /download/ and /docs/getting-started/
    - src/lib/Settings.svelte:
      - MCP section → /docs/mcp/
      - API section → /docs/http-api/
      - About → View changelog offline fallback → /changelog/
    - src/lib/FeatureRequestPane.svelte: the disclosure line → /privacy/ (NOT-471)
    - mcp-server.md's check-in section mentions "the privacy policy on the Notuvia website"; link it to /privacy/.
    - Also in the app: package.json still says "license": "MIT". Steve chose an end-user licence (NOT-491).
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