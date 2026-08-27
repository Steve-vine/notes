---
id: 01M127FSZA2R0DQJV54GBWF0DS
created: 2026-08-27T18:25:03.978757Z
updated: 2026-08-27T18:25:40.519456Z
type: task
title: A vendor is as risky as its worst engagement
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 474
sprint: sd9gmcq
blocked_by:
- 01M127FN30Z3BJ1PA2ZVN9N5SB
assignee: steve
company: null
label:
- feature
priority: medium
task_status: backlog
---
ADR 0060 §5. `vendors.risk_tier` as a stored rollup — the max **effective tier** across non-ended engagements — with `risk_tier_override` beside it carrying the same floor semantics as `criticality_override`, and the same COM-218 rules: `ended` drops out, `proposed` still counts.

**Max of the tiers, never a recomputation from rolled-up inputs.** Rolling the three dimensions up first invents an engagement nobody has — Restricted data on one engagement plus production access on another would score as though a single engagement did both, and most of the register would land Critical.

Always name the engagement that drives it: "High — from *Payroll processing*", on the vendor header and in the register. A vendor with no engagements has no tier; "not yet assessed" is honest and the list of them is worth pulling.

Surfaces: register column + filter, vendor header pill, dashboard tile.