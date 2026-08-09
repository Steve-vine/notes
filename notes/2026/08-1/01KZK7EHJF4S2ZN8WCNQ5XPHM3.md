---
id: 01KZK7EHJF4S2ZN8WCNQ5XPHM3
created: 2026-08-09T12:20:04.303791Z
updated: 2026-08-09T12:23:51.680511Z
type: task
title: Collapse the `server` entity type into `host` — one type for every machine
project: 01KX671DATY39VW6GWK3M2T3DN
number: 624
sprint: sesjg7z
assignee: steve
label:
- tech_debt
priority: medium
task_status: backlog
---
Decided by Steve 2026-08-09: **all servers become hosts.** The `server` entity type introduced in ISE-565 goes.

**The problem it fixes.** Today a machine nothing else knew about becomes `server`, while one ISE already had as an EC2 instance or Azure VM stays `host` and gains the in-OS attributes there. The binding is right — one machine, one entity, never a duplicate — but the TYPE ends up describing how ISE found the machine rather than what it is. Two identical Windows servers can carry different types purely because one runs on EC2.

That is discovery history leaking into the data model, and it bends every query written afterwards: "show me all machines" needs `host OR server`, tag rules keyed on type see two populations, and impact walks and dashboards have to know both.

The distinction `server` was carrying — "ISE can log into this one" — is about ISE's RELATIONSHIP to the machine, not about the machine. Relationships belong in attributes, and the attribute already exists: every managed machine carries `managed_by: servers`, which is what the in-OS facts card and the evidence path already key on. Nothing reads the type to decide behaviour.

**Cheapest now**: exactly one `server` entity exists on staging.

**Work**
- Drop `server` from `ENTITY_TYPES`; `servers.entity_data_for` mints `host`.
- Migration: retype existing `server` rows to `host`, then narrow the `entity.type` CHECK constraint. Frozen-literal pattern (the 0092 one) — never import `models.ENTITY_TYPES` into a migration.
- Regenerate the OpenAPI snapshot and api-types: `ENTITY_TYPES` is served, so it reddens on the branch (the EntraID-sprint precedent).
- Audit anything keyed on the type string — estate filters, the kind dictionary, MCP tool descriptions.
- **ADR 0084 amendment**, appended not rewritten (the 0061 precedent). The ADR currently states the mint-vs-bind type split; the amendment records that binding stands and the separate type does not, and why.

**Ordering**: land [ISE-622] first, or at least think about it together. With one machine type, the OS attribute becomes the only way to tell a Windows machine from a Linux one — 622 is what makes this collapse safe rather than lossy.

**Acceptance**: no entity carries type `server`; the estate lists every machine under one type; registering a server still binds to an existing cloud entity rather than minting a second; the in-OS facts card and server evidence are unaffected, because both key on `managed_by`.