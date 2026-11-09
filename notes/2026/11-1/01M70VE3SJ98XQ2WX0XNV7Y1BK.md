---
id: 01M70VE3SJ98XQ2WX0XNV7Y1BK
created: 2026-11-09T19:09:22.098603Z
updated: 2026-11-09T19:09:58.130058Z
type: task
title: 'ADR: Copilot connects one area at a time — how Microsoft 365 Copilot reaches Compass today, and why each area gets its own address'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1650
sprint: sr3v2fq
assignee: steve
label:
- feature
priority: medium
task_status: todo
---
Steve (2026-11-09): one Copilot agent per Compass area, not one agent with a hand-picked set of tools. Moneypenny has Microsoft 365 Copilot licences.

**Wanted:** a short ADR (0144) that records how Microsoft 365 Copilot connects to an MCP server today and what that means for Compass. It is checked against Microsoft's current documentation, not memory, because Microsoft's offering has been moving. It answers:
- **Which Copilot:** an agent built in Copilot Studio and published to Teams and Microsoft 365 Copilot, or a declarative agent. Which one the Moneypenny licences cover without extra cost.
- **The tool limit:** whether the reported 128-tool cap per agent is real, and whether it counts per MCP server or per agent.
- **How it identifies itself:** dynamic registration ("dynamic discovery") versus a client ID and secret entered by hand. Its return address. Whether it sends `resource`.
- **What a Microsoft 365 / Power Platform admin must allow:** custom connectors, data-loss-prevention policy, publishing an agent to staff.
- **The decision:** each Compass area (Access Control, Vendors, Inventory, Data Subject Requests, and so on) gets its own MCP address with only that area's tools, plus who-am-I, search and the company list. The full address stays for Claude and ChatGPT. Same sign-in, same role rules, same Activity trail. Today's counts all fit: Access Control 102 is the largest, then Vendors 76, Inventory 72, DSR 70, Incidents 55, Playbook 54, Posture 49.
- It amends ADR 0143 where needed.

**Done when:** the ADR is merged and COM-1651..1654 are corrected to match anything it finds. If the cap or the connection method turns out different from what's assumed here, Steve is told before COM-1651 starts.

**Independent:** docs only.