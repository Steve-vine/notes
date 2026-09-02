---
id: 01M1FEV5GMPHKP0JE90S4T6MZ2
created: 2026-09-01T21:43:43.892228Z
updated: 2026-09-02T12:16:09.871587Z
type: task
title: 'Spec: Business Services and Definitions'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 758
sprint: s7nj09w
assignee: steve
label:
- brief
priority: high
task_status: done
tech: null
---
The first of ADR 0107's three deferred designs, and the one everything above the Correlator waits on. Produces an ADR.

**What it must settle.** Composition — tags are the primary source of what things are and how they relate, with direct selection from the Estate as the escape hatch for the legacy box that, if it fails, stops faxes. How that relates to what exists today: the tag dictionary, the Collections trio (Groups, Business applications, Business services) and `dashboard_service`. Whether this is one new authored object or a unifying read-model over those, and what it replaces.

**The new part** is business context in prose an operator can act on: *"this is critical for call assignment; if it breaks, call routing stops and calls fall back to round robin instead of skills-based"* — so ISE explains the problem rather than reporting that `app-skillrt-uk` is not responding.

**Why it is urgent.** Once the Correlator depends on this (ADR 0107), the currently near-empty asserted layers stop being a reporting gap and become the thing that decides what wakes someone up. Measured on staging: 1 `business-service` and 2 `business-application` entities against ~6,000 resources, with 198 proposals unworked.

**Done when** there is an accepted ADR covering composition, the manual override, business context, and the read contract the Correlator uses.