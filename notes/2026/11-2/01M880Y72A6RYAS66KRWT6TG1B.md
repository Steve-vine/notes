---
id: 01M880Y72A6RYAS66KRWT6TG1B
created: 2026-11-25T00:15:55.466635Z
updated: 2026-11-25T01:47:20.182091Z
type: task
title: Polaris can set an engagement's business services when adding or editing it
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2159
sprint: ss3ttbb
blocked_by:
- 01M87NQ09XED3JVCD11CASC93A
assignee: steve
label:
- follow_up
priority: low
task_status: active
---
Sprint "Business Services". Follow-up from COM-2152 (24/25 Nov 2026): on screen, adding or editing a vendor engagement can pick the business services it helps deliver, and Polaris now reads them, but Polaris's `vendors_add_engagement` and `vendors_update_engagement` can't set them.

## What people see
- Polaris can add an engagement with its business services named in words ("TAS, LiveChat"), and change or clear them on an existing engagement.
- A name that doesn't match one of the company's active services is refused, with the list of services. A retired service already on the engagement can be kept.
- As on screen, this needs the right to view the inventory. Without it, Polaris says so and leaves the services alone.

## Done when
- Polaris adds an engagement with two services, and the vendor's Blast radius shows both through that engagement.
- Polaris clears them, and the engagement routes go.

Independent: Polaris tools only (`assistant/tools/vendors_engagements.py`, reusing the engagement API's `business_service_ids` from COM-2152). No migration or API change.