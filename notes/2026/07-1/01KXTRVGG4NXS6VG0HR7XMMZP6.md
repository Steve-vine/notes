---
id: 01KXTRVGG4NXS6VG0HR7XMMZP6
created: 2026-07-18T14:07:32.356922267Z
updated: 2026-07-19T13:25:11.021601254Z
type: task
title: 'ADR: Signals & Incidents model'
priority: high
label:
- brief
assignee: steve
task_status: done
project: 01KX671DATY39VW6GWK3M2T3DN
number: 110
sprint: stgj737
---
**Sprint 11 (spine).** Record the decision to split detection into transient, machine-owned **Signals** (Alerts + Observations) flowing onto durable, human-owned **Incidents**, superseding the 1:1 `Finding → promotion → Issue` mapping. Extends ADR 0024. Source of truth: the **ISE Canon** (Notuvia memo linked to this project).

Covers: the two-layer model; the "defer detection to a source with its own detection layer, else ISE detects" principle (Alert vs Observation); signal statuses (Triggered/New, Recurring, Recovered, Ignored, Resolved-*derived*) and the resolution-cascade rule (Resolved never set directly; Ignore = durable suppression; continuously-firing early-resolve bounces unless Ignored); Incident statuses (New/Active/Resolved/Reactivated/Closed); ingest correlation (1 signal → 1 *open* Incident by stable key; recovered-and-re-triggered re-attaches; recurrence after Closed = new Incident; key persists on Resolved-but-not-Closed); merge is AI-proposed / human-confirmed.

Deliverable: append-only `docs/decisions/NNNN-signals-and-incidents.md`. Gates the model work (Incident/Signal tasks) in this sprint.