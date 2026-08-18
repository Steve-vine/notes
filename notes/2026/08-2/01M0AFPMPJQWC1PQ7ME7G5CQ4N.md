---
id: 01M0AFPMPJQWC1PQ7ME7G5CQ4N
created: 2026-08-18T13:06:50.194413Z
updated: 2026-08-18T13:06:50.194413Z
type: task
title: SCIM 2.0 provisioning endpoint — Entra pushes Compass app users
assignee: steve
task_status: todo
priority: medium
label: feature
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 249
---
Compass as a **SCIM 2.0 server** for Entra's provisioning service — assignment to the Enterprise App becomes the joiner/leaver pipeline for Compass app users (distinct from the ADR 0045 directory mirror; the ADR pins the vocabulary).

* **Surface**: `/scim/v2` router — `ServiceProviderConfig`, `Users` (POST create, GET by id + `filter=userName eq "..."` for the matching probe Entra always sends, PATCH for attribute + `active` changes, PUT replace, DELETE → deactivate) and `Groups` (create/patch membership — feeds the role-mapping resolution in the next task). Only the subset Entra's provisioning engine actually exercises — documented as such; not a general SCIM implementation.
* **Auth**: long-lived bearer token, generated in Admin, stored **hashed** (the ADR 0007 API-token pattern), rotatable with a view-once reveal; SCIM requests are outside the session/CSRF world and touch nothing else. Token named `*_token` for redaction.
* **Semantics**: create → app user with `auth_provider="entra"`, `entra_object_id` from `externalId`, no password, roles resolved from group mappings; `active=false` or unassignment → **deactivate** (login blocked, sessions revoked, record kept — ActorMixin FKs and the audit trail outlive people); reactivation supported; email/name changes patched through. Idempotent throughout — Entra retries aggressively (`userName eq` probe before create; PATCHes re-applyable).
* **Audit**: SCIM writes carry no interactive actor — stamp a synthetic "Entra provisioning" actor context so user create/deactivate events land in the activity log attributably rather than silently (differs from the worker's actorless convention deliberately: these are governance-relevant identity events).
* **Docs**: Entra-side setup in `scripts/` — Enterprise App provisioning config, tenant URL, token placement, attribute mappings (`externalId ↔ objectId`), assignment-drives-provisioning note.
* **Tests**: integration tests replaying Entra's actual call sequences (probe→create, patch-active-false, re-assign) — the provisioning engine's quirks are the spec.

Refs: ADR 0046, 0007, 0023; `models/user.py`, the TokensSection/API-token hashing precedent.