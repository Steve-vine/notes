---
id: 01M5CQN639R9MNQC0HK1TGNRBC
created: 2026-10-20T13:22:49.065293Z
updated: 2026-10-20T15:01:21.958816Z
type: task
title: Data Subject Requests' pick-lists fill in for handlers who can't view vendors
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1173
sprint: ss8348q
assignee: steve
label:
- bug
priority: medium
task_status: todo
---
Found while smoke-testing sprint 79.

**What's wrong:** In Data Subject Requests, several pick-lists draw on lists that are only loaded for people who can view vendors. Someone who can handle requests but can't see vendors gets an empty list, with no explanation:
- **Log a request ▸ Data entities** (currently labelled "Kind of person"). If it's left empty, Fulfil lists no systems and Tell recipients suggests nobody.
- **Disclosures ▸ About whom ▸ a group**: the data entity picker.
- **Disclosures** and **Requests to disclose**: the data types picker.
- Also check the vendor / customer pickers on Log a request ("Forwarded by a customer") and Requests to disclose, which may have the same gap.

This was already the case before sprint 79: these lists are shared with Vendors and the portal, and reading them is tied to the vendor permission.

**What it should do:** anyone who can view Data Subject Requests can choose from these lists in the module. They're governed vocabularies, and reading them gives nothing away. Changing them stays admin-only.

**Done when:** a user who holds the Data Subject Requests permissions but not View vendors can log a request with a data entity, log a group disclosure, and choose data types. Each picker shows the full list.