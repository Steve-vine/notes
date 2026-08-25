---
id: 01M02Y5ZQ9JM55V3YJH27XDZDZ
created: 2026-08-15T14:45:57.609826Z
updated: 2026-08-25T18:43:15.174618Z
type: task
title: 'Portal register: engagement sub-rows under each vendor (status + criticality)'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 212
sprint: sbph5q5
blocked_by:
- 01M02VDB867ANRGG857S9HNHF6
comments:
- id: 01M0346EKF7XFTCW72MEYGHZVZ
  author: Steve Vine
  at: 2026-08-15T16:31:04.302946Z
  text: |-
    Done — PR #209 (feature/com-212-portal-engagement-subrows, stacked on #208 → #207 → #206). All checklist items landed; display-only as decided.

    One design call worth flagging: the engagement summaries ride the shared VendorOut rather than a portal-only response model. core/vendor_reads.py exists (ADR 0040 §3) precisely so the two surfaces cannot drift, and a portal-only field would be the first deliberate divergence — so the internal register gets the data too and simply doesn't render it yet. Cost is one extra batched query beside the existing flags and latest-review ones, so the register still costs a fixed number of round-trips regardless of row count.

    New VendorEngagementSummaryOut is deliberately slim (id, scope, status, criticality) rather than the full VendorEngagementOut — a list endpoint's payload should grow with what's displayed, not with the record.

    Non-ended only, as specified. There's a test asserting an ended engagement is excluded while a proposed one survives, since that's the pair that would be easy to get backwards.

    Compliance/Flags blank on sub-rows is asserted two ways — the cells are empty AND the parent's values ("Under review", "PCI") are absent from the sub-row — so a regression that leaks vendor-level facts down fails rather than passing on a technicality.

    Backend 369 integration passing; frontend 264 across 51 files. OpenAPI regenerated; single Alembic head 0054 (no migration in this one).
assignee: steve
company: null
label:
- improvement
priority: medium
task_status: done
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