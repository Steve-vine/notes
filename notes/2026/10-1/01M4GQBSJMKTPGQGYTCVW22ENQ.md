---
id: 01M4GQBSJMKTPGQGYTCVW22ENQ
created: 2026-10-09T16:18:57.236839Z
updated: 2026-10-10T14:59:37.449087Z
type: task
title: A technology asset shows the AWS resources behind it and what Compass read about each — and says when one has gone or is no longer read
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 885
sprint: svsqcj9
blocked_by:
- 01M4GQBC18SVPP9FKTMQE1TN21
comments:
- id: 01M4K576CN2KB82D3P6K3WY0W3
  author: Steve Vine
  at: 2026-10-10T14:59:35.445429Z
  text: |-
    Merged to main (PR #893, 2026-10-10). On staging once all ten tasks are in Review.

    What to look at:
    - A technology asset's page has a Resources section, above Installed software. Each row is a resource beneath the asset: its name with a few words on how it is configured, what it is, the account and region, and when it was last seen. Click the name for everything Compass read.
    - Remove takes a resource off the asset and puts it back in the Discovered tab. Add resource picks from what is awaiting a decision there.
    - A resource that has gone from AWS stays in the list with a red "Gone since" and the date. One whose AWS account has been removed from Compass says "No longer read" and still shows the account number.
    - A shared part says "Also serves" and links to the other assets.
    - The Technology assets list has a Resources column (how many) and a Source filter: "Has discovered resources" or "Hand-entered only".
    - In the portal, an owner sees the same Resources list with no Add or Remove.
    - Deleting a technology asset sends its resources back to the Discovered tab.

    Behaviour worth knowing:
    - What was read never overwrites what was typed. The asset's own hosting, environment and other fields stay as entered.
    - If a resource that has already gone is removed from its asset, it does not reappear in Discovered. There is nothing left to decide about it.
    - The Resources section is hidden on an asset that has none, for anyone who cannot manage the register.

    Decision made in this task (the task asked for one): when an AWS account is removed, attached resources keep a copy of the account number rather than the connection being kept as a hidden record. The account's name is lost; the number is what identifies it.

    Technical: no migration. ContainerOut gains resources, built by the same code as the Discovered tab's rows (core/discovery/reads.py). No new portal write route.
assignee: steve
label:
- feature
priority: high
task_status: review
---
Part of sprint 67, Inventory expansion (ADR in COM-881). The Discovered tab puts resources beneath technology assets; this is the view of them from the asset.

## What people see

- **A technology asset's page gains "Resources"**: each resource beneath it, with its name, what it is, account, region, the main facts (for a database: engine and version, encrypted, publicly reachable, backups) and when it was last seen.
- **The facts are read-only** and labelled as read from AWS, with the time. They sit beside the hand-entered fields and never overwrite them.
- **A resource that has gone from AWS stays listed**, marked "Gone since" with the date, until someone removes it.
- **A resource whose account has been disconnected** is marked "No longer read".
- **A resource shared with other assets** (a server or load balancer, never something that holds data) says which other assets it serves.
- **Remove** takes a resource off the asset and puts it back in the Discovered tab. **Add** picks one from there.
- **The Technology register gains a "Resources" count column** and a filter for assets that have discovered resources and those that are hand-entered only.
- **Owners see the same Resources list, read-only, in the Portal.**
- **Deleting a technology asset** puts its resources back in the Discovered tab.

## Notes (technical)

- **Reads.** Extend the container detail read in `core/inventory_reads.py` and the portal read behind `api/v1/portal_inventory.py`. The facts shown are the reader's `summarise(facts)`, so the frontend holds no AWS-specific shapes.
- **The count and filter** are a join on `technology_asset_resources` in the register list read; the filter is URL-backed like the others.
- **Detach** and **attach from the asset** reuse the review transitions from the Discovered tab task. Detaching the last attachment of a resource sets it back to `new`.
- **Delete.** The guarded delete (ADR 0072 §6) detaches first, in the same transaction.
- **"No longer read"** is derived from the connection being gone, not stored on the resource. Removing a connection must therefore keep attached resources (the connection task says so on its confirm dialog); decide in this task whether the connection row is soft-deleted or the resources keep a copy of the account number and name.
- **Portal.** The portal page is read-only here; no new portal write route, so the portal write-routes allowlist test is untouched.
- **Screen.** `SoftwareAssetDetailPage.tsx` shows where a section like this sits on a detail page; follow the same layout on the technology asset page. `SortableTh` or a no-sort comment on the table.
- **API.** Regenerate `schema.d.ts` and run the drift script.
- **Tests.** Integration: detach returns the resource to the tab, delete detaches, a shared component lists its other assets, a gone resource stays. Vitest for the section and the register filter.

**Done when:** on staging, the technology asset made in the Discovered tab task lists its resources with their facts; removing one returns it to Discovered; the register filter separates discovered-backed assets from hand-entered ones.