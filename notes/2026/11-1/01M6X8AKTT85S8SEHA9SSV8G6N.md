---
id: 01M6X8AKTT85S8SEHA9SSV8G6N
created: 2026-11-08T09:37:41.210912Z
updated: 2026-11-09T19:14:15.33037Z
type: task
title: Claude connects end to end — Claude Code with one line, and claude.ai / Desktop / mobile as a custom connector, both by browser sign-in on staging
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1648
sprint: sd11qqf
blocked_by:
- 01M6X88E62KPHJ59H18MA3QA1J
- 01M6X88R2BFTV0EW5KF88DYC5N
- 01M6X892N45JM4FRDST1NT6GZX
- 01M6X8A8SSX85SH6VVCSJ816DV
comments:
- id: 01M6XF748DRM65ZQP6JSAMRDB4
  author: Steve Vine
  at: 2026-11-08T11:38:06.98923Z
  text: |-
    Waiting on the staging tunnel (COM-1647); not started. Everything this task tests is on staging (9ae87353). But Claude, including Claude Code here, is told to sign in at compass-mcp.citops.net, and that address doesn't exist until the tunnel does.

    Once the tunnel exists I'll:
    1. Run the Connect page's line in Claude Code.
    2. Sign in as an E2E account and Allow.
    3. Run a read tool and a write tool, and check Activity shows "via Polaris".
    4. Move this machine's own Compass connection from its token to the browser sign-in, then revoke the token.

    For claude.ai, a custom connector with https://compass-mcp.citops.net/api/mcp may need your account. If so I'll mark it Couldn't check, with the exact clicks.
- id: 01M70NMGDEFASSRKMWB5N8PBPS
  author: Steve Vine
  at: 2026-11-09T17:28:00.173856Z
  text: |-
    Pre-UAT on staging (9ae87353), 2026-11-09, as E2E Admin A in E2E Test Company.

    **Passed: Claude Code end to end**, through the tunnel at compass-mcp.citops.net.
    1. Ran the Connect page's line exactly: `claude mcp add --transport http compass https://compass-mcp.citops.net/api/mcp`. Claude Code showed "Needs authentication" straight away.
    2. /mcp ▸ compass ▸ Authenticate. Claude Code registered itself and gave a sign-in link on compass.citops.net. The link went to Compass's login. After logging in, it landed on the "Connect Claude Code (compass)?" card, which names the person and says it returns to an app on this computer. Allow → "Authentication successful. Connected to compass", with **740 tools**.
    3. The config entry holds only the type and address, with no token. Claude Code keeps its sign-in in its own credential store.
    4. Restarted Claude Code (a fresh process): whoami answered "E2E Admin A … via Polaris", and list_companies and posture_list_gaps worked (read).
    5. Write: posture_update_gap set G-43's target date from 30 to 31 Dec 2026. Activity shows "updated gap G-43 · Target date 30 Dec 2026 → 31 Dec 2026", by e2e-admin-a, via Polaris.
    6. Disconnected it on the Connect page (with confirm). Claude Code went back to "Needs authentication" and refused the tool, telling me to sign in again.

    Notes:
    - My test browser isn't allowed to open localhost, so the final hop back to Claude Code was blocked there. I pasted the address into Claude Code's own "paste the URL" prompt. On a normal browser this happens by itself.
    - A comment written through the assistant (posture_add_gap_comment) doesn't appear in Activity. That isn't new: gap comments have never been recorded there, whoever writes them.
    - Activity lists the connection's creation as "via Polaris". That's deliberate: the assistant creates it when it collects its keys after Allow.

    **Couldn't check: claude.ai, Desktop and mobile.** These need your claude.ai account. Steps:
    1. claude.ai ▸ Settings ▸ Connectors ▸ Add custom connector. Name: Compass. URL: https://compass-mcp.citops.net/api/mcp. Leave the advanced OAuth fields empty. Click Add.
    2. Click Connect on it. A tab opens Compass's login (you need to be on the network or Twingate). Sign in as yourself, check the card says Claude, then click Allow. You land back on claude.ai, connected.
    3. In a new chat, enable Compass in the tools menu and ask "Using Compass, who am I and which companies can I see?" Look for the tool count in the connector's details: we expect 740. If claude.ai says there are too many tools, tell me, and don't cut any.
    4. Desktop and mobile should show the same connector without setting it up again.

    **Not done: switching this checkout's own Compass connection to browser sign-in.** The sign-in has to be you, so the steps are on the sprint report. Once you've done it I'll revoke the old "Compass" token, but only after you confirm, because scripts may use it too.

    Screenshots: ~/compass-uat/sd11qqf/COM-1648/
assignee: steve
label:
- feature
priority: medium
task_status: done
---
Prove the whole path with each Claude client and fix whatever is specific to it.

**Wanted behaviour:**
- **Claude Code:** paste the Connect page's line. The first use opens the browser, sign in, Allow, and the tools appear. No token appears in `~/.claude.json` or `.mcp.json`. It stays connected across restarts, and after a disconnect it asks to sign in again.
- **Claude (claude.ai):** Settings → Connectors → add custom connector with the address. The same sign-in, then the tools are usable in chat. Desktop and mobile pick up the same connector.
- Polaris's server instructions and tool list are the same as today in both.

**Done when:** on staging, in E2E Test Company, Claude Code connects by the copied line and runs a read tool and a write tool. Activity shows the write as done by the person via the assistant. claude.ai connects as a custom connector and runs a read tool. Pre-UAT may mark claude.ai **Couldn't check** if it needs Steve's account: say exactly what to click. This checkout's own Compass connection is moved from the token in `~/.claude.json` to browser sign-in, and the token revoked.

**Implementation:** use whatever the ADR (COM-1641) found about Claude's registration method and tool limits. If claude.ai trims or refuses a list of 600+ tools, raise it with Steve rather than cutting tools. Fixes found here land in COM-1642/1644 if they're still open, or as a PR on this task.

**Independent**, unless a fix needs an API change (it then joins the chain). After COM-1642, 1643, 1644 and 1647.