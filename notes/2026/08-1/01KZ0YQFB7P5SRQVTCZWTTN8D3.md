---
id: 01KZ0YQFB7P5SRQVTCZWTTN8D3
created: 2026-08-02T10:01:19.975167Z
updated: 2026-08-05T14:25:19.415099Z
type: task
title: 'Environments: two dimensions, infrastructure environment inherited by containment'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 465
sprint: s7j0986
blocked_by:
- 01KZ0YQ0WCVWAM3CPNCKPBW37Y
- 01KZ0YQ7TJ30GJKTE928QNPR98
- 01KZ0YSCNEZHEZQS5NZM285ZJP
comments:
- id: 01KZ15HRG1NS2JW3C2ERSGB808
  author: Steve Vine
  at: 2026-08-02T12:00:32.769767Z
  text: |-
    Built and up for review — PR #405 (feature/ise-465-two-environment-dimensions), merged to staging. Stacked on #404 (migration 0087 revises 0086); merge order #402 → #403 → #404 → #405.

    - environments.py: application env is identity from the entity's own tags; infrastructure env is stated at the platform root and inherited downward by a bounded upward part-of walk that skips group/application/business-service ancestors (lenses/composition, not location). Derived on read, never stamped; unknown reported rather than guessed — including two same-depth ancestors disagreeing.
    - Customer-facing marker (migration 0087): a property of the environment vocabulary (tag_value.customer_facing), seeded true for application prod/demo, editable in Settings → Tags, exposed via Dictionary.is_customer_facing — the input ISE-468's no-test-Business-Services rule and the sharing detector will read.
    - API: EntityDetail.environments (both dimensions with inherited/stated_by); GET /entities/environment-gaps — every cluster plus anything containing others while contained by nothing, minus those stating an infra env. Bare leaves deliberately excluded: four untagged clusters, never four thousand resources.
    - UI: entity page shows both dimensions (inherited one as "inherited from g5" linking to the source; unknown stated plainly, incl. "not stated" for app env); Estate page raises the untagged-roots alert with contained counts; dictionary value editor gains the customer-facing flag/badge.
    - 7 new backend integration tests + migration test through 0087; 3 new frontend tests. All gates green both sides.
assignee: steve
label: null
priority: high
task_status: done
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