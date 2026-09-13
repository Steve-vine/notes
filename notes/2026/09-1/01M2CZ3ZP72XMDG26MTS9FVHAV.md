---
id: 01M2CZ3ZP72XMDG26MTS9FVHAV
created: 2026-09-13T08:46:08.583632Z
updated: 2026-09-13T10:00:18.994286Z
type: task
title: Software asset page — Support becomes a full-width Lifecycle section holding the review details and Delete; the Review section goes
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 703
sprint: skdc1az
assignee: steve
label:
- improvement
priority: medium
task_status: active
---
Requested by Steve, 2026-09-13: the software asset detail page (`pages/SoftwareAssetDetailPage.tsx`) reads in this order, every section full width, mirroring the other two registers:

1. **Record**
2. **Lifecycle** — today's *Support* card, renamed and made full width: End of mainstream support, End of extended support, the derived support pill, **plus** the review facts that live in the Review card today (Last verified, Review interval, Next review) **and the Delete button** (the guarded delete from COM-695) in the card's action slot, where the technology and data asset Lifecycle cards keep their transition buttons.
3. **Licensing and cost** — full width now that it no longer shares a row with Support.
4. **Deployed on**
5. **Risks**
6. **Decisions**
7. **Notes**
8. **Audit trail**

* The **Review** card (`ReviewCard`) is removed; its facts and its Delete/confirm move into `LifecycleCard`. Confirm accurate stays in the page header beside Edit, as on the other registers.
* Today's order is Record · Support | Licensing (side by side) · Review · Deployed on · Risks · Decisions · Notes · Audit trail.
* The portal software asset page follows the same order for the sections it shows.
* Tests: heading order, the Delete flow now driven from Lifecycle, no Review heading.
* No API change.

**Acceptance**: no Support or Review headings; a full-width Lifecycle card shows both support dates, the support pill, last verified / interval / next review and the Delete button; Licensing and cost follows it full width.