---
id: 01KZYBPPW0AH6RXH5RX3WA550N
created: 2026-08-13T20:06:04.928366Z
updated: 2026-08-14T08:49:46.529827Z
type: task
title: The entity picker shows only a name, so six identical rows are six different clusters
project: 01KX671DATY39VW6GWK3M2T3DN
number: 696
sprint: sevhjex
comments:
- id: 01KZZQD07GQ7JYCPR31N0M2QF4
  author: Steve Vine
  at: 2026-08-14T08:49:44.176041Z
  text: |-
    2026-08-13 — DONE, PR #643 merged to main and released. (Closing note added late — this was left in Active when it merged; my oversight, not a state anyone should read meaning into.)

    **It used `scope`, not a new composition.** ISE-471 had already built exactly this field — "in kube-system on cluster-envstaginguk-ekscluster", derived from the containment graph at read time, with the comment "names are not unique; scope is never baked into the name, so it rides alongside". It was being served on `EntitySummary` and simply never read. `integrations` became the fallback for entities with no containment.

    **Both traps handled.** The context went in the LABEL, not a `renderOption` alone, because Mantine filters on the label — a test types a cluster name and asserts the list narrows. Retired entities are marked rather than hidden, since filtering them out would make the only match for a name silently absent.

    **All four surfaces**, plus the MCP one the task flagged as worth checking: `get_entity`'s `ambiguous` list returned name and type only and then said "call again with the id", asking the model to choose between candidates it had been given no way to tell apart.

    **Superseded in part by ISE-698, one day later.** Smoke testing found the scope-based label was correct and far too long: at the picker's width most rows wrapped over two or three lines. The format is now `Type - Integration - Name` — shorter, one line per row, and the integration separates the same `aws-node` case this task was written for. The namespace is lost with the scope; I checked before dropping it, and no workload name on staging repeats within one integration across namespaces.

    Worth recording as a lesson rather than a regression: **the fix was right about the ambiguity and wrong about the budget.** Disambiguating cost characters, and nobody counted them against the 340px control they had to fit in.
assignee: steve
label:
- bug
priority: high
task_status: done
tech: null
---
Searching the estate to attach an entity to an incident offers a dropdown of identical rows. A workload name is only unique within a cluster and namespace, so the picker asks the operator to choose between six things it renders identically — and the wrong choice is silent, durable and attached to the SIGNAL, so it then applies to every incident that alert raises.

Reported from staging 2026-08-13.

**Cause.** `IssueDetailPage.tsx:1619` builds the option label as:

```ts
label: `${e.name} (${e.type})`
```

Name and type only. It throws away `integrations`, which is the field that actually distinguishes them and which **the API already returns** — `EntitySummary` carries `id, name, type, integrations, attributes, scope, layer, alias_count, tag_count, last_seen_at, retired_at`. The Estate list has rendered `integrations` as a column since ISE-482 ("g5 cluster, DataDog prod"). The picker simply does not read it.

**No backend change is needed.** This is a label, not a missing fact.

**Namespace alone does NOT disambiguate — the integration does.** Verified against staging:

```
name                            | ns          | system
--------------------------------+-------------+------------------------
argocd-image-updater-controller | argo-cd     | env-staging-us
argocd-image-updater-controller | argo-cd     | env-production-us-pri
argocd-image-updater-controller | argo-cd     | env-production-uk-pri
argocd-image-updater-controller | argo-cd     | env-staging-uk
aws-node                        | kube-system | mgnt-production-uk-pri
aws-node                        | kube-system | env-production-us-pri
aws-node                        | kube-system | env-production-uk-pri
aws-node                        | kube-system | env-staging-uk
aws-node                        | kube-system | env-staging-us
aws-node                        | kube-system | mgnt-staging-uk
```

`aws-node` is six rows across six clusters, all in `kube-system`. Adding the namespace would have changed nothing. Note also that `attributes->>'cluster'` is EMPTY on these rows — the cluster identity lives in the integration, not in an attribute, so anything keying off `attributes.cluster` will silently produce blanks.

**Scope — four surfaces share the defect, fix them together.** They are the same picker wearing different clothes, and fixing one leaves an operator to discover the next:

- `pages/IssueDetailPage.tsx:1619` — "Attach the entity it is about" (the reported one, and the highest-stakes: it writes to the signal)
- `components/NewIssueModal.tsx:151` — identical `${e.name} (${e.type})`
- `components/RelationshipsCard.tsx:262-275` — renders name + type as two spans
- `pages/EstateExplorerPage.tsx:142-146` — same two-span treatment

The last two already split name/type visually (name primary, type dimmed, deliberately two spans so the eye is not made to parse a `·`). Extend that pattern rather than inventing a third.

**Wanted:** every row states the integration it came from, and its namespace where it has one. Name primary; integration and namespace as dimmed secondary context.

**Two traps.**

1. **Mantine `Select` filters on `label`.** If the disambiguators are moved into `renderOption` only, the option text stops containing them and typing `env-staging-uk` matches nothing — the picker would look disambiguated while becoming less searchable than it is today. Either keep them in the label string, or set an explicit filter. Whichever, a test should type an integration name and assert the list narrows.
2. **Retired entities.** `EntitySummary` carries `retired_at`, and a retired duplicate is indistinguishable from a live one in this list. Decide whether the picker excludes retired entities or marks them; attaching a signal to a retired entity is the kind of thing that goes unnoticed for weeks.

**Worth checking while in here:** whether the same name+type collision affects the MCP `search_entities` surface, which answers the same question for Claude and would mislead in the same way.
