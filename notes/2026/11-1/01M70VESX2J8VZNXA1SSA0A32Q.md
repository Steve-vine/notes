---
id: 01M70VESX2J8VZNXA1SSA0A32Q
created: 2026-11-09T19:09:44.738365Z
updated: 2026-11-10T09:34:21.230501Z
type: task
title: Copilot on the Connect page — the address for each area, and the steps for the person and for the Microsoft 365 administrator
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1653
sprint: sr3v2fq
blocked_by:
- 01M70VECM5TSGFBD7JJQ91QPRC
- 01M70VEKSX2MTQGYTFRK1MASX3
comments:
- id: 01M72ARX17MNFBEGVNCE0E51ZY
  author: Steve Vine
  at: 2026-11-10T08:56:38.695698Z
  text: |-
    **Corrected by ADR 0144 (COM-1650, 2026-11-10).** The administrator's guide steps, as Microsoft Learn describes them (updated 2026-11-02):
    1. In Copilot Studio, create an agent for the area.
    2. Tools ▸ Add a tool ▸ New tool ▸ **Model Context Protocol**.
    3. Give a server name, a description (the orchestrator reads it to decide when to call Compass), and the area's address.
    4. For authentication, choose **OAuth 2.0 ▸ Dynamic discovery**, then Create ▸ Next ▸ Create a new connection ▸ Add to agent.
    5. Allow the connector in the tenant's Power Platform data policy.
    6. Publish to Teams and Microsoft 365 Copilot. Org-wide publishing needs admin approval.

    There's no hand registration and no client ID or secret. It's included with the Microsoft 365 Copilot user licence. Microsoft recommends 25–30 tools per agent for best results, with 128 the limit.
- id: 01M72CXXDFN9Y83EAC9CJK2HGY
  author: Steve Vine
  at: 2026-11-10T09:34:20.079563Z
  text: |-
    **Done: merged to main in PR #1677.**

    **What it does:** the Connect page has a new **Microsoft 365 Copilot** panel under the Claude Code, Claude and ChatGPT cards.
    - **For the person:** Copilot connects one area of Compass at a time. They find the Compass agent in Teams or Microsoft 365 Copilot under Agents, and the first time, their browser opens to sign in to Compass and click Allow.
    - **A table of the areas their role can use,** each with its address and a Copy button ("Copy the Access Control address"). Areas the role can't use aren't listed. If there are none, it says so.
    - **"Guide for administrators"** opens the Copilot Studio steps as ADR 0144 found them:
      1. create an agent per area;
      2. Tools ▸ Add a tool ▸ New tool ▸ Model Context Protocol;
      3. a name, a description, and the area's address as the Server URL;
      4. OAuth 2.0 ▸ Dynamic discovery (no client ID or secret: Copilot registers itself);
      5. Create a new connection ▸ Add to agent;
      6. allow the connector in the Power Platform data policy;
      7. publish to Teams and Microsoft 365 Copilot (org-wide needs approval).

      It notes that agents built in Copilot Studio are included with the Copilot licence.
    - Claude and ChatGPT keep the one full address, unchanged.

    **Tests:** the panel lists only usable areas with their addresses and Copy buttons, while the full address still appears only on the Claude and ChatGPT cards; the guide opens with the wizard steps. Lint, the type check and the screen-conventions test pass.

    **To look at on staging** (after the deploy): Connect Polaris (your menu) ▸ Microsoft 365 Copilot. As an administrator every area is listed. A narrower role sees only its own. Then open "Guide for administrators".
assignee: steve
label:
- feature
priority: medium
task_status: review
---
**Wanted behaviour:**
- The Connect page gets a **Microsoft 365 Copilot** card. It explains that Copilot connects one area at a time and lists each area's address with a Copy button. Areas the person's role can't use are left out.
- **For the person:** how to find the Compass agent in Teams or Microsoft 365 Copilot, and what happens the first time: the browser opens, they sign in to Compass and click Allow.
- **For whoever builds the agents** (a Microsoft 365 / Power Platform administrator): a short guide, linked from the card, with the exact steps in Copilot Studio as the ADR records them. Create an agent per area, add Compass's area address as an MCP tool with OAuth sign-in (and the hand registration from Admin if needed), allow the custom connector in the tenant's data-loss-prevention policy, and publish to staff.
- Claude and ChatGPT cards are unchanged and keep the full address.

**Done when:** on staging, the card shows every area's address for an administrator and only their areas for a narrower role. Copy copies the address. The guide's steps match Copilot Studio as the ADR found it.

**On the chain:** uses the per-area address API. After the sign-in task.