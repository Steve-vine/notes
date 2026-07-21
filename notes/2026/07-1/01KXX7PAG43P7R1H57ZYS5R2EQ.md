---
id: 01KXX7PAG43P7R1H57ZYS5R2EQ
created: 2026-07-19T13:05:19.876358126Z
updated: 2026-07-21T18:32:08.507389Z
type: task
title: Generic MCP-backed Evidence Integration Type
project: 01KX671DATY39VW6GWK3M2T3DN
number: 148
sprint: sehghhk
blocked_by:
- 01KXX7NWH0C4E6VETBFC9WW9BS
assignee: steve
label: null
priority: high
task_status: done
---
**Sprint 15 (vertical slice: backend + UI).** The payoff of the capability contract — connect a new read-only source with near-zero bespoke code.

- **Backend**: a generic **MCP-backed Evidence** Integration Type that points at an MCP server and exposes its read tools as on-demand **Evidence** (ADR 0027). Read-only (fits the ADR 0023 spirit); authorization stays in core; user-added-source data is treated as untrusted context (prompt-injection surface).
- **UI**: an admin configures an MCP Evidence integration in **Settings → Integrations** (endpoint + credentials) via the Type-aware add flow; it then appears as a System declaring the **Evidence** capability.

**DoD**: an admin connects an MCP-exposing source through the UI and it provides Evidence during investigation with no per-source connector code. Not done until an MCP source is addable + usable from the UI.

Depends on Types surfaced.