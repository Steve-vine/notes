---
id: 01KZ0YSCNEZHEZQS5NZM285ZJP
created: 2026-08-02T10:02:22.766034Z
updated: 2026-08-05T13:39:36.167819Z
type: task
title: Dimension-scoped environment vocabularies (one env tag, two canonical homes)
project: 01KX671DATY39VW6GWK3M2T3DN
number: 472
sprint: s7j0986
blocked_by:
- 01KZ0YQ7TJ30GJKTE928QNPR98
comments:
- id: 01KZ14TEHXE00EJY8FCP2MPFS8
  author: Steve Vine
  at: 2026-08-02T11:47:48.9253Z
  text: |-
    Built and up for review — PR #404 (feature/ise-472-dimension-scoped-env), merged to staging. Stacked on #403 (migration 0086 revises 0085); merge order #402 → #403 → #404.

    - tag_value.dimension (application/infrastructure/NULL): the same raw env:production canonicalises to application prod beside app: and infrastructure production beside project:. One alias set, two homes; nothing re-tagged.
    - The Watch case handled: dimensioned values never enter the blind value map, so the two vocabularies can no longer collapse — env:Production and env:prod stay unlinked pool rows (which one is canonical depends on the entity, and a pool row spans entities). New Dictionary API: resolve_dimensioned, dimension_conflict (weak cross-check: fires on demo/dev-beside-project and sandbox-beside-app, structurally silent on prod/production), environment_dimension (sibling-role-key discriminator, None on both/neither — never guessed).
    - Consumers made dimension-aware: compliance no longer mislabels recognised dimension-scoped spellings as unlisted; tag remediation plans through the entity's own dimension (env:prod beside project: now corrects to production) and refuses honestly when the exactly-one-of rule is broken.
    - Seed env vocabulary reshaped (adds demo/sandbox/production); migration 0086 re-homes an installed dictionary's values on the environment-role-bound key and inserts the missing homes, cross-aliasing prod/production.
    - Mechanism tests that used env as their example (badge/cloud/rules/unmapping/compliance/api/impact) re-pointed at dimensionless keys so what they test survives. 6 new dimension tests + populated 0086 migration test. All gates green both sides.
assignee: steve
priority: high
task_status: done
---
Resolve the `env` tag into the right dimension without re-tagging the estate.

**The discriminator already exists next to the tag.** `app:` present → the environment is an *application* environment. `project:` present → an *infrastructure* environment. Infra-pipeline resources (cluster, node, EC2) belong to the platform; app-pipeline resources (namespace, cert, ingress) exist because of an Application, and that is precisely what `app` vs `project` already says. One tag at source, read in context — nothing needs re-tagging and nothing is expressed twice to drift apart.

**Canonical value lists become dimension-scoped.** `prod = production` stays aliased exactly as it is: people use them interchangeably and always will, and correcting every resource ever created is an endless project. The same raw `env:production` therefore canonicalises to application `prod` beside `app:`, and to infrastructure `production` beside `project:`. One alias set, two homes — the whole problem stays inside ISE's resolution layer, where it is one dictionary change.

**Weak cross-check only**, on values that genuinely don't cross over: `demo`/`dev` are not infrastructure environments, `sandbox` is not an application environment. It will never catch prod/production and must not try.

**Watch**: the dictionary's current seeded aliases would collapse the two vocabularies into one. That has to stop before the two dimensions are meaningful.

Depends on the tag-roles and environments tasks.