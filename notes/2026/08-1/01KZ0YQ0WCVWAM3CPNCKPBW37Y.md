---
id: 01KZ0YQ0WCVWAM3CPNCKPBW37Y
created: 2026-08-02T10:01:05.164938Z
updated: 2026-08-02T10:06:56.249565Z
type: task
title: Entity types reshaped for the three layers (+ migration)
project: 01KX671DATY39VW6GWK3M2T3DN
number: 463
sprint: s7j0986
blocked_by:
- 01KZ0YPSH1HNW638H24A56D6FC
assignee: steve
label: null
priority: high
task_status: todo
---
Make `ENTITY_TYPES` express the three layers, and resolve the collisions the model exposed.

- **`application` → `app-registration`.** The 1,782 rows currently typed `application` are EntraID app registrations — identity objects an integration owns, i.e. Resources. Rename them so *Application* is free for the middle layer.
- **New types**: `application` (new meaning) and `business-service`.
- **`service` splits.** It holds both DataDog APM services and Kubernetes Services, which sit in different layers. Kubernetes Services are Resources; DataDog APM services stop being entities entirely (see the source-of-record task).
- **`third-party` retires.** Cloudflare, Twilio and Twingate are Applications; external-ness is an attribute — who operates it — not a type. Status-page service entities move to `application` with an "operated by someone else" attribute.
- **Layer mapping**: each entity type belongs to exactly one layer, derived from the type rather than stored per row.

Watch: renaming `application` and introducing `application` with a new meaning in one migration needs the rename to land first. ENTITY_TYPES changes redden the OpenAPI snapshot check on their own branch (the EntraID sprint gotcha) — regenerate on this branch.

**Acceptance**: migration applies cleanly against a populated DB (not just zero-to-head — the ISE-459 lesson); no entity is left on a retired type; estate filters and icons cover the new types.