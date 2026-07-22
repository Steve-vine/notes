---
id: 01KY4XGWKKRYAJ0KYG2A3KDC8V
created: 2026-07-22T12:41:31.50762Z
updated: 2026-07-22T21:07:25.616386Z
type: task
title: Fix-at-source tag remediation via governed Actions
project: 01KX671DATY39VW6GWK3M2T3DN
number: 210
sprint: s5khymf
assignee: steve
label:
- feature
priority: low
task_status: active
---
Future model captured from the Tag Dictionary design (Canon, 2026-07-22) — deliberately unassigned to any sprint.

Today ISE never writes tags back to a source: the compliance report is a work list for humans. The future extension: from a compliance finding ("this host's `env:Prod` should be `env:prod`", "this workload is missing `env`"), ISE *proposes* the correction at the source (retag in DataDog, relabel in Kubernetes) through the governed Actions layer — default-deny, tiered approval, ADR 0017/0021 — so tag hygiene can be remediated from the same screen that surfaces it, with the same approval ceremony as any other infrastructure change.

Prereqs: Tag Dictionary shipped (Sprint 20); connector Actions for tag/label mutation classified in each `action_catalogue()`. Needs its own ADR when picked up (writes to source config are a new action class).