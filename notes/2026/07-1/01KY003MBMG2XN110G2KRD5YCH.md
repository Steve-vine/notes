---
id: 01KY003MBMG2XN110G2KRD5YCH
created: 2026-07-20T14:50:30.64404603Z
updated: 2026-07-24T14:48:58.233935Z
type: task
title: Make Alerts inspectable — show why a monitor fired, not just that it did
project: 01KX671DATY39VW6GWK3M2T3DN
number: 156
sprint: skj7tft
assignee: steve
priority: medium
task_status: done
---
**Found in use (smoke testing, 2026-07-20).** On the **Alerts** screen an operator can see that an alert triggered but nothing about *why* — there's no drill-in, no `details`, no link out to the source monitor. An alert you can't inspect is a half-built pane of glass.

**What already exists (just not surfaced):** each alert is a `finding` whose `details` payload carries, for DataDog, `{monitor_id, group (the triggering scope), state, type}`, plus severity, title, first/last-seen and the affected estate entity. `GET /api/v1/findings` already returns `details` — the Alerts table (`SignalsPage.tsx`) simply doesn't render it and rows aren't clickable.

**What is NOT in ISE, by design (ISE-150 / ADR 0031):** the metric timeseries / logs that made the monitor fire. Those are on-demand **Evidence**, fetched during an investigation, and live in DataDog — reached by diagnosing the incident the alert raised.

**Proposed (vertical slice, UI-first):**
- Click on an alert description to show its `details` — the monitor, the triggering group/scope, the state — in a legible form, not raw JSON.
- Deep-link out to the source (e.g. the DataDog monitor for `monitor_id`) so the full context is one click away.
- Where the alert has raised/updated an Incident, link to it — that's the path to the on-demand metric/log evidence via diagnose.
- Consider the same treatment for Observations (their `details` + confidence rationale).

**DoD:** from the Alerts screen, an operator can open any alert and see which monitor/scope/state it is, and jump to the source and (if promoted) its incident — without leaving ISE or reading raw JSON.

*Sibling gap noted separately: Kubernetes still declares the Evidence capability but doesn't implement the new evidence queries (only DataDog + the MCP type do) — a follow-up, not part of this.*