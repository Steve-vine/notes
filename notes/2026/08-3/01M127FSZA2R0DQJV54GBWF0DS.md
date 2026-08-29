---
id: 01M127FSZA2R0DQJV54GBWF0DS
created: 2026-08-27T18:25:03.978757Z
updated: 2026-08-29T00:20:05.717522Z
type: task
title: A vendor is as risky as its worst engagement
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 474
sprint: sd9gmcq
blocked_by:
- 01M127FN30Z3BJ1PA2ZVN9N5SB
comments:
- id: 01M159KPGGKTQARQBVJ2VWG43N
  author: Steve Vine
  at: 2026-08-28T22:59:51.952013Z
  text: |-
    PR #489 open, rebased onto COM-473.

    `vendors.risk_tier` is the max **effective** tier across non-ended engagements — max over the *tiers*, never a re-derivation from rolled-up inputs. That has its own test: Restricted data on one engagement plus a way into our systems on another stays **High**, because rolling the inputs up first would invent a phantom engagement holding both and land most of the register at Critical.

    `ended` drops out, `proposed` counts (COM-218's rules). A vendor with no live engagement has no tier — never folded into Low, and both the register filter (`tier=unassessed`) and the dashboard tile offer it as a list to work off.

    The vendor's override is a **floor**, unlike the engagement's own which moves either way. An engagement is one piece of work someone can judge whole; a vendor is a summary, and lowering the summary below what its engagements claim would contradict the record without changing it. The 422 points at the engagement as the place that argument belongs.

    Every surface names the engagement — "High, from Payroll processing" — on the header and the register. The register column sits **ahead of Criticality**: the tier is the answer, criticality is one of the inputs.

    Two things this forced, both worth noting:

    - Both rollups now run from one helper and write **one** revision; `vendor_revisions` gains both columns. A guard-rail test on snapshot-field labels caught the omission.
    - `VendorRiskTier` moved from `models/vendor_risk_tier.py` to `models/vendor.py` beside `VendorCriticality` — the `vendors` table now carries a column of it, so leaving the enum in the rubric module would make the two files import each other. Same shape `VendorCriticality`/`VendorCriticalityLevel` already had.

    Tests: 15 integration + 2 frontend.
assignee: steve
company: null
label:
- feature
priority: medium
task_status: review
---
ADR 0060 §5. `vendors.risk_tier` as a stored rollup — the max **effective tier** across non-ended engagements — with `risk_tier_override` beside it carrying the same floor semantics as `criticality_override`, and the same COM-218 rules: `ended` drops out, `proposed` still counts.

**Max of the tiers, never a recomputation from rolled-up inputs.** Rolling the three dimensions up first invents an engagement nobody has — Restricted data on one engagement plus production access on another would score as though a single engagement did both, and most of the register would land Critical.

Always name the engagement that drives it: "High — from *Payroll processing*", on the vendor header and in the register. A vendor with no engagements has no tier; "not yet assessed" is honest and the list of them is worth pulling.

Surfaces: register column + filter, vendor header pill, dashboard tile.