---
id: 01KXWRPY84HMDDPDACCEEQPQED
created: 2026-07-19T08:43:31.460086116Z
updated: 2026-07-19T11:52:33.57252949Z
type: task
title: Split the nav into Incidents / Alerts / Observations
priority: high
assignee: steve
label:
- feature
task_status: done
project: 01KX671DATY39VW6GWK3M2T3DN
number: 123
sprint: stgj737
tech: null
---
**UI (follow-on to ISE-117).** Surface the ADR 0025 layers as three distinct menu sections instead of one flat Issues list.

- **Incidents** — the durable records (today's Issues screen, relabelled). Keep the existing route/detail.
- **Alerts** — signals with `signal_type='alert'` (populated now: all DataDog/K8s signals).
- **Observations** — signals with `signal_type='observation'` (empty until the Obs Loop, Sprint 14 — shows a clear "nothing yet" state).

Backend: add a `signal_type` filter to `GET /api/v1/findings` (additive). Frontend: nav split, a shared Signals list component for Alerts/Observations (severity, title, system, kind, signal status, confidence, last-seen), rename the Issues page to Incidents. Vitest + api-types regen.