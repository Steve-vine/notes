---
id: 01M54KDFX2H3EYXPBW99CRBV0F
created: 2026-10-17T09:34:47.20244Z
updated: 2026-10-17T09:37:39.469704Z
type: task
title: Other modules feed a control's Evidence of operation — vendor reviews, access recertifications, asset recertifications and content reviews
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1060
blocked_by:
- 01M54K7WXVGPCGPD43HMDK98PP
assignee: steve
label: follow_up
priority: low
task_status: backlog
---
Follow-up from sprint 75 (ADR in COM-1041; Steve, G, 2026-10-17: "later"). Logged so it isn't lost; not scheduled. Split into one task per module when it is.

## Why

Sprint 75 makes **Evidence of operation** (COM-1051) the one place a control shows it's working, with SAP as its only source. Several things Compass already does also prove a control operates, but none of them show on the control today:

- **Vendor reviews:** the supplier-management controls (e.g. s42.VEM.7);
- **Access recertifications:** the access-review controls;
- **Asset recertifications:** the asset-inventory and asset-access controls;
- **Content reviews:** the policy-review controls, and the domain's policy for every company.

## What each would need settled (with Steve, per module)

- **Which control(s) it evidences.** It could be fixed per module, set per schedule (like SAP's links), or set once in the module's settings. This is the main question, because modules don't link to controls today.
- **What counts as "last done" and "next due"** in that module's own terms, such as a recertification run finishing or a review being recorded.
- **What evidence it offers:** a link to the run or review, and any files.

## Notes (technical)

- Each becomes a new source in COM-1051's registry; the contract is in the ADR.
- COM-1048's calendar adapters already read the recertification and content-review dates and should be reused.

**Done when:** split into per-module tasks with the control question answered for each.