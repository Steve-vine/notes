---
id: 01M1FEX10PXK5GGQ8DZN3H3Z5D
created: 2026-09-01T21:44:44.822023Z
updated: 2026-09-01T21:45:31.215814Z
type: task
title: Priority reaches the incident surface
project: 01KX671DATY39VW6GWK3M2T3DN
number: 766
sprint: s7nj09w
assignee: steve
label:
- feature
priority: medium
task_status: backlog
tech: null
---
Put the Correlator's judgement in front of an operator, in the vocabulary the prioritisation spec defines.

An incident should say what it is, how important it is, **and why** — which business service it affects, what breaks for the business, and what the priority rests on. "P1 because call routing falls back to round robin" is a claim an operator can act on or argue with; a bare severity is not.

Covers the incident list and detail, and the filters that let someone see only what would wake them up.

**Also the noise fix's visible half:** once the Differ passes change rather than state and the Correlator escalates on business importance, the incident queue should measurably shrink. Worth measuring before and after — today 119 incidents are open, of which the flaking-synthetic class is a large share.

**Blocked by** the prioritisation vocabulary spec and the Correlator.