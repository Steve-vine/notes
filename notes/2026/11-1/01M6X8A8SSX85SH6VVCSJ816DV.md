---
id: 01M6X8A8SSX85SH6VVCSJ816DV
created: 2026-11-08T09:37:29.913175Z
updated: 2026-11-08T11:33:08.44872Z
type: task
title: The assistant's address is reachable from the internet on staging and production — only the assistant's door is public, Compass's screens stay internal
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1647
sprint: sd11qqf
comments:
- id: 01M6XC2G69ACYMF4DTWGG9X11A
  author: Steve Vine
  at: 2026-11-08T10:43:09.641672Z
  text: |-
    Built: PR #1658, merged to main.

    What changed: each environment can now have a public address that answers only the assistant's door: the MCP address, and the discovery, registration, token and revoke steps. Everything else on that address is "not found", including the screens, the login, the Allow screen and /api/v1. The vendor-portal and trust-centre addresses refuse all of the new paths. Staging is set to compass-mcp.citops.net, with its own ingress and certificate. A host check (97 expectations across all four addresses) passes locally.

    **Couldn't check:** reaching staging from outside. It needs a Cloudflare Tunnel, and nothing on staging is public today: every staging record points at 192.168.1.5, and g5 runs no tunnel.

    **Steve, staging:**
    1. Cloudflare Zero Trust → Networks → Tunnels → Create a tunnel (Cloudflared), named g5-compass-staging.
    2. On g5, run the install command the dashboard shows: `sudo cloudflared service install <token>`.
    3. Add a public hostname compass-mcp.citops.net → HTTPS localhost:443. Set TLS Origin Server Name and HTTP Host Header both to compass-mcp.citops.net. Cloudflare makes the DNS record itself; don't add an A record.
    4. From outside (a phone off Wi-Fi): `curl -i https://compass-mcp.citops.net/api/mcp` should give 401, and `/` should give 404.

    Until the tunnel exists, signing an assistant in on staging won't work even from the LAN, because Compass now tells assistants to use the public address.

    **Production (when you release this sprint):** I've prepared two small changes to devops.application.compass: assistantPublicUrl in the app values, and a compass-assistant ingress entry modelled on the vendor portal's. You'd also add compass-mcp.moneypenny.uk to the existing tunnel. I'll ask before committing anything there.
- id: 01M6XEY0Q0ZGN3HGW5FPR35BDJ
  author: Steve Vine
  at: 2026-11-08T11:33:08.448512Z
  text: |-
    On staging since 11:20 GMT (9ae87353). Checked from inside the network:
    - **Main address:** the MCP refuses with the sign-in pointer, and discovery names compass-mcp.citops.net as the issuer, with sign-in on compass.citops.net.
    - **compass-mcp.citops.net** (reached at 192.168.1.5 over HTTP): /api/mcp gives 401 with the pointer and discovery gives 200. /, /api/v1, the login and authorize all give 404.

    **Change to the tunnel step: use HTTP, not HTTPS.** The certificate for compass-mcp.citops.net hasn't been issued. cert-manager says it has published its DNS challenge, but Cloudflare's nameservers don't show the record. One retry didn't help, and I didn't look into the Cloudflare token itself. A Cloudflare tunnel doesn't need that certificate: Cloudflare provides the public HTTPS. So in step 3:
    - **Service:** HTTP localhost:80
    - **HTTP Host Header:** compass-mcp.citops.net
    - No Origin Server Name

    That works today. The pending certificate does no harm. If you want it fixed anyway, check whether the cert-manager Cloudflare token can still edit DNS in citops.net.
assignee: steve
label:
- feature
priority: medium
task_status: review
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