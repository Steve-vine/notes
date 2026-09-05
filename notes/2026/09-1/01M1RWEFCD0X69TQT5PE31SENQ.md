---
id: 01M1RWEFCD0X69TQT5PE31SENQ
created: 2026-09-05T13:34:37.965575Z
updated: 2026-09-05T13:35:35.032595Z
type: task
title: A synthetic's locations are one failure, not four signals
project: 01KX671DATY39VW6GWK3M2T3DN
number: 787
sprint: s7nj09w
assignee: steve
label:
- improvement
priority: high
task_status: backlog
tech: null
---
Build ADR 0115 §6 and §7. **Deliberately its own task**: it changes a finding
key, and that exact change caused churn before (ISE-153). It must not ride inside
a larger change where a recovery burst gets attributed to the wrong thing.

**Today** ISE raises one finding per `(monitor, group)`, and a synthetic's groups
are its probe locations **plus a `total` group** that is DataDog's own verdict
across all of them. Staging:

```
monitor     title                          probe_dc   groups
112360179   Kora (UK) (Test)                      1    pl:staging-uk-…, total
11470042    callroutingtwilio - Call Routing      2    aws:eu-west-1, aws:eu-west-2, total
15216836    Twilio - api.twilio.com               3    aws:eu-west-1/2, aws:us-east-1, total
```

One Twilio failure is four signals. Once ISE-786 lands they are all attributed to
the same Business Application and price it four times.

## Scope

**Collapse (§6).** For `type: synthetics alert` **with a `total` group present**,
the per-location groups are views of one failure and raise **one** signal.
`total` is not ISE inferring an aggregate — it is DataDog publishing one, which
is why this narrows ISE-648's "only a human can tell those apart" for this source
only. `correlation_memory` remains the answer everywhere else and must not be
touched.

A synthetics monitor reporting **no** `total` group falls back to per-group
signals. Silence is not a licence to drop to zero.

**Breadth is a ratio (§7).** Where ISE states breadth it states `n of N` from the
`probe_dc` tag count, and **a small N never reduces severity**. 1 of 1 is total
failure — the Kora tests run from a single private location, and reading a low
absolute count as a probe glitch would systematically under-price exactly those.

## The hazard, and the three decisions it forces

`datadog.py`'s own comment records what happened last time this key scheme moved:

> Conflating those two is what made the finding key flip between `monitor/{id}`
> and `monitor/{id}/{group}` across syncs, which is the churn half of the same
> bug.

So the collapse is **not purely additive**. On the first sync after it ships,
every open per-location synthetic finding carries a `source_key` the connector
will no longer report.

1. **Which key the collapsed signal takes** — `monitor/{id}` (the ungrouped
   shape, matching `_UNGROUPED_GROUP` handling) or `monitor/{id}/total`. The
   former is tidier; the latter keeps group provenance and cannot collide with a
   genuinely ungrouped monitor of the same id.
2. **What happens to the open per-location rows** — left to the Differ's recovery
   sweep (correct, but any incident holding one loses its subject), or migrated
   onto the collapsed key so incident links survive.
3. **The mass-recovery guard will fire.** The Differ already warns when "a Differ
   pass recovered most of a system's open signals at once" — it fired for EntraID
   twice on 2026-09-04, so it is live. Decide whether that is expected noise or
   should be suppressed for this one migration.

**Size it before shipping**: count open synthetic findings per monitor on staging,
so the recovery burst is a known number rather than a surprise in the Platform
Log.

## User-facing deliverable

Stated plainly because this slice is thinner on screen than the others: the
deliverable is **one signal per synthetic failure instead of four**, and an
honest breadth sentence on it. The Signals list, the incident it opens and the
Business Application's priced count all stop multiplying by location count. No
new screen.

## Acceptance

- A three-location synthetic failing raises one signal, not four.
- A one-location synthetic failing raises one signal and reads as total failure,
  never as weak evidence.
- A synthetics monitor with no `total` group still raises per-group signals.
- A host-scoped monitor firing on five hosts still raises five signals —
  `correlation_memory`'s behaviour is unchanged.
- The migration's recovery burst matches the number counted beforehand.
