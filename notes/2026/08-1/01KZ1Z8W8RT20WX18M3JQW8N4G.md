---
id: 01KZ1Z8W8RT20WX18M3JQW8N4G
created: 2026-08-02T19:30:04.696217Z
updated: 2026-08-02T19:30:04.696217Z
type: task
title: Operator can rename an estate entity (pin a display name)
assignee: steve
task_status: backlog
label: improvement
priority: medium
project: 01KX671DATY39VW6GWK3M2T3DN
number: 493
---
An entity's display name is decided by a race at first discovery: the first owner to claim it names it, and the oldest owning alias keeps naming rights forever (ISE-471). Seen live 2026-08-02: env-staging-us k8s-synced seconds after AWS, so its cluster is permanently named `cluster-envstagingus-ekscluster` while its siblings (k8s-synced first) read `env-staging-uk` / `mgnt-staging-uk`. Deterministic, but the operator has no way to correct it — the AWS alias stays oldest forever.

**Change:** let an operator set (pin) an entity's display name in the UI. A pinned name is human-asserted and outranks the namer rule; clearing the pin returns naming to the ISE-471 owner rule. Connectors never overwrite a pinned name.

- Entity detail page gets an edit affordance on the name (admin only), audit-logged.
- Consider surfacing "named by {integration}" next to the name so the provenance is visible (display_scopes already derives similar read-time context).