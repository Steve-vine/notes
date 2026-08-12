---
id: 01KZRTW9HN1F8A9E7XRV3MPBZ6
created: 2026-08-11T16:35:49.941741Z
updated: 2026-08-12T07:55:12.92076Z
type: task
title: 'Business Application: define with a list of tag rules'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 654
sprint: sj9fsph
comments:
- id: 01KZSC776HH3ECKC9K9K4XVBZ6
  author: Steve Vine
  at: 2026-08-11T21:38:53.777249Z
  text: |-
    Done — PR #606, merged to main as 6211cea. Migration 0129.

    `predicates` → `rules`, each `{id, role|key, value, environment}`, resolved separately and unioned. Within a rule the predicates still AND — that is what keeps a rule selective; across rules they union, which is what the old shape could never do.

    A rule may name a **role** (rebinding re-derives it) or **any governed key**. Both were needed, exactly as the design found: the Platform role is estate-grained so it can never select one database, and `crossplane-name:` can with no retagging.

    **The environment dimension is now stated on the rule**, not inferred from each matched entity's sibling tags — same root cause as the empty layer itself, since inference only ever worked for an entity carrying both families and none does.

    **Per-rule faults turned out to be more necessary than the brief implies.** Once membership unions, a Business Application whose database rule went dark still has its workloads, so it is *not* empty — the old whole-Application check would report nothing at all. It's a worse blind spot than the one it replaces, not just a vaguer one. `test_one_healthy_rule_does_not_mask_a_broken_sibling` pins it, and the faulty-rule count is surfaced in the **list**, not only the detail page, because that is where the union hides it.

    Observations are keyed on a stable rule id so reordering or editing a sibling doesn't resolve one fault and raise an identical one beside it. "The role is unbound" is told apart from "nothing carries that tag" — different fixes.

    One design change beyond the brief: **`apply_membership` no longer requires the Application role at all.** A Business Application defined entirely by keyed rules resolves perfectly well without it, and only rules that actually name the role fault when it's unbound. Requiring it globally would have made the keyed-rule escape hatch useless on exactly the estates that need it.

    UI: rule editor with a role-or-key selector, live match count per rule, fault marker with the reason in words, keys chosen from the governed vocabulary (a mistyped key is a rule that silently matches nothing forever). The last rule can't be removed — a Business Application with no rules composes nothing and reads as broken; removing it is a different act with its own button.

    Migration 0129 converts a flat list to one rule per non-environment predicate — a deliberate **widening**, and the honest direction: the old conjunction matched nothing, so a union can only add members, each shown with the rule that claimed it. Converted rules stay **keyed, never promoted to a role** — calling a stored key "the Application role" would let a later rebinding silently redefine membership nobody touched.

    Two self-inflicted CI reds worth recording: I'd been running `ruff check src/` and `mypy src/`, but CI runs `ruff check .` and bare `mypy` — which cover `migrations/` and `tests/`. Both caught real errors I'd have shipped.
- id: 01KZTFFQMR8VFBVXZC20K2CQRS
  author: Steve Vine
  at: 2026-08-12T07:55:12.920492Z
  text: |-
    **Reopened.** I marked this done against a requirement it didn't meet: the brief's UI line reads "create a Business Application, add / edit / remove rules", and I built only the rule editor. There is no `POST` on the API and no New button on the page — the sole way to create one is to confirm a proposal.

    That's not a design constraint I ran into, it's an omission. ADR 0073 §6 says existence is *authored*; confirming a proposal is one door to that, not the only permitted one, and ADR 0096 doesn't narrow it. The gap has a real consequence: a Business Application whose members carry no `app:` tag can never be proposed, so today it can never exist at all.

    Building `POST /api/v1/business-applications` plus a New Business Application modal now, as a fix-forward on main.
assignee: steve
label:
- feature
priority: high
task_status: active
---
Membership becomes a **list of rules** instead of one conjunctive predicate, so a Business Application can span compute and infrastructure and a shared database can belong to several.

**Backend**
- `Application.predicates` (flat list) → list of rule groups (JSONB). Migration wraps each existing list as one group — zero rows today, so it is a shape change only.
- `member_ids()` already resolves one conjunction — call it per rule and **union** the results. (Note: `matching_entity_ids` ANDs its predicates — `tag_rules.py:65` — so rules must be evaluated separately, not concatenated.)
- `apply_membership()` unchanged: it reconciles whatever `member_ids` returns, and already protects `asserted` edges from being retracted by a sync (`applications.py:355`).
- **Per-rule validity**: a rule resolving to zero live entities raises an Observation naming the rule. Replaces the whole-Application emptied Observation.
- A rule is `{role: application|platform, or any governed key} + value + environment`; the environment dimension follows the rule's role.
- `detect_candidates()` unchanged — still proposes a single-rule Business Application from an (app, env) pair as a seed; the operator adds the rest.

**UI** (Business Applications page): create a Business Application, add / edit / remove rules, with each rule's live match count and a fault marker on any rule matching nothing.

**Estate prerequisites, known and expected to surface as rule faults**
- No entity carries both `app:` and `env:` today, so the seeded application-role rule matches nothing until workloads gain `env:`.
- Selecting a single database works **today** via `crossplane-name:` — already sitting in the proposals queue as an unknown-key mapping proposal covering 49 entities. Confirm it and rules can name one RDS instance with no retagging.