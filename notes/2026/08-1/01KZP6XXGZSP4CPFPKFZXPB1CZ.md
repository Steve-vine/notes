---
id: 01KZP6XXGZSP4CPFPKFZXPB1CZ
created: 2026-08-10T16:08:42.783648Z
updated: 2026-08-10T23:11:43.077074Z
type: task
title: DataDog monitor alerts don't reach the estate — 58 of 60 name no entity, while carrying the tags that would place them
project: 01KX671DATY39VW6GWK3M2T3DN
number: 638
sprint: s1rgnyx
comments:
- id: 01KZPK3K81NDD0WB7NWGH0SG9H
  author: Steve Vine
  at: 2026-08-10T19:41:31.77751Z
  text: |-
    Built and merged to main 2026-08-10 — `5101ead` (PR #582).

    Implemented exactly as decided: the monitor's own tag list becomes a third naming source, read in two places.

    - `_entity_key_from_group(group, monitor_tags)` reads group → then the monitor's tags, most- to least-specific within each. **The group stays first**, because it is the scope that FIRED: a monitor tagged `service:checkout` but grouped by host is about the host that fired, and reversing that would collapse every per-host alert onto one service entity. There is a test pinning that ordering.
    - `_monitor_scopes` reads the tags too, so the entity the key names is actually minted. Doing only the first half would have the linker name a key that resolves to nothing — the failure would have looked like the fix working.

    Tags stay tag-BLIND for discovery (`tags_known=False`, ISE-204): naming a thing is not enumerating what it is tagged with, and claiming otherwise would strip the service's real tags on the next set-replace.

    Tests: a synthetics-shaped monitor (`no_query`, grouped `total`) tagged `service:openanswer` resolves to `datadog:service:openanswer`; the firing group outranks the monitor's tags; a monitor whose tags name nothing (`env:`, `team:`) still resolves to no entity — reading tags must not invent a subject. 93 pass across the two connector modules. Full CI green.

    **Both deferrals held** — no k8s suffix-matching (waits on [ISE-647]'s disambiguation rule), no `env:` handling (now [ISE-649], which turned out to be a deeper problem than expected: signal and entity env values are entirely disjoint vocabularies).

    Not yet verified against live DataDog. The staging check after deploy is the 58/60 unlinked count dropping — and the two Kora incidents gaining an entity, which is also what makes [ISE-639]'s panel stop showing on them.
- id: 01KZPZ4EZ5KQJ5KMGHWWXREW8P
  author: Steve Vine
  at: 2026-08-10T23:11:43.076948Z
  text: |-
    **Verified on staging after deploy (2026-08-10 23:10) — the fix half-works, and the acceptance criterion is NOT met. A premise I asserted in this task was wrong.**

    What did land: DataDog findings now carry the key their monitor's tags name. `monitor/112360179/total` and `…/pl:staging-uk-cluster-…` both have `entity_key = datadog:service:openanswer`, and estate-wide the count of DataDog alerts naming a subject went from **2 → 18 of 60**.

    What did not: **58 of 60 are still unlinked**, because those keys resolve to nothing.

    **Why — and this is the part I got wrong.** I wrote that "`discover_entities` already mints service entities from monitor scope tags (ISE-151)". It *returns* them; `reconcile_discovered` then **drops** them. `DataDogConnector.source_of_record = False` (`datadog.py:470`), deliberately, per ADR 0073 §3 / ISE-469:

    > "A source of record for NOTHING: DataDog holds Monitors and Alerts, and neither is a thing in the estate. Its identifiers attach as **aliases** to entities other sources own."

    So DataDog can never mint `datadog:service:openanswer`. The ISE-151 docstring describes behaviour that the later ownership rule overrode, and I read the docstring rather than the reconcile path. My own PR text warned that doing only the linker half "would have the linker name a key that resolves to nothing" — which is exactly what shipped.

    **The real blocker, measured.** The DataDog↔Kubernetes join is carried by the `tags.datadoghq.com/service` label, which Kubernetes publishes as a `datadog:service:{X}` cross key. Across the estate: **421 k8s workload aliases, exactly 1 with a `datadog:service:` key** (`chinwag-chat`). Nothing in the `openanswer` namespace carries one. The join mechanism is sound and almost entirely unpopulated.

    **Two ways forward**, raised as [ISE-651]: label the workloads (an estate change — the join working as designed), or resolve `service:X` against workloads by name (the suffix-match this task deliberately deferred, which now looks load-bearing rather than optional, and needs [ISE-647]'s disambiguation first).

    The shipped change is still worth having — 18 signals now state what they are about, and [ISE-639] turns the remaining 42 into an honest "the source named no subject" rather than a blank. But this task's acceptance is not satisfied and should not be marked Done on my say-so.
assignee: steve
label:
- bug
priority: high
task_status: review
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