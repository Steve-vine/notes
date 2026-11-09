---
id: 01M70VESX2J8VZNXA1SSA0A32Q
created: 2026-11-09T19:09:44.738365Z
updated: 2026-11-09T19:09:44.738365Z
type: task
title: Copilot on the Connect page — the address for each area, and the steps for the person and for the Microsoft 365 administrator
label: feature
priority: medium
assignee: steve
task_status: todo
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1653
---
**Wanted behaviour:**
- The Connect page gets a **Microsoft 365 Copilot** card. It explains that Copilot connects one area at a time and lists each area's address with a Copy button. Areas the person's role can't use are left out.
- **For the person:** how to find the Compass agent in Teams or Microsoft 365 Copilot, and what happens the first time: the browser opens, they sign in to Compass and click Allow.
- **For whoever builds the agents** (a Microsoft 365 / Power Platform administrator): a short guide, linked from the card, with the exact steps in Copilot Studio as the ADR records them. Create an agent per area, add Compass's area address as an MCP tool with OAuth sign-in (and the hand registration from Admin if needed), allow the custom connector in the tenant's data-loss-prevention policy, and publish to staff.
- Claude and ChatGPT cards are unchanged and keep the full address.

**Done when:** on staging, the card shows every area's address for an administrator and only their areas for a narrower role. Copy copies the address. The guide's steps match Copilot Studio as the ADR found it.

**On the chain:** uses the per-area address API. After the sign-in task.