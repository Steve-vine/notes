---
id: 01KZDRKCSS8EDQE2JEMDXDZ7K1
created: 2026-08-07T09:24:22.457352Z
updated: 2026-08-07T10:09:35.753474Z
type: task
title: EntraID discovery stamps expiry dates onto entities (app-registration credentials, user passwords)
project: 01KX671DATY39VW6GWK3M2T3DN
number: 594
sprint: snk16ew
assignee: steve
label: null
priority: medium
task_status: active
---
The EntraID connector already reads app-registration credential expiry for the threshold ladder (`_credential_expiry_findings`) but throws the dates away — nothing queryable remains. Arbitrary-window questions ("expiring in the next 90 days") need the dates on the entities themselves.

- `discover_entities`: stamp earliest credential expiry (secret + certificate, whichever is sooner) onto `app-registration` entity attributes.
- Users: stamp password expiry if Graph exposes it for the tenant's policy (verify — may be `lastPasswordChangeDateTime` + policy-derived); if genuinely unavailable, record that finding on the task and descope users.
- Attributes render on the existing entity page for free.

Screen: entity detail shows the expiry; Assist answers the expiry questions via estate query v2. No migration expected (JSONB attributes).