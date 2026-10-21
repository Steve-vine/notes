---
id: 01M5G0TH96Q8KZG3YEKMG61P2V
created: 2026-10-21T20:00:44.838336Z
updated: 2026-10-21T20:00:59.984246Z
type: task
title: An incident's asset pickers fill in for handlers who can't view the inventory
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1201
sprint: ss8348q
assignee: steve
label:
- bug
priority: medium
task_status: todo
---
Found while building COM-1192 (sprint 79), which fixed the same kind of gap for vendor pickers.

**What's wrong:** on an incident, the pickers that choose from the inventory read the inventory's own lists, which need View inventory. An incident handler who can't view the inventory gets empty lists, with no explanation:
- **Link a technology asset** and **Link a data asset**
- the **AI system** picker on the AI card
- **Service impact**

**What it should do:** anyone who can work on incidents can choose from these lists on the incident. The pickers show names only (and whatever small detail the picker needs to tell two similar assets apart). The inventory itself, and an asset's own page, still need View inventory.

**Done when:** a user who can handle incidents but not view the inventory sees the full lists in each of these pickers, can link an asset, and still can't open the inventory or an asset's page.