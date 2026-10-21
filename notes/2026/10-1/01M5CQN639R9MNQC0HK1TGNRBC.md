---
id: 01M5CQN639R9MNQC0HK1TGNRBC
created: 2026-10-20T13:22:49.065293Z
updated: 2026-10-21T20:16:50.665269Z
type: task
title: Data Subject Requests' pick-lists fill in for handlers who can't view vendors
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1173
sprint: ss8348q
comments:
- id: 01M5EZW12CNKRAQDCZETE22GH2
  author: Steve Vine
  at: 2026-10-21T10:24:50.759593Z
  text: |-
    Done — PR #1193, merged 21 Oct 11:23 BST.

    - Someone who can handle Data Subject Requests but can't view vendors now sees the full list of data entities on Log a request and on a group disclosure, and the full list of data types on Disclosures and Requests to disclose.
    - "Forwarded by a customer", the recipient on Disclosures and Requests to disclose, and Tell recipients ▸ Add a recipient now list the company's vendors by name for those handlers.
    - Those pickers show names only. The vendor register itself still needs View vendors, because it shows risk, compliance and contacts.
    - Changing the data entity and data type lists is still admin-only.
    - The permission catalogue says this under Data Subject Requests.

    My call: the vendor pickers list every vendor, offboarded ones included, as they did before.

    Found but not changed (outside Data Subject Requests): the vendor pickers in Incidents and Inventory, and the data types on an incident's privacy-breach card, have the same gap for people without View vendors. Say if you want a task for them.
assignee: steve
label:
- bug
priority: medium
task_status: done
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