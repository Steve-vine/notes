---
id: 01KXX7NWH0C4E6VETBFC9WW9BS
created: 2026-07-19T13:05:05.568792449Z
updated: 2026-07-21T08:39:05.477971Z
type: task
title: Integration Types surfaced — Type-aware "add integration" (Settings)
project: 01KX671DATY39VW6GWK3M2T3DN
number: 146
sprint: sehghhk
blocked_by:
- 01KXX7NQ54DS82RCM7PQ0HVD84
assignee: steve
priority: high
task_status: done
---
**Sprint 15 (vertical slice: backend + UI).** Make adding an integration a matter of picking a tested Type, not editing Helm values.

- **Backend**: expose the registered, capability-declared **Integration Types** (registry) via API — each Type's declared capabilities + its `credential_spec` (already drives the credential form fields).
- **UI**: the **Settings → Integrations** add flow becomes: pick a Type → see its declared capabilities + required credentials → configure the instance. The form is generated from the Type's declared spec, so a new Type gets a correct form for free.

**DoD**: an admin adds an integration by choosing a Type from the UI; the credential/config form is driven entirely by that Type's declared spec, and the new integration appears with its capabilities. Not done until the Type-picker add flow works end to end.

Depends on ADR 0031.