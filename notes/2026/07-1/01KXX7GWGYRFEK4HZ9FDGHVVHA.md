---
id: 01KXX7GWGYRFEK4HZ9FDGHVVHA
created: 2026-07-19T13:02:21.726502098Z
updated: 2026-07-21T16:49:42.146706Z
type: task
title: Recall — "ISE has seen this before" on an incident
project: 01KX671DATY39VW6GWK3M2T3DN
number: 134
sprint: sdv8hgy
blocked_by:
- 01KXX7GQ768AF51YSG343DXQBA
assignee: steve
label: null
priority: high
task_status: done
---
**Sprint 13 (vertical slice: backend + UI).** The front bookend of the Incident Loop — reframe an incident from "solve from scratch" to "verify a prior".

- **Backend**: `incident_memory` model (past incident instances) + **trigger-signature** computation (from signal identity + affected entity, hung off the entity graph, ISE-128) + cheap retrieval when an incident opens. Loose recall, biased to safe over-matching (recall never acts).
- **UI**: a **Recall panel** at the top of the incident conversation timeline (`IssueDetailPage`) showing matched prior incidents and their outcomes — "seen 3× before; last resolved by scaling checkout".

**DoD**: opening an incident that matches a past one shows the Recall panel with the prior instances and how they were resolved; a genuinely novel incident shows "no prior history". Not done until the panel renders on a real incident.

Depends on ADR 0029. Builds on the entity graph (Sprint 12).