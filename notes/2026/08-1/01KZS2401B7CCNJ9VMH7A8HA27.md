---
id: 01KZS2401B7CCNJ9VMH7A8HA27
created: 2026-08-11T18:42:22.379011Z
updated: 2026-08-11T19:20:56.395165Z
type: task
title: Environment gaps is 97% Entra security groups — `part-of` is doing placement and membership at once
project: 01KX671DATY39VW6GWK3M2T3DN
number: 658
comments:
- id: 01KZS4AKTB4QFXDKXAMN65W22C
  author: Steve Vine
  at: 2026-08-11T19:20:56.395054Z
  text: |-
    **Option 1 shipped and deployed 2026-08-11** — PR #602, main `0de49e6`, staging verified. The list now reads **8**, down from 238, and every row is a real platform: 6 networks and 2 clusters.

    ```
    network vn-MerakiAzureEuro1            missing (project, env)
    cluster g5                             missing (project, env)
    network vnt-mp-prd-uks-teamscall       missing (project, env)
    network vn-twingate                    missing (project, env)
    network vnet-scepman-ijlqj2u5sf6jo     missing (project, env)
    cluster k8-mp-dev-uks-aiv2             missing (project, env)
    network vnt-mp-prd-uks-teamsbot        missing (project, env)
    network vnt-mp-prd-uks-tti             missing (project)
    ```

    **The second half mattered more than the noise, and it is fixed too.** An environment could inherit *along a membership edge*: a user in "Production Admins" resolved to infrastructure environment `production` — a confident claim about where someone runs, derived from what they can access. Pinned by a test, and confirmed to fail before the change (`ResolvedEnvironment(value='production', … inherited=True)` on the user).

    **This task stays open for the model change.** What shipped is a deny-list and will be wrong again for the next identity-shaped type. The two options that stop it recurring are unchanged:

    - **Allow-list of types that can BE a platform** (cluster, network, account, subscription, vpc…). Fails safe as new entity types arrive — a new type is not a platform until someone says it is. My preference, and it is small.
    - **A separate `member-of` edge type.** The honest model, since `part-of` is genuinely carrying placement and membership at once; needs a migration for existing edges.

    Also worth noting now that the list is readable: **7 of the 8 are missing BOTH `project` and `env`**, so this is not a tagging near-miss — those platforms have never been tagged at all. That is estate work, not code.
assignee: steve
label: bug
priority: medium
task_status: backlog
---
Reported by Steve 2026-08-11: Estate shows **"238 platform roots state no infrastructure environment"**, and almost all of them are Azure security groups that would never carry a tag.

Verified on staging, and the number lands exactly:

| Root type | Missing env | Total roots |
| --- | --- | --- |
| **identity-group** | **230** | 230 |
| network | 6 | 14 |
| cluster | 2 | 8 |
| | **238** | |

**8 actionable rows are buried in a list of 238 — a 97% noise rate.** That is precisely what `untagged_roots` was written to prevent; its own docstring says *"four untagged clusters is an actionable list; four thousand untagged resources is not."*

**Cause.** `untagged_roots` (`environments.py:206`) defines a root as *"every cluster, plus anything that contains others (`part-of` target) while sitting under nothing itself"*. An EntraID security group has **20,390 `user` entities `part-of` it** and sits under nothing, so all 230 qualify. `NON_CONTAINMENT_TYPES = ("group", "application", "business-service")` excludes the tag-derived lens and the asserted layers, but `identity-group` is a real discovered entity type (ISE-388) and was never in that list.

**The underlying defect is one edge type doing two jobs.** `part-of` currently expresses both:

- **placement** — a workload is *in* a namespace is *in* a cluster. Environment inherits down this, which is the whole point of ADR 0073 §7.
- **membership** — a user is *in* a security group. Nothing about location, and an environment must never inherit along it.

This is the same shape as [ISE-636], where `kind` was asked to carry a distinction it did not hold. Here `part-of` is.

**Not caused by Sprint 59.** `identity-group` arrived with ISE-388 (EntraID discovery); `NON_CONTAINMENT_TYPES` was set by ISE-465 and its contents have never changed — ISE-647 renamed it from `_NON_CONTAINMENT_TYPES` to make it importable and altered nothing else. Verified with `git log -S`. The list has been wrong since the two features met.

**Options**

1. **Add `identity-group` to `NON_CONTAINMENT_TYPES`.** Two-line fix, removes 230 of 238 rows immediately. Cheap and right, but it patches the symptom and the next identity-shaped type repeats it.
2. **Distinguish placement from membership at the edge.** Either a separate `member-of` edge type, or a rule that containment only walks between types that can physically contain one another. Correct, larger, and needs a migration for existing edges.
3. **Restrict roots to types that can BE a platform** (cluster, network, account, subscription, vpc…) rather than excluding a blocklist. Inverts the rule from deny-list to allow-list, which fails safe as new entity types arrive — a new type is not a platform until someone says it is.

Option 1 is worth doing immediately regardless, because the surface is unusable today. Option 3 is the one that stops this recurring; option 2 is the honest model and the biggest change.

**Check while there**: the same `NON_CONTAINMENT_TYPES` governs `environments_of`, so a **user may currently inherit an infrastructure environment from a security group** — a wrong answer rather than merely a noisy list. It also governs `learning.containment_of` (ISE-647), where shared security-group membership could be used to "disambiguate" a same-named entity, which would be an inference from the wrong relationship entirely.

**Acceptance**: the environment-gaps list contains only things that can actually carry a platform environment; the count reflects real gaps (8 today, not 238); no entity inherits an environment through a membership edge.