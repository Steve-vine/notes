---
id: 01M1FEWJR3MJSBY18VV5PS60PX
created: 2026-09-01T21:44:30.21178Z
updated: 2026-09-01T21:44:30.21178Z
type: task
title: 'The Correlator: escalation becomes a business judgement'
assignee: steve
label: feature
priority: medium
task_status: backlog
project: 01KX671DATY39VW6GWK3M2T3DN
number: 764
tech: null
---
The load-bearing change in ADR 0107. `promotion.promote_findings` leaves the sync transaction, becomes the Correlator, and gains the input it has never had.

**An Incident is created here and nowhere else.** A signal that is not escalated remains an Alert or an Observation, retained and inspectable rather than discarded.

Escalation stops being severity-and-policy alone and starts reading Business Services & Definitions: what the affected thing does, and how much it matters. This retires ADR 0025's promote-at-ingest behaviour.

**Also in scope:** whether the Correlator does any real correlation. Today `correlation_key` is `f"{system_id}:{source_key}"` — a dedup key — and of 240 incidents, 232 have exactly one signal and none have more. Grouping by shared subject, application or business service inside a window is newly possible now that entity binding is at 91%.

**Blocked by** the prioritisation vocabulary and Business Services & Definitions — without them the Correlator has no vocabulary to reason in.