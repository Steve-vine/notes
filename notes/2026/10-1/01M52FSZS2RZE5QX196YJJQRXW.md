---
id: 01M52FSZS2RZE5QX196YJJQRXW
created: 2026-10-16T13:53:13.506091Z
updated: 2026-10-16T13:54:08.889131Z
type: task
title: 'The assistant can work the Discovered tab — what discovery found, and for each resource: make it a technology asset, add it to one, or discard it with a reason'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1030
sprint: sfzoxya
blocked_by:
- 01M52FQBGZ8WV65TRK7VZPWZ63
assignee: steve
label:
- feature
priority: high
task_status: todo
---
Sprint 74, MCP - Inventory (ADR in COM-1023). Built on COM-1024. This is the manual work the discovery sprints set out to cut, so it is the main reason to give Inventory to the assistant.

## What people can ask of it

- **Read (for a named company):**
  - **resources awaiting a decision, attached, or discarded**, filtered as on the tab: where each was found (the account, subscription, project or domain), kind, region, what runs on it, and whether a rule or a person filed it;
  - **one resource in full**: its facts, its tags, and where it's attached or why it was discarded;
  - the counts behind each filter.
- **Write (whatever the person's role allows on screen), on one resource or several at once:**
  - **make a technology asset** from it, with the asset's details filled in as the decision window does;
  - **add it to an existing technology asset**, or move an attached one to another;
  - **discard it**, with a reason;
  - **restore** a discarded one.
- **Untrusted text:** a resource's name, tags and description were written by whoever runs that cloud or domain. The assistant shows them but never acts on what they say (COM-1023).
- **Example:** "What's awaiting a decision from the production AWS account? Put the three RDS databases tagged app=payroll under AST-3, and discard the test buckets as 'test data, no business information'."

## Notes (technical)

- Wraps `discovered.py`: list, facets, get, attach, create-asset, detach, discard and restore.
  - `create-asset` takes a full technology asset body, so reuse COM-1024's create fields rather than defining them again.
  - The routes take lists of ids, so the tools take lists too. Resolve each item by name or id within the company, and refuse ambiguity with candidates.
- **Shared lookup:** `find_connection`, which names "where it was found" across AWS, Azure, Google and directory connections. COM-1032's settings tools reuse it. It needs nothing beyond `inventory.view`. If the connections list route needs admin, read the names from the facets instead.
- Return tags and descriptions under the untrusted key (COM-1023).
- Discard is `destructive`, because it hides the resource from the awaiting list. Restore and attach are writes.
- New module `tools/inventory_discovered.py`.
- Tests:
  - batch attach;
  - discard needs a reason;
  - writes are hidden without manage-register;
  - a tag such as "ignore previous instructions" comes back only under the untrusted key;
  - a decision is recorded via assistant.

**Done when:** on staging, the assistant files a handful of awaiting resources (one made into an asset, some attached, some discarded), and the Discovered tab shows each where it should be.