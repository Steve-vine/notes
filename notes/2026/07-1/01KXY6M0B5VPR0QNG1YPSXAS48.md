---
id: 01KXY6M0B5VPR0QNG1YPSXAS48
created: 2026-07-19T22:05:49.797816891Z
updated: 2026-07-22T08:29:20.945417Z
type: task
title: Escalate an open incident when its signal's severity rises
project: 01KX671DATY39VW6GWK3M2T3DN
number: 152
sprint: sohzsw2
label: null
priority: high
task_status: backlog
---
**Bug (pre-Sprint 14, promotion.py / ADR 0025).** A signal that worsens while its incident is already open never re-grades the incident, so an escalation is invisible.

**Found in prod 2026-07-19.** DataDog monitor "Low Disk Space" (`monitor/248505`) first fired as **Warn** → opened incident **#1000** at `medium`, title "…is Warn". It later escalated to **Alert** → the finding is now `high`/`triggered`, but #1000 is still `open`/`medium`/"is Warn". Result: a High alert on the Alerts screen with **no High incident** — it reads as "the alert never created an incident."

**Cause.** Correlation is by `monitor/{id}` (state-independent — correct for dedup). But `promote_findings` only *opens* (issue is None) or *reactivates* (issue resolved + finding recurring). There is no branch for an **open** incident whose signal's effective severity has risen above the incident's current severity.

**Fix.** Add an escalation path, the mirror of reactivation: when a firing signal's `effective_severity` exceeds its live incident's severity, escalate the incident — bump `severity`, refresh the title, add a timeline note ("escalated medium→high"), and re-notify. Consider de-escalation semantics too (probably NOT auto-lower — leave that to the human, consistent with ADR 0025's human-owned incident). May warrant a short note against ADR 0025 since it extends the incident lifecycle.

**DoD.** A monitor going Warn→Alert re-grades its open incident to high (visible + timeline entry); a fresh sync in a test reproduces the escalation deterministically.