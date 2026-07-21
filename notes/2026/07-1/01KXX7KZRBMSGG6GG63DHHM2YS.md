---
id: 01KXX7KZRBMSGG6GG63DHHM2YS
created: 2026-07-19T13:04:03.33967298Z
updated: 2026-07-21T08:38:50.891449Z
type: task
title: Baseline of record ("normal") on the entity
project: 01KX671DATY39VW6GWK3M2T3DN
number: 142
sprint: srmqjcq
blocked_by:
- 01KXX7KDMJK1YACXH6N4JZYM7D
comments:
- id: 01KXXW59G994CR6MMYSNX6JPTW
  author: Steve Vine
  at: 2026-07-19T19:03:01.897439752Z
  text: |-
    Done. Per-entity baseline of record. PR #127 → main (backend/api-types/secret-scan green; frontend green on re-run — one pre-existing flaky App-render test, unrelated). Merged to staging (2b9ca0b). Review.

    EntityBaseline model (migration 0031); normal advances only on a healthy observation, current every run, deviation at read time; connector observe_baselines() (K8s workload/node health); reconciled in obs loop (baselines.py); GET /entities/{id}/baseline; Baseline card on entity detail. Not an open-rule input — display only.

    Note: frontend CI has a pre-existing flaky heavy App-render test (IssueLearning/IssueMerge/etc, findByText timeouts under load). I'll add a global asyncUtilTimeout bump on the ISE-141 branch to stop it recurring.
assignee: steve
label: null
priority: medium
task_status: done
---
**Sprint 14 (vertical slice: backend + UI).** Give the Obs Loop a sense of "normal" so deviation is meaningful.

- **Backend**: the loop captures a per-entity **baseline of record** (what normal looks like) and computes current deviation from it.
- **UI**: the baseline + current deviation are shown on the **entity detail (Estate)** and on an observation ("normal is X; now Y") — so an operator sees not just a value but whether it is abnormal.

**DoD**: an entity shows its captured baseline and how far current state deviates from it. Not done until the baseline renders on the entity detail.

Depends on the scheduler.