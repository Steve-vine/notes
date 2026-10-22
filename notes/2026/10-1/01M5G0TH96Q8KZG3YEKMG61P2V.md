---
id: 01M5G0TH96Q8KZG3YEKMG61P2V
created: 2026-10-21T20:00:44.838336Z
updated: 2026-10-22T06:01:25.33685Z
type: task
title: An incident's asset pickers fill in for handlers who can't view the inventory
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1201
sprint: ss8348q
comments:
- id: 01M5H36CB99S4WD4EF9MKWD9P3
  author: Steve Vine
  at: 2026-10-22T06:01:24.585626Z
  text: |-
    Done — merged in PR #1231.

    - An incident handler who can't view the inventory now sees the company's full lists in every asset picker: Link a technology asset, Link a data asset, Add a service affected, and the AI system on the AI card.
    - The pickers show each asset's reference and name ("AST-3 · Payroll server"), as before.
    - The AI card still offers only live AI systems and still suggests the asset's supplier as the vendor.
    - Linking works as before. The inventory itself, and an asset's own page, still need View inventory.

    My calls (beyond the task):
    - **Who can read these lists:** anyone who can view the Incident Register or the inventory, the same rule as the vendor list (COM-1192).
    - **What the lists carry:** only what the pickers need, which is reference, name and status. Technology assets also carry whether they're an AI system and their supplier, for the AI card. No owners, holders or data held.
    - **Decommissioned assets** stay on the lists, as on the register, because an outage can still name one.
assignee: steve
label:
- bug
priority: medium
task_status: review
---
Found while building COM-1192 (sprint 79), which fixed the same kind of gap for vendor pickers.

**What's wrong:** on an incident, the pickers that choose from the inventory read the inventory's own lists, which need View inventory. An incident handler who can't view the inventory gets empty lists, with no explanation:
- **Link a technology asset** and **Link a data asset**
- the **AI system** picker on the AI card
- **Service impact**

**What it should do:** anyone who can work on incidents can choose from these lists on the incident. The pickers show names only (and whatever small detail the picker needs to tell two similar assets apart). The inventory itself, and an asset's own page, still need View inventory.

**Done when:** a user who can handle incidents but not view the inventory sees the full lists in each of these pickers, can link an asset, and still can't open the inventory or an asset's page.