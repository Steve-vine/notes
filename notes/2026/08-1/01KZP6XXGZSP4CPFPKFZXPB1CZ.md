---
id: 01KZP6XXGZSP4CPFPKFZXPB1CZ
created: 2026-08-10T16:08:42.783648Z
updated: 2026-08-10T19:22:38.322895Z
type: task
title: DataDog monitor alerts don't reach the estate — 58 of 60 name no entity, while carrying the tags that would place them
project: 01KX671DATY39VW6GWK3M2T3DN
number: 638
sprint: s1rgnyx
assignee: steve
label:
- bug
priority: high
task_status: active
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

## DECIDED 2026-08-10 — and the premise changed

The original write-up assumed DataDog service entities were undiscovered and that minting them was an open question. **They are not undiscovered.** `discover_entities` (`connectors/datadog.py:676`) already mints service entities from monitor scope tags — ISE-151 added exactly that so an account without APM still contributes entities, because "an account that only alerts still names its subjects".

**The real gap is one missing naming source, read by two call sites.** There are three places a monitor can name its subject, and ISE reads two:

| Source | Read by | Kora synthetic |
| --- | --- | --- |
| the triggering **group** | `_entity_key_from_group` (`:389`) | `total` — no scope tag |
| the monitor **query** scope | `_monitor_scope` (`:377`), discovery only | `"no_query"` |
| the monitor's own **tags** | **nobody** | `service:openanswer`, `env:Test`, `env:UK` |

A synthetics monitor names its subject in neither of the two ISE reads. So the fix is: **add the monitor's own tag list as a third source in both `_entity_key_from_group` and `discover_entities`.** The Kora monitor then mints and links to `datadog:service:openanswer`, and the existing ISE-127 cross-tag harvest joins that to the Kubernetes workload wherever the tags agree. No new discovery mechanism.

**Explicitly NOT in scope** (decided, so it does not creep in):

- **Suffix-matching `service:X` against Kubernetes workload keys** the way `_resolve_unscoped_kube_keys` does for kube-scoped alerts (ISE-254, ADR 0045 §3). Tempting, but four clusters carry the same workload names, so it needs a disambiguation rule — the same one [ISE-647] must settle. Revisit after that lands.
- **`env:Test` / `env:UK`.** An alert that knows it is Test is still triaged as production. Real, but a separate concern; raise it as its own task rather than folding it in here.

**Acceptance**: a synthetics monitor tagged `service:X` mints and links to the estate entity for X; the DataDog unlinked-alert count drops from 58/60 to the handful whose monitors carry no `service:`/`host:` tag at all; and whatever remains unlinked is unlinked for a stated reason ([ISE-639]).