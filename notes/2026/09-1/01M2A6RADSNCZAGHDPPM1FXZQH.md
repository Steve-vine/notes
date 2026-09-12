---
id: 01M2A6RADSNCZAGHDPPM1FXZQH
created: 2026-09-12T07:01:51.673245Z
updated: 2026-09-12T08:37:25.607387Z
type: task
title: '"Access method details" is labelled "Configuration details"'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 684
sprint: skdc1az
comments:
- id: 01M2A7Q99G44MW19DF4BE96HD5
  author: Steve Vine
  at: 2026-09-12T07:18:46.320334Z
  text: |-
    Done — PR #689 merged to main (dfe0843).

    The field reads "Configuration details" on the technology asset modal (internal and portal edit share it) and as the fact on the technology asset detail page; the description is unchanged. The Access card shows the text without a label, so nothing changed there. The identifier access_method_details is unchanged in the API and database. The CSV template's header row is the column key itself, and the API schema carries no description for the field, so the CSV header and the generated client stay as they are.

    Awaiting staging deploy with the rest of the sprint.
assignee: steve
label:
- improvement
priority: low
task_status: done
---
Smoke finding, 2026-09-12 (Steve): the free-text field under Access methods on the technology asset modal (COM-676) reads "Access method details"; it should read **"Configuration details"**.

* Label on the modal (`ContainerModal.tsx`), the `Fact` label on the technology asset detail page, the Access card on the detail and in the portal, the portal edit form, the CSV template column header (keep the column key `access_method_details`; only the human header changes) and the import UI's column list.
* The description stays: "How those methods are set up — 'SSO via Entra; two local break-glass admins; API keys rotated quarterly'."
* Identifier `access_method_details` unchanged in the API and database — words only. OpenAPI field description changes → run the drift script.
* Tests that assert on the old label.

**Acceptance**: no "Access method details" on any screen, in the portal, or in the CSV template header; the field still round-trips.