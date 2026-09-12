---
id: 01M2AC044DZE4VKFJ3163TAKMM
created: 2026-09-12T08:33:30.253915Z
updated: 2026-09-12T09:08:45.90928Z
type: task
title: '"Processing role" is labelled "Role" on the data asset screens'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 689
sprint: skdc1az
assignee: steve
label:
- improvement
priority: low
task_status: active
---
Requested by Steve, 2026-09-12: the field that records whether the company is controller, processor or joint controller for a data asset is titled **"Role"**, not "Processing role".

* The label on the data asset modal (`DataAssetModal.tsx`), the `Fact` label on the data asset detail page, the column heading on the data assets tab (`InventoryPage.tsx`), the portal data asset page, and the CSV template's human header (the column key `processing_role` stays).
* The options are unchanged: Controller · Processor · Joint controller. The description, if the field has one, still says what the role is about ("Whether the company decides why and how this data is processed, or does so for someone else").
* Identifier `processing_role` unchanged in the API and database — words only. OpenAPI description changes → run the drift script.
* Tests that assert on the old label.

**Acceptance**: no "Processing role" on any data asset screen, in the portal, or in the CSV template header; the field still round-trips.