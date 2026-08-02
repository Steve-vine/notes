---
id: 01KZ0YQFB7P5SRQVTCZWTTN8D3
created: 2026-08-02T10:01:19.975167Z
updated: 2026-08-02T11:48:23.707007Z
type: task
title: 'Environments: two dimensions, infrastructure environment inherited by containment'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 465
sprint: s7j0986
blocked_by:
- 01KZ0YQ0WCVWAM3CPNCKPBW37Y
- 01KZ0YQ7TJ30GJKTE928QNPR98
- 01KZ0YSCNEZHEZQS5NZM285ZJP
assignee: steve
priority: high
task_status: active
---
Two environments wear one word, and the model only holds if neither is inferred from the other.

- **Infrastructure environment** (`sandbox`/`staging`/`production`) — which platform tier the kit sits in. A property of the Resource.
- **Application environment** (`dev`/`test`/`demo`/`prod`) — which lifecycle stage an instance serves. Part of the Application's identity.

A Demo instance on production-grade infrastructure is **correct**, not an anomaly. A Production cluster legitimately hosts `Chinwag.Prod` and `Chinwag.Demo`, while a Staging cluster hosts `Chinwag.Dev` and `Chinwag.Test`.

**The mechanism**: infrastructure environment is stated at the platform root (cluster, account, standalone EC2 — things that *are* the platform) and **inherited downward by containment**. A cert tagged `app:chinwag env:test` doesn't state where it lives; its cluster does, and the containment chain is already in the graph. Derive on read — never stamp it onto each Resource, which would just create another thing to go stale. Where no ancestor states it, report **unknown** rather than guessing.

**Environments carry a customer-facing marker.** Whether an environment is customer-facing is a property of the environment vocabulary, not a judgement re-made per Business Service. Without it the two rules that depend on it stay opinions instead of checks:

- **"There are no test Business Services"** — a Business Service composes only customer-facing Application instances (normally Production, and Demo where customers use it).
- **The sharing detector** — the real finding is **customer-facing sharing with non-customer-facing** (a Prod Application and a Dev Application on one cluster). The earlier formulation "a Resource shared across environments is a finding" was wrong: Prod + Demo on one cluster is normal.

**Acceptance**: both environments are visible on a Resource, with the infrastructure one shown as inherited and from where; each environment value is marked customer-facing or not; an untagged containment root produces a short actionable list, not thousands of unresolvable resources.

Depends on the entity-types and tag-roles tasks.