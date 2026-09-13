---
id: 01M2CZ364JBXZS1YBZKZ2K4SWP
created: 2026-09-13T08:45:42.418891Z
updated: 2026-09-13T09:57:50.091346Z
type: task
title: Technology asset page — sections reordered; Hosting and Resilience become one section; Data held becomes Data assets
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 701
sprint: skdc1az
assignee: steve
label:
- improvement
priority: medium
task_status: active
---
Requested by Steve, 2026-09-13: the technology asset detail page (`pages/ContainerDetailPage.tsx`) reads in this order, top to bottom, every section full width:

1. **Record**
2. **Lifecycle** (status + dates + End of support + last verified / review interval / next review, the transition buttons — as today, moved up)
3. **Recertification**
4. **Access**
5. **Hosting / Resilience** — today two side-by-side cards (`HostingCard`, `ResilienceCard` in a `SimpleGrid`); they become **one card** titled "Hosting / Resilience" with the hosting facts (Hosting, Detail, Supplier) and the resilience facts (Criticality, RTO, RPO) as two groups inside it, still on one row at desktop width.
6. **Data assets** (rename from "Data held"; same content — the mapped data assets with role and the derived classification pill)
7. **Dependencies**
8. **Installed software**
9. **Risks**
10. **Decisions**
11. **Notes**
12. **Audit trail**

* Today's order is Record · Hosting | Resilience · Lifecycle · Access · Recertification · Data held · Dependencies · Installed software · Risks · Decisions · Notes · Audit trail — so the moves are Lifecycle up, Recertification above Access, Hosting/Resilience down and merged, and the rename.
* The portal's technology asset page (`PortalContainerPage.tsx`) follows the same order for the sections it shows.
* Section titles are exactly the words above; the `screen-conventions` test that pins section order (if there is one) is updated, and the detail page test's heading assertions follow.
* No API change.

**Acceptance**: the page's section headings appear in the order listed; Hosting / Resilience is one card; the data section is titled Data assets.