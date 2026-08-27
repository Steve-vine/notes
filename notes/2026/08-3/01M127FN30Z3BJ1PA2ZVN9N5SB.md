---
id: 01M127FN30Z3BJ1PA2ZVN9N5SB
created: 2026-08-27T18:24:58.97604Z
updated: 2026-08-27T18:24:58.97604Z
type: task
title: A tier is proposed from three answers, and a person can disagree with a reason
label: feature
priority: medium
assignee: steve
task_status: backlog
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 473
company: null
---
ADR 0060 §3–4. `core/vendor_risk_tier.py` — the one place a tier is worked out, the shape `core/vendor_criticality.py` sets. Inputs: the engagement's effective sensitivity (highest across its data types, ADR 0042 §4), its access rung, its criticality. The proposal is the **highest tier whose thresholds any one of them meets**. Highest wins — never averaged, summed or multiplied, or a supplier with production access gets pulled down to Medium by the fact we could live without them for a fortnight.

Engagement gains `risk_tier` (stored — a filter and a group-by, not a display field), `risk_tier_override`, and `risk_tier_override_reason`, **required** when the override is set.

The override may move the tier **either way** — unlike `criticality_override`, which is a raise-only floor. Criticality is a claim about a fact; the tier is a judgement about a composite, and the edge cases are real in both directions. The reason is what makes a downward move a governance record rather than a loophole.

The proposal is always recomputed and always shown: "Proposed High — set to Medium because …", never just the number. Recompute from every path that can change data types, access or criticality.