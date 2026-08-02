---
id: 01KZ0YSCNEZHEZQS5NZM285ZJP
created: 2026-08-02T10:02:22.766034Z
updated: 2026-08-02T10:28:30.933843Z
type: task
title: Dimension-scoped environment vocabularies (one env tag, two canonical homes)
project: 01KX671DATY39VW6GWK3M2T3DN
number: 472
sprint: s7j0986
blocked_by:
- 01KZ0YQ7TJ30GJKTE928QNPR98
assignee: steve
priority: high
task_status: todo
---
Resolve the `env` tag into the right dimension without re-tagging the estate.

**The discriminator already exists next to the tag.** `app:` present → the environment is an *application* environment. `project:` present → an *infrastructure* environment. Infra-pipeline resources (cluster, node, EC2) belong to the platform; app-pipeline resources (namespace, cert, ingress) exist because of an Application, and that is precisely what `app` vs `project` already says. One tag at source, read in context — nothing needs re-tagging and nothing is expressed twice to drift apart.

**Canonical value lists become dimension-scoped.** `prod = production` stays aliased exactly as it is: people use them interchangeably and always will, and correcting every resource ever created is an endless project. The same raw `env:production` therefore canonicalises to application `prod` beside `app:`, and to infrastructure `production` beside `project:`. One alias set, two homes — the whole problem stays inside ISE's resolution layer, where it is one dictionary change.

**Weak cross-check only**, on values that genuinely don't cross over: `demo`/`dev` are not infrastructure environments, `sandbox` is not an application environment. It will never catch prod/production and must not try.

**Watch**: the dictionary's current seeded aliases would collapse the two vocabularies into one. That has to stop before the two dimensions are meaningful.

Depends on the tag-roles and environments tasks.