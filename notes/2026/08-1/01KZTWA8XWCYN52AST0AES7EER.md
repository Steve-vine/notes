---
id: 01KZTWA8XWCYN52AST0AES7EER
created: 2026-08-12T11:39:25.500168Z
updated: 2026-08-12T11:39:25.500168Z
type: task
title: 'ADR: Region joins the Business Application identity (amends ADR 0096)'
priority: high
label: brief
assignee: steve
task_status: active
project: 01KX671DATY39VW6GWK3M2T3DN
number: 662
---
A Business Application currently spans regions: `chinwag-v2.prod` includes UK and US resources. Technically correct, operationally wrong — a UK outage does not affect the US, and the blast radius says it does. The dashboard has to answer "is it UK or US".

**The decision: region enters the identity**, so `chinwag-v2.prod.uk` is a nameable thing. That was the fork — region can either *explain* impact (derivable from containment, no model change) or *select members* (identity + rules). Selecting is what a dashboard tile needs.

**What it records**

- **Identity gains a third, OPTIONAL component.** `(app_name, environment, region)`. Optional because external SaaS and the management plane are not regional; `display_name` yields `chinwag-v2.prod.uk`, or `chinwag-v2.prod` when regionless.
- **Region becomes a fourth structural role.** This REVERSES the reasoning that made `impact` an ordinary governed key (0073 §8) and that I applied to region initially — correctly, while region only explained impact. Once region selects members and enters identity, both the rule resolver and the detector need a well-known key, which is what a role is for.
- **Region becomes a first-class field on the rule**, symmetric with environment. It cannot be an extra predicate: a Business Application rule is exactly one `key:value` plus an optional environment (`rule_members`, ADR 0096 §2), unlike a tag rule which ANDs up to 10. This asymmetry is the whole reason the change is structural rather than cosmetic.
- **Key-agnostic by construction.** `Rule.resolved_key` reads the role binding at resolution time (0073 §8 — bound, not baked), so which key carries region is configuration and rebindable. What is NOT free to change later is the vocabulary LEVEL: a stored identity value `uk` does not resolve against a key spelling regions `eu-west-2`, the same two-step that stopped the detector when Environment moved to `mp-env` (ISE-660). Recoverable with a canonical alias; worth stating so nobody discovers it twice.

**Consequence to state plainly:** a regional Business Application is only as complete as the region tagging beneath it. Today `geo` is on 117 workloads, DataDog's `region` on 94 hosts (a different vocabulary), and NOTHING on databases, clusters, VPCs, buckets or load balancers. `chinwag-v2.prod.uk` would collect its UK workloads and miss its UK database, which by 0096 §3 surfaces as a rule fault — honest, but the tagging has to land alongside.