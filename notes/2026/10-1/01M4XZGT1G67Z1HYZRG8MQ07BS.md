---
id: 01M4XZGT1G67Z1HYZRG8MQ07BS
created: 2026-10-14T19:51:37.776186Z
updated: 2026-10-17T08:13:29.874366Z
type: task
title: 'The Discovered tab gets a Software view: each piece of software found on technology assets is listed once with a count, and is added to the register or discarded'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 960
sprint: sbkelqe
blocked_by:
- 01M4XZGAED6YBRW7MT1HJSSDCY
assignee: steve
label:
- feature
priority: high
task_status: active
---
Part of sprint 67, Inventory discovery - Software (ADR in COM-959). This is the foundation the readers below fill. It moves the database engines found today out of the Software tab's banner and into the new view.

## What people see

- **Inventory ▸ Discovered has two views, Resources and Software.** Resources is today's list, unchanged.
- **Software lists each piece of software once:** name, major version, publisher, where it was found ("AWS", "Azure", "Google Cloud", "Active Directory"), and **how many technology assets** it is on. Example: "PostgreSQL 15 · AWS · on 4 technology assets".
- **Opening a row** shows those technology assets, the resources beneath them that run it, and the exact version on each (15.4, 15.7).
- **Three outcomes for each row:**
  - **Add to Software.** The usual Software form opens with the name, version, publisher and type filled in. Once saved, the row leaves this view and the entry's *Deployed on* shows where it runs. Support dates are filled in by COM-962.
  - **It is already here.** The row is matched to an existing Software entry, as today.
  - **Discard.** Asks for a reason, is remembered for that software on every asset, and can be undone from a "Discarded" filter.
- **Many at once:** tick rows and discard them together. This is needed for Linux servers, which report hundreds of packages.
- **Search and filters:** by name, by where it was found, by type (operating system, database, Kubernetes, runtime, application), and **"known support dates only"**.
- **The blue "Found by discovery" banner on the Software tab goes.** Anything already dismissed there stays discarded.
- Who can add or discard: the people who can edit Inventory today.

## Notes (technical)

- The table of software found per discovered resource, as the ADR settles it. Each read replaces a resource's rows, so an upgrade moves the count to the new version by itself (the COM-889 "derived, not synced" property kept).
- Existing engine facts (RDS, Azure flexible, Cloud SQL) are written into it by the existing readers. `software_discovery_dismissals` carries over as discards, with no reason recorded for the old ones.
- The grouping key is the ADR's: product + major version. Normalising names is per source, so each reader task owns its own.
- Lists can be thousands of rows: paginate and filter on the server. Use `SortableTh`, per the screen-conventions test.
- New routes go under `/api/v1`. Regenerate `schema.d.ts`.

**Done when:** on staging, Discovered ▸ Software lists the database engines already found, with the right counts; opening one shows its assets; adding, matching and discarding (singly and several at once) all work; and the Software tab no longer shows the banner.