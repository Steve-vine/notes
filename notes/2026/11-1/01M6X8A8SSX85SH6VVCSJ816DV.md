---
id: 01M6X8A8SSX85SH6VVCSJ816DV
created: 2026-11-08T09:37:29.913175Z
updated: 2026-11-08T10:23:17.619113Z
type: task
title: The assistant's address is reachable from the internet on staging and production — only the assistant's door is public, Compass's screens stay internal
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1647
sprint: sd11qqf
assignee: steve
label:
- feature
priority: medium
task_status: active
---
Steve (2026-11-08): yes to internet reach. claude.ai, ChatGPT and (next sprint) Copilot connect from their own clouds. Today staging's address is on the home network (`compass.citops.net` → 192.168.1.5) and production is internal-only (Twingate), so none of them can reach either.

**Wanted behaviour:**
- Each environment gets a public address for its assistant, only for that. Proposed: `compass-mcp.citops.net` (staging) and `compass-mcp.moneypenny.uk` (production); Steve to confirm or rename.
- The public address answers only the MCP address and the sign-in plumbing an assistant's cloud calls: discovery, registration, token, revoke. Everything else, including Compass's screens, its login and the Allow screen, returns not found there.
- People keep using Compass on its internal address. They sign in to connect an assistant there, so they need to be on the network (as today) when they connect, but not afterwards.
- Registration and token calls are rate-limited on the public address.

**Done when:** from outside the network (a phone off Wi-Fi, or a cloud runner), the staging public address answers the MCP's 401 with its sign-in pointer, and `/`, `/api/v1/...` and the login return not found. The same is checked on production once the release carrying this sprint is there. Claude Code connects through the public address.

**Implementation:**
- Same pattern as the Vendor Portal's production tunnel: a Cloudflare Tunnel route to the frontend nginx, with a host block (or a dedicated small server block) that proxies only the allowed paths to the API and 404s the rest. Mirror how the vendor-portal host is refused `/api/`, and extend `scripts/ci/check-portal-host-boundary.sh`, or add a sibling check, to pin the allowed path set.
- The chart: an optional `assistantPublicHost` value. It drives the ingress/nginx block and is the issuer and resource address the API advertises (COM-1642 and the Connect page read it).
- **Steve's hands:** the Cloudflare tunnel routes and DNS for both hostnames (the tunnel Steve runs); a commit to `devops.application.compass` (`envs/prod-uk-compass-app.yaml` + env ingress) for production. I prepare both changes and ask before committing there.
- Check that `citops.net` is on Cloudflare for staging. If it isn't, the fallback is a tunnel on another zone Steve picks.

**Independent:** chart, nginx and infra. No migration, no API change.