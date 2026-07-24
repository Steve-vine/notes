---
id: 01KXX7NQ54DS82RCM7PQ0HVD84
created: 2026-07-19T13:05:00.068980923Z
updated: 2026-07-24T12:32:38.332275Z
type: task
title: 'ADR: In-process integration modularity + generic MCP Evidence'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 145
sprint: sehghhk
assignee: steve
label: null
priority: high
task_status: done
---
**Sprint 15 foundation.** Codify the in-process modularity step as ADR 0031 (extends ADR 0027).

- **Integration Type** (developer-built connector code) → **Integration** (admin-configured instance = today's `System`) → **User**. The bright line: coding = developer, instantiating a tested Type = admin, everything else = user.
- **Declared, optional capabilities** (Alerts / Observations / Entities / Evidence / Actions + lifecycle); the platform degrades gracefully by capability.
- A **generic MCP-backed Evidence Type** — near-zero per-source code for the read path (redeems ADR 0014). Governing principle: the more governance a capability needs, the less generic it can be — read-only Evidence generalises freely; Actions stay per-source and tier-classified.
- **Governance stays in core**: authorization never leaves core; a connector executes an already-approved `ActionSpec`, never self-authorises.
- **Explicitly defers** the out-of-process, independently-deployable, versioned-contract end-state to its own future ADR (Canon; ADR 0027 §6).

*No screen (ADR).*