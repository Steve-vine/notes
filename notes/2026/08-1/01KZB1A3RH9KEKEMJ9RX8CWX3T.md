---
id: 01KZB1A3RH9KEKEMJ9RX8CWX3T
created: 2026-08-06T07:58:52.177624Z
updated: 2026-08-07T08:35:09.191487Z
type: task
title: Migrate Kubernetes rate guards to threshold_specs
project: 01KX671DATY39VW6GWK3M2T3DN
number: 582
sprint: syjypmr
blocked_by:
- 01KZB18ZQNJVZGXRYY1ZWTT7S8
- 01KZB198WA3NK866R0GHVGE1TX
comments:
- id: 01KZB6DRRWEMB9P4FDAQVAGMC5
  author: Steve Vine
  at: 2026-08-06T09:28:14.87673Z
  text: |-
    Done — PR #495 (feature/ise-582-k8s-rate-guard-specs, stacked on #494).

    All three guards declared: `node_flap` (count, default 3, high), `placement_churn` (count, default 10, high) and `rate_guard_window` (minutes, default 30). Behaviour unchanged at defaults — the existing rate-guard tests pass **unmodified**.

    This is the one of the four migrations that actually changes what an operator can do, rather than just where a number is written. The other three were already overridable somehow; these were not overridable at all. ADR 0030's "refine against telemetry" note now has the channel it asked for, and it matters here specifically because how much churn reads as NORMAL is a property of an estate rather than of Kubernetes — a Karpenter cluster that scales hard all day and a fixed three-node cluster do not agree about what ten FailedScheduling events mean.

    **A design call the task didn't anticipate, worth recording.** The rate-guard window is not a trip point: it decides what is in scope to MEASURE, not what a measurement is WORTH. Declaring it with a severity would have been a fiction dressed as a ladder rung. So `ThresholdRung.severity` is now optional, and `None` marks a **scoping parameter** — with two rules enforced: a scoping parameter can never be a ladder (there is nothing to order rungs by), and asking one for a severity raises rather than returning `None`, because `None` there is indistinguishable from "trips nothing" and a detector would carry that wrong answer silently. The card renders such a row without a pill rather than with an invented one. ADR 0088 gains the section.

    Two other things worth noting:
    - Guards are resolved **once per detection pass** and threaded down. The event detectors walk every Warning event in the cluster; resolving config inside those loops would do thousands of lookups to reach one answer.
    - Signals now carry the **effective** guards in `details` (`flap_min_count`, `churn_min_count`, `window_minutes`). "x12, escalated" means nothing months later without the bar it crossed, and the bar is per-cluster now.

    The categorical severities stay categorical, as the task specified — Pending/CrashLoopBackOff/OOMKilled are judgements with no number in them — and there is a test pinning that no threshold claims to shape them.

    5 new tests; k8s suite green (55), full backend unit suite green (676), full frontend suite green (637). api-types regenerated.
assignee: steve
priority: medium
task_status: done
---
Declare the currently hard-coded, no-config-channel rate guards (`kubernetes.py:150-160`) as `ThresholdSpec`s: `_NODE_FLAP_MIN_COUNT = 3`, `_PLACEMENT_CHURN_MIN_COUNT = 10`, `_RATE_GUARD_WINDOW = 30min`. ADR 0030 explicitly flagged these as provisional ("shape-based, no staging churn baseline yet; refine against telemetry") — declaring them makes them tunable per cluster for the first time, which is exactly the refinement channel that note asked for.

Behaviour unchanged at defaults (churn escalation at `kubernetes.py:1988` still fires at the same counts). The categorical severities (Pending/CrashLoopBackOff/OOMKilled etc.) are NOT thresholds and stay as they are.

Acceptance: the three guards are visible/editable per k8s System in the generic card; existing rate-guard tests pass unmodified at defaults.