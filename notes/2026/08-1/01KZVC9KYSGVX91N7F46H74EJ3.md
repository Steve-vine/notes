---
id: 01KZVC9KYSGVX91N7F46H74EJ3
created: 2026-08-12T16:18:41.2412Z
updated: 2026-08-12T16:19:30.130721Z
type: task
title: A dashboard tile can roll up a Business Service
project: 01KX671DATY39VW6GWK3M2T3DN
number: 674
sprint: sdshnf8
blocked_by:
- 01KZVC99FJPV1T3TK3FQPC9XNY
assignee: steve
label:
- feature
priority: medium
task_status: backlog
---
The top of the three-layer estate reaches the wall. Stacks on the Business Application task.

A Business Service has **no table and no dependency walk of its own** — it is `Entity(type="business-service")` plus outgoing `composes` edges with `resolution="asserted"` (`business_services_api.py:131-165`). So:

**Resolution** — `business-service` → for each composed Business Application, the same union of direct + inferred that task 3 built. Reuse that code path per BA rather than writing a second walk; a Business Service and its Business Applications must never disagree about the same failure. De-dup across BAs is the existing `OrderedDict` (two BAs on one shared database contribute it once).

**Its own emptiness reason**: a Business Service that composes nothing is `unknown` with a reason naming *that* — the Business Services page already explains this prerequisite (ISE-657), and the tile must not send the operator to look for rules that live a layer down. A Business Service composing only Business Applications whose rules all match nothing is a different sentence again.

**Deliberately not done here**: `non_customer_facing` (`business_services_api.py:50-53`) does not affect tile colour. It is a composition judgement, not a signal — and colour comes from present signals only.

**UI**
- The Sources picker gains a **Business Services** group; the API's accepted types widen to include `business-service`.
- Tile source badges show the kind, as in task 3.

**Tests** — a BS-backed service goes red from a failure under one of its BAs' dependencies; an entity shared by two composed BAs counts once; a BS composing nothing yields its own `unknown` reason; a service pointing at both a BS and one of its BAs counts each entity exactly once (this is the double-count trap, and it is worth its own test).