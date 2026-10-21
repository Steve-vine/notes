---
id: 01M5FJY0WFHQ6BE0YJG9JBT5K7
created: 2026-10-21T15:57:59.05525Z
updated: 2026-10-21T20:16:50.829372Z
type: task
title: Incidents' and Inventory's pick-lists fill in for people who can't view vendors
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1192
sprint: ss8348q
comments:
- id: 01M5FPEBV6NT2NT5K7ANZKW7SY
  author: Steve Vine
  at: 2026-10-21T16:59:20.294177Z
  text: |-
    Done — PR #1210, merged 21 Oct 17:58 BST.

    - Someone who can view incidents but not vendors now gets the company's full vendor list in **Link a vendor** (Impact card) and in the AI card's vendor picker, and the full **data types** list on an incident's privacy-breach card.
    - Someone who can view the inventory but not vendors now sees the **Vendor** picker on software, the **Supplier** picker on containers, and **Vendors this data is disclosed to** on data assets (these were hidden from them before). A data asset's data types and data entities lists fill in too.
    - The pickers show names only, in name order, for the chosen company.
    - Data Subject Requests now uses the same shared list. Nothing changes on screen there.
    - The vendor register and a vendor's own page still need View vendors. Changing the data types and data entities lists stays admin-only.
    - The permission catalogue says this under Inventory, Incidents and Data Subject Requests.

    My calls:
    - The shared list leaves out deleted vendors, as the register does. Data Subject Requests' pickers used to include them.
    - Viewing (not only handling) incidents or inventory is enough to see the names.

    Found, not changed: the asset pickers on an incident (link a technology or data asset, the AI system, Service impact) read Inventory's own lists, so an incident handler who can't view the inventory gets empty lists. Say if you want a task.
assignee: steve
label:
- bug
priority: medium
task_status: done
---
Found while building COM-1173 (sprint 79), which fixed the same gap in Data Subject Requests.

**What's wrong:** some pick-lists in Incidents and Inventory draw on lists that are only loaded for people who can view vendors. Someone who can work incidents or inventory but can't see vendors gets an empty list, with no explanation:
- **Incidents:** the vendor pickers (e.g. a supplier involved in an incident), and the **data types** on an incident's privacy-breach card.
- **Inventory:** the vendor pickers on data assets and their recipients, and anywhere else Inventory offers vendors to choose from.

**What it should do:** anyone who can work in the module can choose from these lists there. The pickers show names only, as in Data Subject Requests. The vendor register itself still needs View vendors, because it shows risk, compliance and contacts. Changing the data types list stays admin-only.

**Done when:** a user who can handle incidents (or edit inventory) but not view vendors sees the full vendor and data-type lists in those pickers, and still can't open the vendor register.