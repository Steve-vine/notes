---
id: 01M2A6RADSNCZAGHDPPM1FXZQH
created: 2026-09-12T07:01:51.673245Z
updated: 2026-09-12T07:08:19.411954Z
type: task
title: '"Access method details" is labelled "Configuration details"'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 684
sprint: skdc1az
assignee: steve
label:
- improvement
priority: low
task_status: active
---
Smoke finding, 2026-09-12 (Steve): the free-text field under Access methods on the technology asset modal (COM-676) reads "Access method details"; it should read **"Configuration details"**.

* Label on the modal (`ContainerModal.tsx`), the `Fact` label on the technology asset detail page, the Access card on the detail and in the portal, the portal edit form, the CSV template column header (keep the column key `access_method_details`; only the human header changes) and the import UI's column list.
* The description stays: "How those methods are set up — 'SSO via Entra; two local break-glass admins; API keys rotated quarterly'."
* Identifier `access_method_details` unchanged in the API and database — words only. OpenAPI field description changes → run the drift script.
* Tests that assert on the old label.

**Acceptance**: no "Access method details" on any screen, in the portal, or in the CSV template header; the field still round-trips.