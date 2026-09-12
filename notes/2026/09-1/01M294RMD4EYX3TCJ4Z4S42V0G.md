---
id: 01M294RMD4EYX3TCJ4Z4S42V0G
created: 2026-09-11T21:07:50.308807Z
updated: 2026-09-12T07:00:16.437333Z
type: task
title: Modal field rows line up when one field has a description — technology asset, data asset and Add schedule modals
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 679
sprint: skdc1az
comments:
- id: 01M29C84ZXWQH868KGG58JGCA4
  author: Steve Vine
  at: 2026-09-11T23:18:38.845503Z
  text: |-
    Done — PR #687 merged to main.

    One shared treatment: a FieldRow wrapper (a CSS grid whose columns are the fields and whose rows are label / description / input / error, each field a subgrid), so every input in a row sits level with its neighbours whether or not one has a description. Descriptions stay above the input; nothing is padded per field. Applied to all eight rows across the technology asset, data asset and Add/Edit schedule modals. A layout test per modal pins the structure; the screen conventions record the rule: a described field never pushes its row-mates out of line.

    Ready for smoke on staging.
assignee: steve
label:
- improvement
priority: high
task_status: done
---
Smoke finding, 2026-09-11 (Steve, revised): field descriptions **stay above the input**, where Mantine puts them. The problem is only that a described field is taller than its undescribed neighbour, so the two inputs in one row sit at different heights (Status "Whether it is live or still being built." next to Environment on the technology asset modal; the same on the data asset modal; the same on Access ▸ Recertification's **Add schedule** modal).

**The fix is one shared treatment, not per-field padding**
* A row of fields reserves the label + description block at the same height for every field in it, so inputs sit level and labels sit level. Two acceptable mechanisms — pick one and use it in all three modals:
  1. every field in a row carries a description (write the missing ones — a one-line description per field is the house style anyway, *A screen does not explain itself* notwithstanding: these are field hints, not screen prose); or
  2. a small `FieldRow` wrapper that renders each child in a CSS grid with `grid-template-rows: auto 1fr` (label+description block, then input) so the input row aligns across columns regardless of description presence.
  Prefer 2 if any field genuinely has nothing to say; it also survives the next modal.
* Applies to: `ContainerModal` (technology asset), `DataAssetModal`, and the recert **Add / Edit schedule** modal. Audit the other inventory rows (Criticality/RTO/RPO, Hosting/Detail, Review interval/Supplier) while there.
* Do **not** change `inputWrapperOrder` — descriptions remain above the input.
* A screen-conventions note (`brief/information-architecture.md`) recording the rule: *a described field never pushes its row-mates out of line*.

Tests: a layout test per modal asserting the inputs in an affected row share the same top offset (or that every field in the row renders a description slot).

**Acceptance**: on all three modals, every input in a row sits level with its neighbours with the descriptions still above the inputs.