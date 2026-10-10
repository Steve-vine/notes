---
id: 01M4GQBC18SVPP9FKTMQE1TN21
created: 2026-10-09T16:18:43.36827Z
updated: 2026-10-10T14:11:15.443345Z
type: task
title: Inventory gains a Discovered tab — each new resource is made into a technology asset, added to an existing one, or discarded with a reason
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 884
sprint: svsqcj9
blocked_by:
- 01M4GQAX5R29AP2NY27WDBQZTY
assignee: steve
label:
- feature
priority: high
task_status: active
---
Part of sprint 67, Inventory expansion (ADR in COM-881). This is where a person decides what each discovered resource is. It goes to staging with the reading task.

## What people see

- **A "Discovered" tab on Inventory**, with a count of resources awaiting a decision.
- **The list shows** each resource's name, what it is (storage bucket, PostgreSQL database and so on), its account and region, when it was first seen, and what Compass proposes. It filters by account, kind and region, and sorts on any column.
- **Opening a resource shows what Compass read about it.**
- **Three decisions:**
  - **Make a technology asset.** The usual form opens already filled in: the name, Datastore, Cloud, a hosting line such as "AWS · eu-west-2 · RDS PostgreSQL 15", and Production or Non-production from the account. Owner and criticality are left for the person. On save the resource sits beneath the new asset.
  - **Add to an existing technology asset** in the same company.
  - **Discard**, with a reason. The resource leaves the list and does not return on later reads. A "Discarded" filter shows them, and a discarded resource can be restored.
- **Several at once.** Select several resources and add them all to one asset, discard them with one reason, or make one technology asset from all of them (a database and its replicas, a set of buckets).
- **Compass proposes "make a technology asset" for anything that holds data.** The person can always choose otherwise.
- **A resource that holds data can sit beneath one technology asset only.** Compass says which asset already has it if a second is tried.
- **A resource that disappears from AWS before anyone decides** simply leaves the list.
- **Who:** anyone who can manage the register makes decisions; anyone who can view Inventory can read the tab.
- **Each decision is in the audit trail**, on the technology asset where there is one.

## Notes (technical)

- **`technology_asset_resources`**: `container_id`, `discovered_resource_id`, timestamps and actor.
  - A `datastore` resource has at most one row; enforce in the write path and back it with a partial unique index.
  - Same-company only, refused otherwise.
- **Review transitions** in `core/discovery/review.py`. Discarding keeps the row, which is how it is remembered; restoring sets it back to `new`.
- **Create-with-attach is one transaction** through the existing container create in `core/inventory_writes.py`, so AST numbering, validation and audit are the same path as a hand-made asset.
- **The proposal is computed from the category**, not stored.
- **Prefill** comes from the reader's `summarise(facts)` and the connection's default environment. The name is the `Name` tag where present, otherwise the resource's own identifier.
- **API.** `/api/v1/inventory/discovered`: paginated list with filters, detail, and `attach`, `create-asset`, `discard`, `restore`, each with a bulk form. Reads need `inventory.view`; decisions need `inventory.manage_register`. Regenerate `schema.d.ts` and run the drift script.
- **The tab count** comes from the summary endpoint (`api/v1/inventory_summary.py`).
- **Screen.** A new `ScreenFrame.Panel value="discovered"` in `InventoryPage.tsx`.
  - Screen conventions: `SortableTh` on the table, pills never truncate, `w="fit-content"` on checkboxes.
  - Filters are URL-backed with the `useQueryState` hooks.
  - The breadcrumb trail behaves as on the other Inventory tabs.
- **Not in global search.**
- **Tests.**
  - Integration: the one-home rule, cross-company refusal, discard then re-read stays discarded, restore, the bulk forms.
  - Vitest: the tab and the three dialogs. Page tests' prefix stubs will answer the new sub-routes with the parent object unless they are stubbed explicitly.

**Done when:** on staging, resources from the connected account are listed; one is made into a technology asset with its fields filled in; one is added to an existing asset; one is discarded and is still discarded after the next read.