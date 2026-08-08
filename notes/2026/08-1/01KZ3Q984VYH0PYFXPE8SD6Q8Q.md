---
id: 01KZ3Q984VYH0PYFXPE8SD6Q8Q
created: 2026-08-03T11:48:57.115925Z
updated: 2026-08-08T08:17:39.829941Z
type: task
title: 'Pack lifecycle: update, remove, State-toggle conformance'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 507
sprint: syte7bx
assignee: steve
label: null
priority: medium
task_status: active
---
Updating a pack to a new version re-validates and takes effect on the next sync; removing a pack disables its instances cleanly (entities age out via normal estate lifecycle, never torn down). ADR 0072 conformance: pack-driven sync/detection/evidence all gate on `System.enabled` with the standard regression-test pattern. Includes the pack-version audit trail.