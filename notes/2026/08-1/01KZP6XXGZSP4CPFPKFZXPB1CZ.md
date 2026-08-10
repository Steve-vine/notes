---
id: 01KZP6XXGZSP4CPFPKFZXPB1CZ
created: 2026-08-10T16:08:42.783648Z
updated: 2026-08-10T16:08:42.783648Z
type: task
title: DataDog monitor alerts don't reach the estate — 58 of 60 name no entity, while carrying the tags that would place them
assignee: steve
label: bug
priority: high
task_status: backlog
project: 01KX671DATY39VW6GWK3M2T3DN
number: 638
---
Found 2026-08-10 walking the Service Desk triage path. An incident's entity comes solely from its finding (`api/v1/issues.py:302,338` — there is no `entity_id` on `issue`). On staging, **58 of 60 DataDog alerts have `entity_id IS NULL`**, so the incidents they raise name nothing in the estate.

Unlinked findings by source (staging, 2026-08-10):

| Source | Signals | Unlinked |
| --- | --- | --- |
| datadog alerts | 60 | **58** |
| entraid observations | 73 | **73** |
| m365 observations | 13 | **13** |
| freshservice observations | 8 | **8** |
| azure alerts | 8 | 7 |
| cloudflare / github alerts | 2 | 2 |
| kubernetes observations | 1650 | 0 |
| entraid + m365 alerts, statuspage | 45 | 0 |

**Why DataDog misses.** `_entity_key_from_group` (`connectors/datadog.py:389`) resolves an entity *only* from the triggering **group**'s scope tags — `service:`, `kube_deployment`+`kube_namespace`, or `host:`. A synthetics monitor groups by `total` and `pl:<private-location>`, neither of which is a scope tag, so it returns None. Meanwhile the **monitor's own tags are already fetched and stored**: the Kora finding's `details.tags` contains `service:openanswer`, `env:Test`, `env:UK`. The linker never looks at them. (Same shape as the Sprint 52 finding: connectors parse a payload then discard the field that mattered.)

**But reading the tag is not sufficient, and this is the load-bearing part.** There is exactly **one** `datadog:service:*` alias in the entire estate — DataDog's 263 aliases are hosts and clusters. There is no `datadog:service:openanswer` entity to link to, though the Kubernetes estate has an `openanswer` namespace with four workloads (`openanswer-api-app`, `openanswer-app`, `openanswer-api-gw-app`, `operatorservice-app`). So this is two faults:

1. **The linker ignores the monitor's own tags** — group-only resolution, when the tags place the alert perfectly well.
2. **DataDog service entities are effectively undiscovered** — so even a tag-aware linker would have nothing to point at. Whether the answer is minting DataDog service entities, or resolving `service:` against existing k8s workloads the way `_resolve_unscoped_kube_keys` already resolves unscoped workload keys (ISE-254, ADR 0045 §3), is the decision to settle.

The `env:` tags are worth a look too — an alert that knows it is `env:Test` should not be triaged as production.

**Acceptance**: a synthetics monitor tagged `service:X` links to the estate entity for X; the DataDog unlinked-alert count drops from 58/60 to the handful with genuinely no locatable subject; and whatever remains unlinked is unlinked for a stated reason (see the companion task).