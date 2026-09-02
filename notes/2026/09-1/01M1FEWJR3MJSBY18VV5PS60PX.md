---
id: 01M1FEWJR3MJSBY18VV5PS60PX
created: 2026-09-01T21:44:30.21178Z
updated: 2026-09-02T21:48:26.203489Z
type: task
title: 'The Correlator: escalation becomes a business judgement'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 764
sprint: s7nj09w
assignee: steve
label:
- feature
priority: medium
task_status: todo
tech: null
---
The load-bearing change in ADR 0107. `promotion.promote_findings` leaves the sync transaction, becomes the Correlator, and gains the input it has never had.

**An Incident is created here and nowhere else.** A signal that is not escalated remains an Alert or an Observation, retained and inspectable rather than discarded.

Escalation stops being severity-and-policy alone and starts reading the definitions: Business Criticality, and what the affected entity is *for*.

**Its first real correlation, now concrete (ADR 0109).** Deriving a capability's state means reading signals across several entities and drawing one service-level conclusion — is the primary provider impaired, is a later one carrying it, are they all gone. That is genuine correlation rather than deduplication, and it arrives as a by-product of the capability model rather than as a feature of its own.

Today `correlation_key` is `f"{system_id}:{source_key}"` — a dedup key — and of 240 incidents, 232 have exactly one signal and none have more.

**Also in scope:** the unassessed path. A signal on a member no capability covers must resolve to neither "fine" nor "the service is down"; it inherits the service's criticality, carries no impact claim, and is marked unassessed. Never silently zero.

**Blocked by** the prioritisation vocabulary (ISE-759) — ADRs 0108 and 0109 have settled the definitions, but how criticality and capability state combine into a priority is still open.