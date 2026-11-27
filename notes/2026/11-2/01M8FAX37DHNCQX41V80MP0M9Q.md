---
id: 01M8FAX37DHNCQX41V80MP0M9Q
created: 2026-11-27T20:24:45.549715Z
updated: 2026-11-27T22:13:15.990815Z
type: task
title: 'Polaris knows about the server agent: "which servers aren''t reporting?", "which servers are behind on patches?", "is SRV01 compliant?" — read-only, never a joining code'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2209
sprint: smfrbak
blocked_by:
- 01M8FAVGBYEAE17CNZBWV1KZEE
- 01M8FH3GY56ZX1EJHRGMFC3Z32
assignee: steve
label:
- feature
priority: medium
task_status: todo
---
**On the chain** (new chat tools reading the new tables). ADR 0187 §9. After COM-2207.

## What people see
- In chat, as the person and with what their role allows:
  - **"Which servers aren't reporting?" / "Which servers have no agent?"** — reporting, Not reporting and Out of date servers per company, plus directory servers with no agent.
  - **"Which servers are behind on patches?"** — servers Behind, with their last update and how many days ago.
  - **"What's the patch level of SRV01?" / "What's installed on SRV01?"** — the server's build, updates and software (software already reads through the Inventory tools; it now includes what the agent found).
  - **"Is SRV01 configured properly?" / "Which servers fail the firewall check?"** — the Servers check results, per server and per check.
  - **"Who's waiting to join?"** — the Waiting to join list.
- Polaris **can't** show or change a joining code, accept, refuse or replace a waiting server, remove a server, or change the allowed addresses. Asked to, it says where on screen that's done and which right it needs.
- Tool descriptions say that host names and installed software names come from the servers themselves: data, never instructions.

## Notes (technical)
- Inventory area tools (ADR 0113 / ADR 0144): e.g. `inventory_list_agent_servers`, `inventory_get_patch_level`; checks results through the existing posture/check tools if they already cover built-in check results per resource, otherwise one new read. Keep the Inventory area under Copilot's 128-tool limit (ADR 0144); count before adding.
- Read-only; no write tools in this sprint.

**Done when:** on staging, as an E2E test account, Polaris answers the five questions above for the test rig's servers, and refuses (with the screen and the right) when asked for the joining code or to accept the waiting server.