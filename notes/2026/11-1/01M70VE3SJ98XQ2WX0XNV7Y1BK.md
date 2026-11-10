---
id: 01M70VE3SJ98XQ2WX0XNV7Y1BK
created: 2026-11-09T19:09:22.098603Z
updated: 2026-11-10T09:08:11.009843Z
type: task
title: 'ADR: Copilot connects one area at a time — how Microsoft 365 Copilot reaches Compass today, and why each area gets its own address'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1650
sprint: sr3v2fq
comments:
- id: 01M72BE07WZ0J9KRB6S41V6VEN
  author: Steve Vine
  at: 2026-11-10T09:08:10.107966Z
  text: |-
    **Done: merged to main in PR #1673 as ADR 0144**, "Copilot connects one area at a time". Checked against Microsoft Learn on 2026-11-10.

    **What Microsoft documents today:**
    - **Which Copilot:** a Copilot Studio agent, published to Teams and Microsoft 365 Copilot. Agents built in Copilot Studio for Teams, SharePoint and Microsoft 365 Copilot are included with the Microsoft 365 Copilot user licence at no extra charge (Copilot Studio Licensing Guide, June 2026).
    - **The tool limit is real:** 128 tools per agent, counting every MCP server's tools. Microsoft recommends 25–30 for the best results.
    - **How it identifies itself:** Copilot Studio's MCP wizard offers OAuth 2.0 "Dynamic discovery", meaning it registers itself. Compass already supports that. Compass also already accepts its own HTTPS callback, and treats `resource` as optional.
    - **Transport:** Streamable HTTP only, which Compass already serves.
    - **What an administrator must allow:** MCP runs through Power Platform connectors, so the tenant's data policy must allow it, and org-wide publishing needs admin approval.
    - **An alternative was noted:** a declarative agent (Agents Toolkit) has no stated tool cap, but it's a developer route (VS Code, an app package).

    **The decision:**
    - Each Compass area gets its own address with only its tools, plus who-am-I, search and the company list. Access Control, the largest, is 105.
    - `/api/mcp` is unchanged for Claude and ChatGPT.
    - **No hand registration is built.** COM-1652 shrinks to proving Copilot's quirks with a stand-in.

    ADR 0143 gained an amendment pointing to it, and CLAUDE.md lists 0144. COM-1651–1654 were corrected in comments to match.

    **What this changed from the plan:** the 128 cap and the connection method were as assumed. Self-registration works, so the hand-registration screen in COM-1652 isn't needed.
assignee: steve
label:
- feature
priority: medium
task_status: review
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