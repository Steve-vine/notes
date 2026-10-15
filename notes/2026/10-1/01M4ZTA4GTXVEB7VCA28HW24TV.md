---
id: 01M4ZTA4GTXVEB7VCA28HW24TV
created: 2026-10-15T12:59:05.11405Z
updated: 2026-10-15T16:29:10.980816Z
type: task
title: A role can be granted "Connect an AI assistant" — that person gets a page to connect one, and the assistant knows who they are and which companies they can see
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 975
sprint: sadf3j6
blocked_by:
- 01M4ZT9F0SREYB9XD9W4P814C6
comments:
- id: 01M506ASA4EMKARSM6775Y99EK
  author: Steve Vine
  at: 2026-10-15T16:29:09.316408Z
  text: |-
    Done 2026-10-15. PR #967, squash dbbddc12, on main.

    What Steve can check on staging:
    - Roles screen: a new group, "AI assistant", with the grant "Connect an AI assistant". Admin holds it (migration 0260); nobody else does until ticked.
    - Your menu (initials) ▸ Connect an assistant, shown only with the grant:
      - setup to copy for Claude Code and Claude Desktop;
      - your tokens.
      - Creating a token shows the setup with the new token already filled in.
    - Activity: a change made through the assistant shows "via assistant" under the person's name.
    - The assistant connects at https://<compass>/api/mcp. Three tools so far: whoami, list_companies and search.

    Smoke test:
    1. Create a token on the page.
    2. Run the Claude Code command it shows.
    3. Ask Claude "who am I in Compass, and which companies can I see?"
    4. A role without the grant is refused, and the message names the grant.

    Built:
    - MCP Python SDK v2, stateless JSON at /api/mcp. The existing /api/ proxy already passes it through, so no chart change was needed.
    - The door accepts a bearer token only; a browser session cookie does not count.
    - Tools call /api/v1 in-process with the person's own token.
    - Each person sees only the tools their role allows.
    - The "via assistant" marker comes from a context variable set only on that in-process path. A forged header on a plain API call is ignored, and a test proves it.

    Tested:
    - 11 integration tests, including the official MCP client connecting, listing tools and calling one, in both the new (2026-07-28) and the classic handshake.
    - Frontend tests for the page, the menu item and the Activity label.
    - CI green.

    Left for the area tasks: the "via assistant" marker on each item's own history panel (assessment revisions, risk revisions, and so on), as ADR 0109 §4 says.
assignee: steve
label:
- feature
priority: high
task_status: review
---
Sprint 70, Content - Build MCP (ADR in COM-974). This is the foundation: every area task after it adds tools to what this one builds.

## What people see

- **Roles screen.** A new grant, **Connect an AI assistant**, appears in its own group. Admin holds it. Nobody else does until an administrator ticks it.
- **Your menu (your initials) ▸ Connect an assistant.** This shows only if you hold the grant. It is a page where you:
  - create a personal token (shown once, as today), name it, and see and revoke your existing tokens;
  - copy the setup for **Claude Code** (a one-line `claude mcp add` command) and for **Claude Desktop** (a JSON snippet), with Compass's address and your new token already filled in;
  - read one line on what the assistant can do: *what you can do on screen in Overview, Playbook and Posture — nothing more*.
- **Once it's connected, the assistant can already:**
  - say who you are, your role and what you're allowed to do;
  - list the companies you can see;
  - search Compass the way the ⌘K search does, within Overview, Playbook and Posture.
- **No grant, no connection.** A token whose owner lacks the grant (or whose grant has been removed) is refused, with a message naming the grant. Their token keeps working for the ordinary API as it does today.
- **Activity.** Anything done through the assistant shows the person's name with **via assistant** beside it. Nothing is changed this task, but the marker and its display land here so every later task inherits them.

## Notes (technical)

- Add the `mcp` SDK (streamable HTTP, stateless) and mount it on the FastAPI app (proposed at `/mcp`). Check the Helm ingress routes that path to the backend, and that nginx/ingress does not buffer the streamed responses.
- Bearer auth reuses `core/auth.py`'s token path. Add a new `Permission` (e.g. `assistant.connect`), seeded and placed in a catalogue group. Update `brief/permission-catalogue.md`. Admin gets it via "holds everything".
- **The in-process API client:** `httpx.AsyncClient(transport=ASGITransport(app))` carrying the caller's token and a request-state flag that marks the call as via assistant. One helper turns API errors (403/404/422) into tool errors the assistant can read.
- **Tool registry:** each tool declares the permission(s) it needs, and `list_tools` filters on the caller's effective permissions. Annotations: `readOnlyHint` on reads, `destructiveHint` on removals.
- **Migration:** a `via` (or `channel`) column on `activity_log`, and on any revision tables the later tasks write. Default `ui`, null-safe for old rows. Show it on the Activity screen.
- **The user-menu page and tokens:** tokens are self-service already (ADR 0007) but today live on the Admin page. The new page reuses `TokensSection`'s logic. The Admin copy stays as it is (Admin is out of scope).
- Tools here: `whoami`, `list_companies`, `search`.
- **Tests:** a token without the grant is refused; the tool list differs for a playbook-only role; a change made in-process is logged with `via=assistant`; a plain REST call with a forged header is not.
- A route docstring is part of the OpenAPI contract: run the schema drift script on any `api/v1` change, because the PR suite does not.

**Done when:** Steve, holding the grant, creates a token on the new page, pastes the Claude Code command, and the assistant answers "who am I and which companies can I see?" on staging. A role without the grant is refused.