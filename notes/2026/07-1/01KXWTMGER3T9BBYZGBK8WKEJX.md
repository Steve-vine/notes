---
id: 01KXWTMGER3T9BBYZGBK8WKEJX
created: 2026-07-19T09:17:08.952411054Z
updated: 2026-07-19T13:25:14.899380366Z
type: task
title: Directed, bounded investigation traversal
priority: high
label:
- feature
assignee: steve
task_status: done
project: 01KX671DATY39VW6GWK3M2T3DN
number: 129
blocked_by:
- 01KXWTM37WBJ1KBP8HNPW4GJNB
- 01KXWTMC1APVSXA0G9TFDPGK1T
sprint: sp5m61e
---
**Sprint 12 (spine — the payoff).** Turn blind exploration into directed traversal — the core of the cost story.

- During an Incident investigation: resolve the affected entity → walk typed edges (what it runs-on / depends-on / is-depended-on-by = blast radius) → hand the AI investigator a **scoped evidence plan** instead of many exploratory tool round-trips.
- Wire into the diagnose/investigate path (ADR 0024); feed the traversal + reached entities' context as directed input.
- Integration tests: an investigation on a DataDog service traverses to its K8s workload via resolved aliases.

Depends on typed edges + the signal→entity join. This is "resolve-during-investigation," the third leg of the Canon's load-bearing spine.