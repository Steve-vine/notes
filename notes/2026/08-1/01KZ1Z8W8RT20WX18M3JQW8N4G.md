---
id: 01KZ1Z8W8RT20WX18M3JQW8N4G
created: 2026-08-02T19:30:04.696217Z
updated: 2026-08-06T08:14:59.720888Z
type: task
title: Operator can rename an estate entity (pin a display name)
project: 01KX671DATY39VW6GWK3M2T3DN
number: 493
comments:
- id: 01KZ2311DX4GJKXWDFDG7GD9X1
  author: Steve Vine
  at: 2026-08-02T20:35:42.141095Z
  text: |-
    Built on feature/ise-493-entity-rename, PR #431 to main — CI fully green and deployed to staging alongside ISE-491.

    entity.name_pinned_by (migration 0089): NULL = ISE-471 namer rule; set = who pinned the name. Connectors never rename a pinned entity, and an automatic merge carries a pin from the folded entity onto the survivor. PUT /entities/{id}/name (admin, audited) pins or clears; the detail read reports name_pinned_by and named_by (the integration currently holding naming rights). Entity page header: pencil rename (admin), Pinned badge + Unpin, and a "named by {integration}" caption when unpinned.

    Combined API snapshot verified against staging (both open branches touch the API — regen produced no drift). Staging-merge conflict in test_discovery.py (ISE-491 + ISE-493 tests, same location) resolved keeping both; 15/15 pass.

    Smoke test on staging: open the cluster-envstagingus-ekscluster entity → pencil → rename to env-staging-us → Pinned badge appears; confirm it survives the next AWS sync, and Unpin returns naming to AWS on the sync after that.
- id: 01KZ25ESZFAKJD4MA0TF4YPX0A
  author: Steve Vine
  at: 2026-08-02T21:18:10.41491Z
  text: 'Smoke passed. RELEASED to main 2026-08-02: PR #431 merged (main d21ee4a, migration 0089), staging reset to main, branch deleted. Release note: #431 needed a conflict-resolution merge of main after #430 landed (both branches added tests at the same spot in test_discovery.py — staging''s resolution reused verbatim), and the branch-protection policy required the re-run PR checks to go green before the merge was allowed.'
assignee: steve
priority: medium
task_status: done
---
An entity's display name is decided by a race at first discovery: the first owner to claim it names it, and the oldest owning alias keeps naming rights forever (ISE-471). Seen live 2026-08-02: env-staging-us k8s-synced seconds after AWS, so its cluster is permanently named `cluster-envstagingus-ekscluster` while its siblings (k8s-synced first) read `env-staging-uk` / `mgnt-staging-uk`. Deterministic, but the operator has no way to correct it — the AWS alias stays oldest forever.

**Change:** let an operator set (pin) an entity's display name in the UI. A pinned name is human-asserted and outranks the namer rule; clearing the pin returns naming to the ISE-471 owner rule. Connectors never overwrite a pinned name.

- Entity detail page gets an edit affordance on the name (admin only), audit-logged.
- Consider surfacing "named by {integration}" next to the name so the provenance is visible (display_scopes already derives similar read-time context).