---
id: 01KZ0YQ0WCVWAM3CPNCKPBW37Y
created: 2026-08-02T10:01:05.164938Z
updated: 2026-08-07T08:34:58.99781Z
type: task
title: Entity types reshaped for the three layers (+ migration)
project: 01KX671DATY39VW6GWK3M2T3DN
number: 463
sprint: s7j0986
blocked_by:
- 01KZ0YPSH1HNW638H24A56D6FC
comments:
- id: 01KZ11S81YAGZBQVN4FVFXH50D
  author: Steve Vine
  at: 2026-08-02T10:54:43.774001Z
  text: |-
    Built and up for review — PR #402 (feature/ise-463-entity-types-three-layers), merged to staging.

    - ENTITY_TYPES reshaped per ADR 0073: application → app-registration (rename lands first in the migration), new application (middle layer) + business-service, service split (kubernetes-service for K8s; DataDog's APM view keeps service until ISE-469), third-party retired → application + operated_by:"external" attribute. entity_layer() derives the layer from the type; both entity read schemas expose `layer`.
    - Migration 0084 moves rows in dependency order, splits service by the Kubernetes alias join, and also rewrites the two JSONB hiding places: pending proposal payloads (a stale third-party payload would violate the constraint at confirm time — plus a runtime guard in proposals.py) and per-System kind-dictionary entries (invalid entity_type fails pydantic on read).
    - Mints updated: EntraID → app-registration, Kubernetes → kubernetes-service, Status Pages/M365 → externally-operated application. Frontend filter lists, kind-mapping choices, graph icons and the entity page follow; Externally operated badge replaces the third-party special-case.
    - Populated-DB migration test added (the ISE-459 lesson) covering every data path. 137 focused + 353 subset backend tests green, mypy/ruff clean; 479 vitest, build, prettier clean. API types regenerated on this branch (the EntraID-sprint gotcha).
assignee: steve
priority: high
task_status: done
---
Make `ENTITY_TYPES` express the three layers, and resolve the collisions the model exposed.

- **`application` → `app-registration`.** The 1,782 rows currently typed `application` are EntraID app registrations — identity objects an integration owns, i.e. Resources. Rename them so *Application* is free for the middle layer.
- **New types**: `application` (new meaning) and `business-service`.
- **`service` splits.** It holds both DataDog APM services and Kubernetes Services, which sit in different layers. Kubernetes Services are Resources; DataDog APM services stop being entities entirely (see the source-of-record task).
- **`third-party` retires.** Cloudflare, Twilio and Twingate are Applications; external-ness is an attribute — who operates it — not a type. Status-page service entities move to `application` with an "operated by someone else" attribute.
- **Layer mapping**: each entity type belongs to exactly one layer, derived from the type rather than stored per row.

Watch: renaming `application` and introducing `application` with a new meaning in one migration needs the rename to land first. ENTITY_TYPES changes redden the OpenAPI snapshot check on their own branch (the EntraID sprint gotcha) — regenerate on this branch.

**Acceptance**: migration applies cleanly against a populated DB (not just zero-to-head — the ISE-459 lesson); no entity is left on a retired type; estate filters and icons cover the new types.