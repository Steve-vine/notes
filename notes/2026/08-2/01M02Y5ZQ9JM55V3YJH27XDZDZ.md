---
id: 01M02Y5ZQ9JM55V3YJH27XDZDZ
created: 2026-08-15T14:45:57.609826Z
updated: 2026-08-15T14:46:04.374456Z
type: task
title: 'Portal register: engagement sub-rows under each vendor (status + criticality)'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 212
sprint: sbph5q5
blocked_by:
- 01M02VDB867ANRGG857S9HNHF6
assignee: steve
label:
- improvement
priority: medium
task_status: todo
---
The portal Vendors register lists vendors only; engagements are visible only on the detail page. Show each vendor's engagements as indented sub-rows in the same table (decided 2026-08-15, option 1 — display-only):

```
Composio        [active] [compliant] [high]  [flags…]
  – Telephony       [active]              [medium]
  – Extra services  [proposed]            [high]
```

- [ ] **Backend**: engagement summaries (id, scope, status, criticality) included in the portal vendor register payload (`/api/v1/portal/vendors`) — today they only ride the detail endpoint. Non-ended engagements only (proposed + active); ended stay detail-page history. OpenAPI regenerated.
- [ ] **Frontend** (`PortalVendorsPage`): indented sub-row per engagement under its vendor — scope as the label, engagement `status` in the State column, engagement `criticality` in the Criticality column. **Compliance and Flags stay blank on sub-rows** — they are vendor-level facts, shown once on the parent (decided against per-engagement compliance/flags; that would need a per-engagement review design, not a display tweak).
- [ ] Sub-row scope links to the vendor detail page (engagements section).
- [ ] Filters keep operating on vendors (a vendor matching the filter shows with all its engagements).
- [ ] Tests: payload includes engagements, sub-rows render with the right pills, blank compliance/flags cells.

Stacks on COM-208 (engagement criticality column).