---
id: 01KZDRKXGZ234RPNCKBHEENEYC
created: 2026-08-07T09:24:39.583445Z
updated: 2026-08-07T09:40:27.131276Z
type: task
title: Role Matrix ADR + tier-tagged tool registry with derived parity tests
project: 01KX671DATY39VW6GWK3M2T3DN
number: 596
sprint: snk16ew
assignee: steve
label: null
priority: medium
task_status: todo
---
Formalise the "ISE Role Matrix" memo (Notuvia, 2026-08-07) as an ADR and make its invariants structural.

- ADR: the three-interface capability matrix (Assist / Incident Screen / Claude Code-MCP × Read / Write / read-only Execute / T0–T3 / BreakGlass), the rulings (proposals under gated Execute; Write = domain writes, audit exhaust exempt), and the role axis (cumulative ADR 0015 roles; token-never-outranks-owner over MCP; BreakGlass a per-user grant).
- Refactor: tag each AI tool with its tier (read / incident-log write / gated execute) in one registry; each surface declares the tiers it gets, replacing hand-assembled lists (`ASSIST_TOOLS` etc.).
- Tests: replace the frozen Assist allow-list with a derived parity assertion — every read-tier tool reaches all three surfaces (closes the known gap: Assist lacks `get_affected_entity_context`). Keep the writing-probe test.
- Record the decision in ISE Canon.

Headless-plus-tests slice by nature; the user-visible proof is Assist gaining the missing read tools, exercised by the question bank.