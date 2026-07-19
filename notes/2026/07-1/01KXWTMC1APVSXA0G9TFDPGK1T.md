---
id: 01KXWTMC1APVSXA0G9TFDPGK1T
created: 2026-07-19T09:17:04.426992476Z
updated: 2026-07-19T09:17:04.426992476Z
type: task
title: Join signals to estate entities
priority: high
label: feature
assignee: steve
task_status: backlog
project: 01KX671DATY39VW6GWK3M2T3DN
number: 128
---
**Sprint 12 (spine).** Make the entity the join key.

- Resolve each signal's **affected entity**: an Alert's `monitor/{id}/{group}` group key (ISE-116 already stores the group) and an Observation's affected infrastructure → the estate entity.
- The finding carries its affected entity, so an Alert's target, an Observation's dedup key, and evidence gathered during investigation all resolve to the **same** entity id.
- Migration (finding → entity link) + tests.

Depends on the entity model + connector entities/resolution.