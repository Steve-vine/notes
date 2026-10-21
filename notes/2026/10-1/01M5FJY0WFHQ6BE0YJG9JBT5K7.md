---
id: 01M5FJY0WFHQ6BE0YJG9JBT5K7
created: 2026-10-21T15:57:59.05525Z
updated: 2026-10-21T15:57:59.05525Z
type: task
title: Incidents' and Inventory's pick-lists fill in for people who can't view vendors
label: bug
task_status: todo
priority: medium
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1192
---
Found while building COM-1173 (sprint 79), which fixed the same gap in Data Subject Requests.

**What's wrong:** some pick-lists in Incidents and Inventory draw on lists that are only loaded for people who can view vendors. Someone who can work incidents or inventory but can't see vendors gets an empty list, with no explanation:
- **Incidents:** the vendor pickers (e.g. a supplier involved in an incident), and the **data types** on an incident's privacy-breach card.
- **Inventory:** the vendor pickers on data assets and their recipients, and anywhere else Inventory offers vendors to choose from.

**What it should do:** anyone who can work in the module can choose from these lists there. The pickers show names only, as in Data Subject Requests. The vendor register itself still needs View vendors, because it shows risk, compliance and contacts. Changing the data types list stays admin-only.

**Done when:** a user who can handle incidents (or edit inventory) but not view vendors sees the full vendor and data-type lists in those pickers, and still can't open the vendor register.