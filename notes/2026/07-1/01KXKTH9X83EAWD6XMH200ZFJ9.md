---
id: 01KXKTH9X83EAWD6XMH200ZFJ9
created: 2026-07-15T21:22:14.056220441Z
updated: 2026-07-21T09:54:08.308493Z
type: task
title: Ship ISE's logs to DataDog + make the break-glass alert real
project: 01KX671DATY39VW6GWK3M2T3DN
number: 75
sprint: sd1gs0p
assignee: steve
priority: high
task_status: backlog
---
**ISE is monitored by nothing — including the DataDog it integrates with.** No `/metrics`, no DD agent/annotations, no log shipping. The structured JSON logs (`logging_setup.py`, ADR 0010) go to a pod's stdout and **die there**.

## Why this is the enabler for the break-glass alert

ADR 0015 and `security-model.md` both promise an **alert on every break-glass use**. Today that "alert" is `logger.error("BREAK-GLASS LOGIN USED")` — an ERROR line into stdout that **nothing collects**, so **nobody is alerted by anything**. The alert and the log-shipping gap are the same gap.

## Scope

- Ship ISE's structured logs (and ideally basic metrics) to DataDog — the intent ADR 0010 already records ("can *later* be shipped to DataDog without reformatting"). DD agent autodiscovery annotations on the pods, or a log forwarder.
- A **DataDog monitor** on `break_glass_login` (the audit action already exists) that actually pages someone — the ADR 0015 promise, finally real.
- While the pipeline exists, monitors on sync failure and AI-run failure are cheap follow-on value.

A satisfying story: ISE monitored by a system ISE manages. **Decision already taken** (Sprint 6 planning): do this rather than a narrow one-off webhook. Staging-first.

Blocks: ISE-77 (the break-glass drill needs this alert to exist).