---
id: 01M6X892N45JM4FRDST1NT6GZX
created: 2026-11-08T09:36:50.852693Z
updated: 2026-11-08T11:08:35.461167Z
type: task
title: 'Connect an assistant page: one line or one address per assistant, no token to create, and your connected assistants with Disconnect'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1644
sprint: sd11qqf
blocked_by:
- 01M6X88E62KPHJ59H18MA3QA1J
comments:
- id: 01M6XDH1GFTJXHXN2S618NPTZ7
  author: Steve Vine
  at: 2026-11-08T11:08:34.703828Z
  text: |-
    Done: PR #1659, merged to main.

    What changed: the Connect Polaris page no longer creates a token or asks you to paste one. It shows Compass's assistant address, each with a copy button:
    - **Claude Code:** one line to run (`claude mcp add --transport http compass <address>`), then /mcp ▸ Authenticate.
    - **Claude** (claude.ai, Desktop, mobile): add a custom connector with the address. All three share one connector.
    - **ChatGPT:** add a custom MCP server with the address. A workspace admin may first need to allow custom connectors.

    Each section says what happens next: your browser opens, sign in, click Allow. "Your connected assistants" lists each one's name, when it was connected and when it was last used, with Disconnect (it asks first, then ends it at once). The address shown is the public one (compass-mcp.citops.net on staging), even though you open the page on the internal address. Desktop no longer needs the local bridge.

    Tested: the three setups with nothing secret in them, the list, disconnect asking first, the empty state, and the page without the grant.

    Still to check: the exact menu wording in claude.ai and ChatGPT, in COM-1648 and COM-1649 on staging.
assignee: steve
label:
- feature
priority: medium
task_status: review
---
Today the page has you create a personal token and paste it, with the token, into a config snippet. It becomes "add Compass by its address and sign in".

**Wanted behaviour:**
- One section per assistant, each with the address filled in and a copy button:
  - **Claude Code:** one line to paste, with no token in it.
  - **Claude (claude.ai, Desktop, mobile):** add a custom connector with this address.
  - **ChatGPT:** add a connector with this address, noting that a workspace admin may first need to allow custom connectors.
  - Microsoft Copilot is not shown until "MCP Expansion - Copilot".
- Each section says what happens next: your browser opens, sign in to Compass, click Allow.
- **Your connected assistants:** each one's name, when it was connected and when it was last used, with Disconnect. Disconnecting asks to confirm, then ends it at once.
- Creating a personal token is no longer offered here. While the switch-over is open, anyone who still has a token in use is told it will stop working for assistants and asked to reconnect with the steps above. The switch-over task supplies the wording and the "still in use" flag.
- The page still shows only to people with *Connect an AI assistant*.

**Done when:** in E2E Test Company, the page shows the three assistants with the right public address. Connecting a local Claude Code with the copied line lists it under your connected assistants with a last-used time, and Disconnect removes it, refusing its next call.

**Implementation:** rewrite `app/frontend/src/assistant/setup.ts`. Drop the token placeholder, the `--header` and the Desktop `mcp-remote` bridge, which Desktop's own connectors replace now the address is public. Rework `AssistantPage` and its tests. The address shown is the public assistant address from the internet-reach task, served by the API as config rather than worked out from the browser's origin, because people open this page on the internal address. Check the claude.ai and ChatGPT wording against the ADR findings.

**On the chain** only if serving the public address needs a new config field on the API. Otherwise independent, after COM-1642.