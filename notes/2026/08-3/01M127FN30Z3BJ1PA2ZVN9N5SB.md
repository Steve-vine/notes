---
id: 01M127FN30Z3BJ1PA2ZVN9N5SB
created: 2026-08-27T18:24:58.97604Z
updated: 2026-08-29T00:06:46.273271Z
type: task
title: A tier is proposed from three answers, and a person can disagree with a reason
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 473
sprint: sd9gmcq
blocked_by:
- 01M127F6P0SAQ61MDHSKEC5S10
- 01M127FB3P0K03SP70SSQ7KVJS
comments:
- id: 01M159KFD5KV1QDZ4CC0MSGF68
  author: Steve Vine
  at: 2026-08-28T22:59:44.676883Z
  text: |-
    PR #488 open, rebased onto main after COM-472 landed.

    `core/vendor_risk_tier.py` is the one place a tier is worked out. The proposal is the highest tier whose thresholds any *single* input meets — nothing averaged, summed or multiplied, because averaging lets a supplier with production access be pulled down to Medium by the fact we could live without them for a fortnight.

    Three distinctions the code makes deliberately, each with its own test:

    - **Nothing known is not Low.** Low is a claim that we looked; null says nobody has.
    - **A null threshold matches nothing** — that is what "this dimension can never reach this tier on its own" means, and it is how Restricted data stops at High.
    - **A null value matches nothing either.** An unclassified access rung must not trip the top tier.

    Thresholds are read from the rows, never from `RISK_TIER_SCALE`, so the derivation cannot ignore what an admin changed in Settings — that has a test too.

    The engagement gains `risk_tier` (effective, stored), `risk_tier_override` and a required `risk_tier_override_reason`. The override moves **either way**, and the reason is required in both directions: a raise nobody explained is as unreadable a year later as a drop nobody explained. The proposal is recomputed on every read and sent beside the effective tier, so an override reads as "Proposed High, set to Medium because …". A tier that agrees with its proposal shows the pill alone — noise on every row that has nothing to explain is how a reader learns to skip the line that matters.

    One helper writes the column, called from engagement create/edit, a requested engagement, an approved amendment — **and a rubric edit**, which is the input that lives nowhere near an engagement. An admin who lowers a threshold has changed the answer for the whole register.

    Tests: 8 pure over the derivation + 14 integration + 3 frontend.
assignee: steve
company: null
label:
- feature
priority: medium
task_status: review
---
ADR 0060 §3–4. `core/vendor_risk_tier.py` — the one place a tier is worked out, the shape `core/vendor_criticality.py` sets. Inputs: the engagement's effective sensitivity (highest across its data types, ADR 0042 §4), its access rung, its criticality. The proposal is the **highest tier whose thresholds any one of them meets**. Highest wins — never averaged, summed or multiplied, or a supplier with production access gets pulled down to Medium by the fact we could live without them for a fortnight.

Engagement gains `risk_tier` (stored — a filter and a group-by, not a display field), `risk_tier_override`, and `risk_tier_override_reason`, **required** when the override is set.

The override may move the tier **either way** — unlike `criticality_override`, which is a raise-only floor. Criticality is a claim about a fact; the tier is a judgement about a composite, and the edge cases are real in both directions. The reason is what makes a downward move a governance record rather than a loophole.

The proposal is always recomputed and always shown: "Proposed High — set to Medium because …", never just the number. Recompute from every path that can change data types, access or criticality.