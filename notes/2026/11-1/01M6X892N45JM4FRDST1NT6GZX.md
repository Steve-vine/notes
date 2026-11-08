---
id: 01M6X892N45JM4FRDST1NT6GZX
created: 2026-11-08T09:36:50.852693Z
updated: 2026-11-08T09:38:14.092397Z
type: task
title: 'Connect an assistant page: one line or one address per assistant, no token to create, and your connected assistants with Disconnect'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1644
sprint: sd11qqf
blocked_by:
- 01M6X88E62KPHJ59H18MA3QA1J
assignee: steve
label:
- feature
priority: medium
task_status: todo
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