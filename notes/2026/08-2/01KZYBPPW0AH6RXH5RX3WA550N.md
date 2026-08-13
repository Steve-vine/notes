---
id: 01KZYBPPW0AH6RXH5RX3WA550N
created: 2026-08-13T20:06:04.928366Z
updated: 2026-08-13T20:07:04.989461Z
type: task
title: The entity picker shows only a name, so six identical rows are six different clusters
project: 01KX671DATY39VW6GWK3M2T3DN
number: 696
sprint: sevhjex
assignee: steve
label:
- bug
priority: high
task_status: backlog
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
